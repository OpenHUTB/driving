package com.xhb.report.service.impl;

import com.fhs.common.constant.Constant;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.DateUtils;
import com.fhs.common.utils.Logger;
import com.fhs.core.trans.TransService;
import com.github.liaochong.myexcel.core.DefaultExcelBuilder;
import com.github.liaochong.myexcel.core.DefaultStreamExcelBuilder;
import com.github.liaochong.myexcel.core.strategy.AutoWidthStrategy;
import com.xhb.common.FileUploader;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.dao.TempOrderReportDao;
import com.xhb.report.dto.*;
import com.xhb.report.service.*;
import com.xhb.report.vo.DailyReportVo;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * <per>
 * 临时订单报表
 *
 * @author wangjie
 * @Date 2019/5/31 15:10
 * </per>
 */
@Service
public class TempOrderReportServiceImpl implements TempOrderReportService {

    private static final Logger LOG = Logger.getLogger(TempOrderReportServiceImpl.class);

    @Autowired
    private FileUploader fileUploader; //文件

    @Autowired
    private TempOrderReportDao tempOrderReportDao;

    @Autowired
    private MonthlyReportService monthlyReportService;

    @Autowired
    private RechargeReportService rechargeReportService;

    @Autowired
    private RefundReportService refundReportService;

    @Autowired
    private TransService transService;

    @Autowired
    private HandLiftReportService handLiftReportService;

    //每页多少条数据
    static final int ONE_PAGE_ROWS = 1000;

    //月 临时订单数据加载器
    public static class MonthTempOrderExportDataLoader {

        private TempOrderReportDao tempOrderReportDao;

        private TransService transService;

        private Map<String, Object> paramMap;


        public MonthTempOrderExportDataLoader(TempOrderReportDao tempOrderReportDao, TransService transService, Map<String, Object> paramMap) {

            this.tempOrderReportDao = tempOrderReportDao;
            this.transService = transService;
            this.paramMap = paramMap;
        }

        public List<PayTempOrderExportDTO> getData(int pageNo) {
            //计算当前的start 去查询
            List<PayTempOrderExportDTO> payTempOrderExportDTOList = tempOrderReportDao.findPayTempOrderData(ConverterUtils.toLong(paramMap.get("parkId")),
                    paramMap.get("payTime").toString(), (pageNo - 1) * ONE_PAGE_ROWS, ONE_PAGE_ROWS);
            if (payTempOrderExportDTOList.size() > 0) {
                transService.transMore(payTempOrderExportDTOList);
                for (PayTempOrderExportDTO payTempOrderExportDTO : payTempOrderExportDTOList) {
                    if (payTempOrderExportDTO.getParkingTime() != null) {
                        payTempOrderExportDTO.setParkingTime(DateUtils.timeCount(Integer.parseInt(payTempOrderExportDTO.getParkingTime())));
                    }
                    if (payTempOrderExportDTO.getCashPay() != null && payTempOrderExportDTO.getCashPay().doubleValue() != 0) {
                        payTempOrderExportDTO.setPaymentType("现金缴费");
                    } else if (payTempOrderExportDTO.getIsAdvancePay() != null && payTempOrderExportDTO.getIsAdvancePay().intValue() == Constant.INT_TRUE) {
                        payTempOrderExportDTO.setPaymentType("场内扫码");
                    } else if (payTempOrderExportDTO.getIsAdvancePay() != null && payTempOrderExportDTO.getIsAdvancePay() == Constant.INT_FALSE && payTempOrderExportDTO.getGatePay() != null && payTempOrderExportDTO.getGatePay() != 0) {
                        payTempOrderExportDTO.setPaymentType("岗亭扫码");
                    } else {
                        payTempOrderExportDTO.setPaymentType("");
                    }
                    payTempOrderExportDTO.setOrderStatus(payTempOrderExportDTO.getTransMap().get("orderStatusName"));
                    payTempOrderExportDTO.setPayType(payTempOrderExportDTO.getTransMap().get("payTypeName"));
                    payTempOrderExportDTO.setRecordType(payTempOrderExportDTO.getTransMap().get("recordTypeName"));
                }
            }
            return payTempOrderExportDTOList;
        }

    }


    /**
     * 生成excel文件 workbook
     *
     * @param paramMap
     * @return
     */
    private Workbook exportMonthExcel(Map<String, Object> paramMap) {
        DailyReportVo dailyReportVo = tempOrderReportDao.findMonthData(paramMap);
        DailyReportVo dailyReportMonthly = monthlyReportService.findMonthlyAmount(paramMap);
        DailyReportVo dailyReportRecharge = rechargeReportService.findRechargeAmount(paramMap);
        DailyReportVo dailyReportRefund = refundReportService.findRefundAmount(paramMap);
        DailyReportVo dailyReportHand = handLiftReportService.findHandLiftAmount(paramMap);
        List<DailyReportVo> dailyReportVoList = new ArrayList<DailyReportVo>();
        if (dailyReportMonthly != null) {
            dailyReportVo.setSystemMonthly(dailyReportMonthly.getSystemMonthly());
            dailyReportVo.setPublicMonthly(dailyReportMonthly.getPublicMonthly());
            dailyReportVo.setAppMonthly(dailyReportMonthly.getAppMonthly());
        }
        if (dailyReportRecharge != null) {
            dailyReportVo.setSystemStorageCard(dailyReportRecharge.getSystemStorageCard());
        }
        if (dailyReportRefund != null) {
            dailyReportVo.setSystemRefund(dailyReportRefund.getSystemRefund());
            dailyReportVo.setRefundServiceAmount(dailyReportRefund.getRefundServiceAmount());
            dailyReportVo.setRefundGiveAmount(dailyReportRefund.getRefundGiveAmount());
        }
        if (dailyReportHand != null) {
            dailyReportVo.setCashPayLow(dailyReportHand.getCashPayLow());
            dailyReportVo.setRealIncome(dailyReportVo.getRealIncome() + dailyReportHand.getCashPayLow());
            dailyReportVo.setReceivable(dailyReportVo.getReceivable() + dailyReportHand.getCashPayLow());
        }
        dailyReportVoList.add(dailyReportVo);
        //月报表sheet创建
        Workbook workbook = DefaultExcelBuilder.of(DailyReportVo.class).build(dailyReportVoList);
        //构建第二个sheet 临时订单详情
        ExecutorService executorService = Executors.newFixedThreadPool(10);

        // 显式标明开始构建
        DefaultStreamExcelBuilder defaultExcelBuilder = DefaultStreamExcelBuilder.of(PayTempOrderExportDTO.class, workbook)
                .hasStyle().autoWidthStrategy(AutoWidthStrategy.COMPUTE_AUTO_WIDTH)
                .threadPool(executorService)
                .start();
        // 多线程异步获取数据并追加至excel，join等待线程执行完成
        List<CompletableFuture> futures = new ArrayList<>();
        MonthTempOrderExportDataLoader dataLoader = new MonthTempOrderExportDataLoader(tempOrderReportDao, transService, paramMap);
        long total = tempOrderReportDao.findTempCount(paramMap);
        long pageSize = total % ONE_PAGE_ROWS == 0 ? total / ONE_PAGE_ROWS : total / ONE_PAGE_ROWS + 1;
        //遍里总页数
        for (int i = 1; i <= pageSize; i++) {
            final int pageNo = i;
            CompletableFuture future = CompletableFuture.runAsync(() -> {
                List<PayTempOrderExportDTO> dataList = dataLoader.getData(pageNo);
                // 数据追加
                defaultExcelBuilder.append(dataList);
            });
            futures.add(future);
        }
        futures.forEach(CompletableFuture::join);
        // 最终构建
        workbook = defaultExcelBuilder.build();
        //构建第三个sheet 月租户包月明细
        List<MonthlyReportDTO> monthlyReportDTOList = monthlyReportService.findMonthlyDataList(paramMap);
        if (monthlyReportDTOList.size() > 0) {
            transService.transMore(monthlyReportDTOList);
            for (MonthlyReportDTO monthlyReportDTO : monthlyReportDTOList) {
                monthlyReportDTO.setRechargeType(monthlyReportDTO.getTransMap().get("rechargeTypeName"));
                monthlyReportDTO.setCollectorName(monthlyReportDTO.getTransMap().get("collectorNameUserName"));
            }
            workbook = DefaultExcelBuilder.of(MonthlyReportDTO.class, workbook).build(monthlyReportDTOList);
        }

        //构建第四个sheet  储值卡充值明细
        List<RechargeReportDTO> rechargeReportDTOList = rechargeReportService.findRechargeDataList(paramMap);
        if (rechargeReportDTOList.size() > 0) {
            transService.transMore(rechargeReportDTOList);
            for (RechargeReportDTO rechargeReportDTO : rechargeReportDTOList) {
                rechargeReportDTO.setRechargeType(rechargeReportDTO.getTransMap().get("rechargeTypeName"));
                rechargeReportDTO.setCollectorName(rechargeReportDTO.getTransMap().get("collectorNameUserName"));
            }
            workbook = DefaultExcelBuilder.of(RechargeReportDTO.class, workbook).build(rechargeReportDTOList);
        }

        //构建第五个sheet  退款明细
        List<RefundReportDTO> refundReportDTOList = refundReportService.findRefundDataList(paramMap);
        if (refundReportDTOList.size() > 0) {
            transService.transMore(refundReportDTOList);
            for (RefundReportDTO refundReportDTO : refundReportDTOList) {
                refundReportDTO.setCollectorName(refundReportDTO.getTransMap().get("collectorNameUserName"));
            }
            workbook = DefaultExcelBuilder.of(RefundReportDTO.class, workbook).build(refundReportDTOList);
        }

        //构建第六个sheet  手动抬杆详情
        List<HandLiftReportDTO> handLiftReportDTOList = handLiftReportService.findHandLiftDate(paramMap);
        if (handLiftReportDTOList.size() > 0) {
            workbook = DefaultExcelBuilder.of(HandLiftReportDTO.class, workbook).build(handLiftReportDTOList);
        }
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
        Workbook workbook = this.exportMonthExcel(task.getParamMap());
        return fileUploader.makeCommon(workbook);
    }

    /**
     * 查询月租户信息
     *
     * @param paramMap
     * @return
     */
    @Override
    public DailyReportVo findMonthData(Map<String, Object> paramMap) {
        return tempOrderReportDao.findMonthData(paramMap);
    }


}

