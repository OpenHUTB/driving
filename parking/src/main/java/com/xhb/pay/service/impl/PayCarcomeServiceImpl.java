package com.xhb.pay.service.impl;

import com.alicp.jetcache.Cache;
import com.alicp.jetcache.anno.CreateCache;
import com.fhs.common.constant.Constant;
import com.fhs.common.excel.ExcelValidor;
import com.fhs.common.utils.*;
import com.fhs.core.api.annotation.AutowareYLM;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.fhs.core.db.ReadWriteDataSourceDecision;
import com.fhs.core.exception.ParamException;
import com.fhs.core.trans.TransService;
import com.github.liaochong.myexcel.core.DefaultStreamExcelBuilder;
import com.xhb.common.FileUploader;
import com.xhb.park.service.ParkMonthlyRuleService;
import com.xhb.pay.bean.PayCarcome;
import com.xhb.pay.bean.PayInsideCar;
import com.xhb.pay.dao.PayCarcomeDao;
import com.xhb.pay.dto.PayCarcomeExportDTO;
import com.xhb.pay.service.PayCarcomeExtService;
import com.xhb.pay.service.PayCarcomeService;
import com.xhb.pay.service.PayInsideCarService;
import com.xhb.pay.service.PayInsideContractService;
import com.xhb.report.bean.ReportTask;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadLocalRandom;

/**
 * 车辆入场记录表(PayCarcome)表服务实现类
 *
 * @author jackwong
 * @since 2019-03-13 14:56:27
 */
@Service("payCarcomeService")
@DataSource("park")
@AutowareYLM
public class PayCarcomeServiceImpl extends BaseServiceImpl<PayCarcome> implements PayCarcomeService {

    private static final Logger LOG = Logger.getLogger(PayCarcomeServiceImpl.class);
    /**
     * 最少有五位
     */
    private static final int LIKE_MATCHING_LENGTH = 5;

    @Autowired
    private PayCarcomeDao payCarcomeDao;

    @Autowired
    private TransService transService;

    @Autowired
    private FileUploader fileUploader; //文件
    @Autowired
    private PayInsideCarService payInsideCarService;

    @Autowired
    private PayCarcomeExtService payCarcomeExtService;

    @Autowired
    private PayInsideContractService payInsideContractService;

    static Set<String> NEED_CHECK_MOTHLY_TYPE = new HashSet<>();
    static {
        NEED_CHECK_MOTHLY_TYPE.add(ParkMonthlyRuleService.MONTHLY_TYPE_ALLDAY);
        NEED_CHECK_MOTHLY_TYPE.add(ParkMonthlyRuleService.MONTHLY_TYPE_DAYTIME);
        NEED_CHECK_MOTHLY_TYPE.add(ParkMonthlyRuleService.MONTHLY_TYPE_NIGHT);
    }


    private static class ImportDataValidator implements ExcelValidor {

        @Override
        public boolean validParam(Object param, String valid, StringBuilder errorBuilder, char colName, int rowIndex) {
            if (CheckUtils.isNullOrEmpty(param)) {
                errorBuilder.append("第" + rowIndex + "行，第" + colName + "列为必填;");
                return false;
            }
            boolean validedSuccess = false;
            if (valid.contains("ex.date")) {
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat(DateUtils.DATETIME_PATTERN);
                simpleDateFormat.setTimeZone(TimeZone.getTimeZone("GMT+8"));
                try {
                    simpleDateFormat.parse(param.toString());
                    validedSuccess = true;
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            if (!validedSuccess) {
                errorBuilder.append("第" + rowIndex + "行，第" + colName + "列输入有误;");
                return false;
            }
            return true;
        }
    }


    //每页多少条数据
    static final int ONE_PAGE_ROWS = 1000;

    //车辆出入场记录数据加载器
    public static class CarcomeExportDataLoader {

        private PayCarcomeDao payCarcomeDao;

        private TransService transService;

        private Map<String, Object> paramMap;

        public CarcomeExportDataLoader(PayCarcomeDao payCarcomeDao, TransService transService, Map<String, Object> paramMap) {
            this.payCarcomeDao = payCarcomeDao;
            this.transService = transService;
            this.paramMap = paramMap;
        }

        public List<PayCarcomeExportDTO> getData(int pageNo) {
            Map<String, Object> iparamMap = new HashMap<>();
            iparamMap.putAll(paramMap);
            iparamMap.put("pageNo", pageNo * ONE_PAGE_ROWS);
            iparamMap.put("rows", ONE_PAGE_ROWS);
            List<PayCarcomeExportDTO> payCarcomeExportDTOList = payCarcomeDao.findListData(iparamMap);
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

    @Override
    public List<PayCarcomeExportDTO> findListData(Map<String, Object> paramMap) {
        return payCarcomeDao.findListData(paramMap);
    }

    @Override
    public Long findCount(Map<String, Object> param) {
        Map notPagerMap = new HashMap();
        notPagerMap.putAll(param);
        notPagerMap.remove("page");
        notPagerMap.remove("rows");
        notPagerMap.remove("start");
        notPagerMap.remove("end");
        String key = JsonUtils.map2json(notPagerMap);
        long reuslt = 0;
        if (carcountCache.get(key) == null) {
            reuslt = payCarcomeDao.findCount(param);
            carcountCache.put(key, (int) reuslt);
            return reuslt;
        }
        if (ConverterUtils.toInt(carcountCache.get(key)) > 1000) {
            new Thread(() -> {
                ReadWriteDataSourceDecision.setDataSource("park");
                carcountCache.put(key, this.findCarCountFromDB(param));
            }).start();
            return carcountCache.get(key).longValue();
        }
        return payCarcomeDao.findCount(param);
    }

    private Integer findCarCountFromDB(Map<String, Object> param) {
        return payCarcomeDao.findCount(param).intValue();
    }

    /**
     * 生成excel文件 workbook
     *
     * @param paramMap
     * @return
     */
    @Override
    public Workbook exportCarcomeExcel(Map<String, Object> paramMap) {
        //创建一个线程池，可以同一时间容乃10条线程
        ExecutorService executorService = Executors.newFixedThreadPool(10);
        // 显式标明开始构建
        DefaultStreamExcelBuilder defaultExcelBuilder = DefaultStreamExcelBuilder.of(PayCarcomeExportDTO.class)
                .threadPool(executorService)
                .start();
        // 多线程异步获取数据并追加至excel，join等待线程执行完成
        List<CompletableFuture> futures = new ArrayList<>();
        CarcomeExportDataLoader carcomeExportDataLoader = new CarcomeExportDataLoader(payCarcomeDao, transService, paramMap);
        long total = payCarcomeDao.findCount(paramMap);
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
    public File makeCarcome(ReportTask task) {
        Workbook workbook = this.exportCarcomeExcel(task.getParamMap());
        return fileUploader.makeCommon(workbook);
    }


    @CreateCache(
            expire = 1800,
            name = "carcount:"
    )
    private Cache<String, Integer> carcountCache;



    @Override
    public int selectInsideInParkPlateNum(Long parkId, Long insideCarId, String plateNumber) {
        Integer num = payCarcomeDao.selectInsideInParkPlateNum(parkId, insideCarId, plateNumber);
        return num == null ? 0 : num.intValue();
    }

    /**
     * 入场记录批量导入
     *
     * @param paramMap
     * @param file
     * @return
     */
    @Override

    public Boolean batchImport(Map<String, Object> paramMap, MultipartFile file) {
        List<PayCarcome> carcomeList;
        try {


            carcomeList = ExcelUtils.formartExcelData(PayCarcome.class, file.getInputStream(),
                    "["
                            + "{'index':'a','valid':['required'],'field':'plateNumber'},"
                            + "{'index':'b','valid':['ex.date'],'field':'accessTime'},"
                            + "]"
                    , 0, 2, new ImportDataValidator());
        } catch (IllegalArgumentException e) {
            log.error("数据有问题:", e);
            throw new ParamException(e.getMessage());
        } catch (Exception e) {
            log.error("excel模板有问题:", e);
            throw new ParamException("请检查模板是否正确");
        }
        carcomeList.forEach(e -> {
            e.setGroupCode(ConverterUtils.toString(paramMap.get("groupCode")));
            e.setParkId(ConverterUtils.toLong(paramMap.get("parkId")));
            e.preInsert(ConverterUtils.toString(paramMap.get("sysUserId")));
            e.setSyncTime(DateUtils.getCurrentDateStr(DateUtils.DATETIME_PATTERN));
            e.setIsSync(Constant.INT_FALSE);
            e.setType(PayCarcomeService.TYPE_COME);
            e.setStatus(PayCarcomeService.STATUS_INIT);
            e.setRecordType(PayCarcomeService.RECORD_TYPE_TEMP);
        });
        super.batchInsert(carcomeList);
        return Boolean.TRUE;
    }

    /**
     * 批量修改支付状态为已支付
     */

    @Override
    public int batchUpdateStatus(String ids) {
        return payCarcomeDao.batchUpdateStatus(ids);
    }


    @Override
    public int insertJpa(PayCarcome entity) {
        payCarcomeExtService.insertJpa(entity.toExt());
        return super.insertJpa(entity);
    }

    @Override
    public int insert(PayCarcome entity) {
        return this.insertJpa(entity);
    }


}
