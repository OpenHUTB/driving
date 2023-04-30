package com.xhb.pay.service.impl;

import com.alicp.jetcache.Cache;
import com.alicp.jetcache.anno.CreateCache;
import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.JsonUtils;
import com.fhs.common.utils.Logger;
import com.fhs.core.db.ReadWriteDataSourceDecision;
import com.fhs.core.trans.TransService;
import com.github.liaochong.myexcel.core.DefaultStreamExcelBuilder;
import com.xhb.common.FileUploader;
import com.xhb.pay.dao.PayTempOrderReportDao;
import com.xhb.pay.dto.PayTempOrderDTO;
import com.xhb.pay.service.PayTempOrderReportService;
import com.xhb.report.bean.ReportTask;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * <per>
 * 生成报表任务
 *
 * @author wangy
 * @Date 2019/6/4 14:29
 * </per>
 */
@Service
public class PayTempOrderReportImpl implements PayTempOrderReportService {
    private static final Logger LOG = Logger.getLogger(PayTempOrderReportImpl.class);

    @Autowired
    private PayTempOrderReportDao payTempOrderReportDao;

    @Autowired
    private TransService transService;

    @Autowired
    private FileUploader fileUploader; //文件

    //每页多少条数据
    static final int ONE_PAGE_ROWS = 1000;

    //车辆出入场记录数据加载器
    public static class TempOrderExportDataLoader {

        private PayTempOrderReportDao payTempOrderReportDao;

        private TransService transService;

        private Map<String, Object> paramMap;

        public TempOrderExportDataLoader(PayTempOrderReportDao payTempOrderReportDao, TransService transService, Map<String, Object> paramMap) {
            this.payTempOrderReportDao = payTempOrderReportDao;
            this.transService = transService;
            this.paramMap = paramMap;
        }

        public List<PayTempOrderDTO> getData(int pageNo) {
            Map<String, Object> iparamMap = new HashMap<>();
            iparamMap.putAll(paramMap);
            iparamMap.put("pageNo", pageNo * ONE_PAGE_ROWS);
            iparamMap.put("rows", ONE_PAGE_ROWS);
            List<PayTempOrderDTO> payTempOrderDTOList = payTempOrderReportDao.findPayTempOrderList(iparamMap); //paramMap pageNO赋值错了
            if (payTempOrderDTOList.size() > 0) {
                transService.transMore(payTempOrderDTOList);
                for (PayTempOrderDTO payTempOrderDTO : payTempOrderDTOList) {
                    payTempOrderDTO.setParkName(payTempOrderDTO.getTransMap().get("parkName"));
                    payTempOrderDTO.setOutPortName(payTempOrderDTO.getTransMap().get("portName"));
                    payTempOrderDTO.setEnterPortName(payTempOrderDTO.getTransMap().get("enterPortPortName"));
                    payTempOrderDTO.setCollectorId(payTempOrderDTO.getTransMap().get("userName"));
                    payTempOrderDTO.setPayTypeName(payTempOrderDTO.getTransMap().get("payTypeName"));
                    payTempOrderDTO.setOrderStatusName(payTempOrderDTO.getTransMap().get("orderStatusName"));
                    payTempOrderDTO.setIsSyncName(payTempOrderDTO.getTransMap().get("isSyncName"));
                    payTempOrderDTO.setOfflinePayTypeName(payTempOrderDTO.getTransMap().get("offlinePayTypeName"));
                    payTempOrderDTO.setSynStatus(payTempOrderDTO.getTransMap().get("synStatusName"));
                    payTempOrderDTO.setCarType(payTempOrderDTO.getTransMap().get("carTypeName"));
                    if (CheckUtils.isNotEmpty(payTempOrderDTO.getParkingTime())) {
                        payTempOrderDTO.setParkingTime(toHourMinute(Integer.parseInt(payTempOrderDTO.getParkingTime())));
                    }
                }
            }
            return payTempOrderDTOList;
        }

        public String toHourMinute(Integer time) {
            StringBuffer parkingTime = new StringBuffer();
            if (time / (24 * 60) != 0) {
                parkingTime.append(time / (24 * 60) + "天");
            }
            if ((int) Math.floor((time % (24 * 60)) / 60) != 0) {
                parkingTime.append((int) Math.floor((time % (24 * 60)) / 60) + "小时");
            }
            parkingTime.append(time % 60 + "分");
            return parkingTime.toString();
        }
    }

    @Override
    public List<PayTempOrderDTO> findPayTempOrderList(Map<String, Object> paramMap) {
        return payTempOrderReportDao.findPayTempOrderList(paramMap);
    }

    @CreateCache(
            expire = 1800,
            name = "ordercount:"
    )
    private Cache<String, Integer> ordercountCache;

    @Override
    public int findPayTempOrderCount(Map<String, Object> paramMap) {
        Map notPagerMap = new HashMap();
        notPagerMap.putAll(paramMap);
        notPagerMap.remove("start");
        notPagerMap.remove("end");
        notPagerMap.remove("page");
        notPagerMap.remove("rows");
        String key = JsonUtils.map2json(notPagerMap);
        int reuslt = 0;
        if (ordercountCache.get(key) == null) {
            reuslt = payTempOrderReportDao.findPayTempOrderCount(paramMap);
            ordercountCache.put(key, reuslt);
            return reuslt;
        }
        if (ConverterUtils.toInt(ordercountCache.get(key)) > 1000) {
            new Thread(() -> {
                ReadWriteDataSourceDecision.setDataSource("park");
                ordercountCache.put(key, this.selectOrderCountFromDB(paramMap));
            }).start();
            return ordercountCache.get(key);
        }
        return payTempOrderReportDao.findPayTempOrderCount(paramMap);
    }

    private int selectOrderCountFromDB(Map<String, Object> paramMap) {
        return payTempOrderReportDao.findPayTempOrderCount(paramMap);
    }

    private Workbook exportPayTempOrderExcel(Map<String, Object> paramMap) {
        //创建一个线程池，可以同一时间容乃10条线程
        ExecutorService executorService = Executors.newFixedThreadPool(10);
        // 显式标明开始构建
        DefaultStreamExcelBuilder defaultExcelBuilder = DefaultStreamExcelBuilder.of(PayTempOrderDTO.class)
                .threadPool(executorService)
                .start();
        // 多线程异步获取数据并追加至excel，join等待线程执行完成
        List<CompletableFuture> futures = new ArrayList<>();
        TempOrderExportDataLoader tempOrderExportDataLoader = new TempOrderExportDataLoader(payTempOrderReportDao, transService, paramMap);
        long total = payTempOrderReportDao.findPayTempOrderCount(paramMap);
        long pageSize = total % ONE_PAGE_ROWS == 0 ? total / ONE_PAGE_ROWS : total / ONE_PAGE_ROWS + 1;
        for (int i = 0; i < pageSize; i++) {
            final int pageNo = i;
            CompletableFuture future = CompletableFuture.runAsync(() -> {
                List<PayTempOrderDTO> dataList = tempOrderExportDataLoader.getData(pageNo);
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
     * 创建月报表返回文件对象
     *
     * @param task
     * @return
     */
    @Override
    public File makeMonthReport(ReportTask task) {
        Workbook workbook = this.exportPayTempOrderExcel(task.getParamMap());
        return fileUploader.makeCommon(workbook);
    }
}
