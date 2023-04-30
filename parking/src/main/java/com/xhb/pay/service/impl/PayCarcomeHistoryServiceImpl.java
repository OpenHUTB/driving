package com.xhb.pay.service.impl;

import com.fhs.common.utils.DateUtils;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.trans.TransService;
import com.fhs.redis.service.RedisCacheService;
import com.github.liaochong.myexcel.core.DefaultStreamExcelBuilder;
import com.xhb.common.FileUploader;
import com.xhb.park.service.ParkParkingService;

import com.xhb.pay.bean.PayCarcomeHistory;

import com.xhb.pay.dao.PayCarcomeDao;
import com.xhb.pay.dao.PayCarcomeExtDao;

import com.xhb.pay.dao.PayCarcomeHistoryDao;
import com.xhb.pay.dto.PayCarcomeExportDTO;
import com.xhb.pay.form.PayCarcomeForm;
import com.xhb.pay.service.PayCarcomeHistoryService;
import com.xhb.report.bean.ReportTask;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.io.File;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 车辆入场历史记录表
 */
@Service
public class PayCarcomeHistoryServiceImpl extends BaseServiceImpl<PayCarcomeHistory> implements PayCarcomeHistoryService {
    @Autowired
    private RedisCacheService<Long> redisCacheService;
    @Autowired
    private PayCarcomeHistoryDao payCarcomeHistoryDao;
    @Autowired
    private ParkParkingService parkParkingService;
    @Autowired
    private TransService transService;
    @Autowired
    private FileUploader fileUploader;
    @Autowired
    private PayCarcomeExtDao payCarcomeExtDao;
    @Autowired
    private PayCarcomeDao payCarcomeDao;

    //每页多少条数据
    private static final int ONE_PAGE_ROWS = 1000;
    private static final String KEY = "task:presync:carcome:";


    //车辆出入场记录数据加载器
    public static class CarcomeExportDataLoader {

        private PayCarcomeHistoryDao payCarcomeHistoryDao;

        private TransService transService;

        private Map<String, Object> paramMap;

        public CarcomeExportDataLoader(PayCarcomeHistoryDao payCarcomeHistoryDao, TransService transService, Map<String, Object> paramMap) {
            this.payCarcomeHistoryDao = payCarcomeHistoryDao;
            this.transService = transService;
            this.paramMap = paramMap;
        }
        public List<PayCarcomeExportDTO> getData(int pageNo) {
            Map<String, Object> iparamMap = new HashMap<>();
            iparamMap.putAll(paramMap);
            iparamMap.put("pageNo", pageNo * ONE_PAGE_ROWS);
            iparamMap.put("rows", ONE_PAGE_ROWS);
            List<PayCarcomeExportDTO> payCarcomeExportDTOList = payCarcomeHistoryDao.findListData(iparamMap);
            if (payCarcomeExportDTOList.size() > 0) {
                transService.transMore(payCarcomeExportDTOList);
                for (PayCarcomeExportDTO payCarcomeExportDTO : payCarcomeExportDTOList) {
                    payCarcomeExportDTO.setParkName(payCarcomeExportDTO.getTransMap().get("parkName"));
                    payCarcomeExportDTO.setPortName(payCarcomeExportDTO.getTransMap().get("portName"));
                    payCarcomeExportDTO.setCarColor(payCarcomeExportDTO.getTransMap().get("carColorName"));
                    payCarcomeExportDTO.setType(payCarcomeExportDTO.getTransMap().get("typeName"));
                    payCarcomeExportDTO.setStatus(payCarcomeExportDTO.getTransMap().get("statusName"));
                    payCarcomeExportDTO.setCarType(payCarcomeExportDTO.getTransMap().get("carTypeName"));
                    payCarcomeExportDTO.setRecordType(payCarcomeExportDTO.getTransMap().get("recordTypeName"));
                    payCarcomeExportDTO.setIsSync(payCarcomeExportDTO.getTransMap().get("isSyncName"));
                }
            }
            return payCarcomeExportDTOList;
        }
    }

    /**
     * 查询临时订单列表
     */
    @Override
    public List<PayCarcomeExportDTO> queryPayCarcomePage(PayCarcomeForm payCarcomeForm,Object obj) {
        if (payCarcomeForm.getAdmin() != 1){
            if(obj != null){
                payCarcomeForm.setParkIds(obj+"");
            }else {
                return new ArrayList<>();
            }
        }
        payCarcomeForm.setNum((payCarcomeForm.getPage() - 1L) * payCarcomeForm.getRows());
        List<PayCarcomeExportDTO> list =payCarcomeHistoryDao.queryPayCarcomePage(payCarcomeForm);
        transService.transMore(list);
        return list;
    }

    /**
     * 查询车辆进出详情
     */
    public PayCarcomeExportDTO queryPayCarcome(Long id){
        return payCarcomeHistoryDao.queryPayCarcome(id);
    }



    /**
     * 生成excel文件 workbook
     *
     * @param paramMap
     * @return
     */
    private Workbook exportCarcomeExcelHistory(Map<String, Object> paramMap) {
        //创建一个线程池，可以同一时间容乃10条线程
        ExecutorService executorService = Executors.newFixedThreadPool(10);
        // 显式标明开始构建
        DefaultStreamExcelBuilder defaultExcelBuilder = DefaultStreamExcelBuilder.of(PayCarcomeExportDTO.class)
                .threadPool(executorService)
                .start();
        // 多线程异步获取数据并追加至excel，join等待线程执行完成
        List<CompletableFuture> futures = new ArrayList<>();
        CarcomeExportDataLoader carcomeExportDataLoader = new CarcomeExportDataLoader(payCarcomeHistoryDao, transService, paramMap);
        long total = payCarcomeHistoryDao.conuntCarcome(paramMap);
        long pageSize = total % ONE_PAGE_ROWS == 0 ? total / ONE_PAGE_ROWS : total / ONE_PAGE_ROWS + 1;
        for (int i = 0; i < pageSize; i++) {
            final int pageNo = i;
            CompletableFuture future = CompletableFuture.runAsync(() -> {
                List<PayCarcomeExportDTO> dataList = carcomeExportDataLoader.getData(pageNo);
                // 数据追加
                defaultExcelBuilder.append(dataList);
            });
            futures.add(future);
        }
        futures.forEach(CompletableFuture::join);
        // 最终构建
        Workbook workbook = defaultExcelBuilder.build();
        executorService.shutdown();
        return workbook;
    }

    /**
     * 创建 出入场记录 返回文件对象
     *
     * @param task
     * @return
     */
    @Override
    public File makeCarcomeHistory(ReportTask task) {
        Workbook workbook = this.exportCarcomeExcelHistory(task.getParamMap());
        return fileUploader.makeCommon(workbook);
    }

    @Override
    public Long findCount(Map<String, Object> param) {
        return payCarcomeHistoryDao.conuntCarcome(param);
    }

    /**
     * 删除车辆进出场数据
     */
    public void delData2PayCarcomeHistory(Long id){
        payCarcomeHistoryDao.delData2PayCarcomeHistory(id);
        payCarcomeExtDao.delData2PayCarcomeExt(id);
    }

    /**
     * 修改车辆进出数据
     */
    public void updateData2PayCarcomeHistory(PayCarcomeForm payCarcomeForm){
        payCarcomeForm.setUpdateTime(DateUtils.formartDate(new Date(),DateUtils.DATETIME_PATTERN));
        payCarcomeHistoryDao.updateData2PayCarcomeHistory(payCarcomeForm);
        payCarcomeExtDao.updateData2PayCarcomeExt(payCarcomeForm);
        payCarcomeDao.updateData2PayCarcome(payCarcomeForm);
    }

    /**
     * 新增车辆进出数据
     */
    public void addData2PayCarcomeHistory(PayCarcomeForm payCarcomeForm){
        payCarcomeForm.setUpdateTime(DateUtils.formartDate(new Date(),DateUtils.DATETIME_PATTERN));
        payCarcomeHistoryDao.addData2PayCarcomeHistory(payCarcomeForm);
        payCarcomeExtDao.addData2PayCarcomeExt(payCarcomeForm);
        payCarcomeDao.addData2PayCarcome(payCarcomeForm);
    }
}
