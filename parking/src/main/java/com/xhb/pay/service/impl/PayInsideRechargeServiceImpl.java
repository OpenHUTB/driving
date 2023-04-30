package com.xhb.pay.service.impl;

import com.fhs.common.constant.Constant;
import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.StringUtil;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.fhs.core.trans.TransService;
import com.github.liaochong.myexcel.core.DefaultStreamExcelBuilder;
import com.xhb.common.FileUploader;
import com.xhb.park.service.ParkRegionLotService;
import com.xhb.pay.bean.PayInsideBalanceChangeLog;
import com.xhb.pay.bean.PayInsideCar;
import com.xhb.pay.bean.PayInsideRecharge;
import com.xhb.pay.dao.PayInsideRechargeDao;
import com.xhb.pay.dto.PayInsideRechargeExportDTO;
import com.xhb.pay.service.PayInsideBalanceChangeLogService;
import com.xhb.pay.service.PayInsideCarOnlinePayTempOrderService;
import com.xhb.pay.service.PayInsideCarService;
import com.xhb.pay.service.PayInsideRechargeService;
import com.xhb.report.bean.ReportTask;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 充值记录表(PayInsideRecharge)表服务实现类
 *
 * @author makejava
 * @since 2019-05-22 17:57:13
 */
@Service("payInsideRechargeService")
@DataSource("park")
public class PayInsideRechargeServiceImpl extends BaseServiceImpl<PayInsideRecharge> implements PayInsideRechargeService {

    @Autowired
    private PayInsideBalanceChangeLogService balanceChangeLogService;

    @Autowired
    private PayInsideRechargeDao payInsideRechargeDao;

    @Lazy
    @Autowired
    private PayInsideCarService payInsideCarService;

    @Autowired
    private ParkRegionLotService parkRegionLotService;

    @Autowired
    private FileUploader fileUploader; //文件

    @Autowired
    private PayInsideCarOnlinePayTempOrderService insideCarOnlinePayTempOrderService;

    @Autowired
    private TransService transService;

    @Override
    public void insertRecharge(PayInsideRecharge payInsideRecharge, int isSync) {
        payInsideRecharge.setId(idHelper.nextId());
        PayInsideCar payInsideCar = payInsideCarService.selectById(payInsideRecharge.getInsideId());
        BigDecimal balance = new BigDecimal(payInsideCar.getBalance());
        balance = balance.add(new BigDecimal(payInsideRecharge.getAmount()));
        super.insert(payInsideRecharge);
        PayInsideBalanceChangeLog balanceChangeLog = new PayInsideBalanceChangeLog();
        balanceChangeLog.preInsert(payInsideRecharge.getCreateUser());
        balanceChangeLog.setInsideId(payInsideRecharge.getInsideId());
        balanceChangeLog.setAmount(payInsideRecharge.getAmount());
        balanceChangeLog.setPKey(payInsideRecharge.getId());
        balanceChangeLog.setIsAdd(Constant.INT_TRUE);
        balanceChangeLog.setIsSync(isSync);
        balanceChangeLog.setParkId(payInsideRecharge.getParkId());
        balanceChangeLog.setType(PayInsideBalanceChangeLogService.PAY_LOG_RECHARGE);
        balanceChangeLog.setRemark("储户时段租充值" + payInsideRecharge.getAmount() + "元");
        balanceChangeLog.setId(idHelper.nextId());
        balanceChangeLogService.insert(balanceChangeLog);
        //有赠送充值记录
        if (payInsideRecharge.getGiveAmount() > 0d) {
            balanceChangeLog.setId(idHelper.nextId());
            balanceChangeLog.setType(PayInsideBalanceChangeLogService.PAY_LOG_GIVEAMOUNT);
            balanceChangeLog.setAmount(payInsideRecharge.getGiveAmount());
            balanceChangeLog.setRemark("储户时段租充值" + payInsideRecharge.getAmount() + "元,赠送" + payInsideRecharge.getGiveAmount() + "元");
            balanceChangeLogService.insert(balanceChangeLog);
            balance = balance.add(new BigDecimal(payInsideRecharge.getGiveAmount()));
        }
        payInsideCarService.updateSelectiveById(PayInsideCar.builder().id(payInsideRecharge.getInsideId()).balance(balance.doubleValue()).isSync(isSync).build());
    }

    /**
     * 查询储户时段租用户最后一次充值记录
     *
     * @param payInsideRecharge
     * @return
     */

    @Override
    public PayInsideRecharge findLastRecord(PayInsideRecharge payInsideRecharge) {
        return payInsideRechargeDao.findLastRecord(payInsideRecharge);
    }

    @Override
    public List<PayInsideRechargeExportDTO> findDateList(Map<String, Object> paramMap) {
        List<PayInsideRechargeExportDTO> dataList = payInsideRechargeDao.findDateList(paramMap);
        transService.transMore(dataList);
        for (PayInsideRechargeExportDTO recharge : dataList) {
            String lotIds = insideCarOnlinePayTempOrderService.selectLastRechargeRecord(recharge.getInsideId());
            if (!CheckUtils.isNotEmpty(lotIds)) {
                continue;
            }
            String[] ids = lotIds.split(",");
            List<String> lotInfos = new ArrayList<>();

            for (int j = 0; j < ids.length; j++) {
                lotInfos.add(parkRegionLotService.getLotAndRegionInfo(ConverterUtils.toLong(ids[j])));
            }
            recharge.getTransMap().put("lotInfo", StringUtil.getStrForIn(lotInfos, false));
            recharge.setPlateInfo(StringUtil.getStrForIn(lotInfos, false));
        }
        //翻译赋值
        for (PayInsideRechargeExportDTO payInsideRechargeExportDTO : dataList) {
            payInsideRechargeExportDTO.setIsContract(payInsideRechargeExportDTO.getTransMap().get("isContractName"));
            payInsideRechargeExportDTO.setFromType(payInsideRechargeExportDTO.getTransMap().get("fromTypeName"));
            payInsideRechargeExportDTO.setCreateUserName(payInsideRechargeExportDTO.getTransMap().get("createUserUserName"));
        }
        return dataList;
    }

    @Override
    public int findCount(Map<String, Object> paramMap) {
        return payInsideRechargeDao.findCount(paramMap);
    }

    @Override
    public PayInsideRecharge findSum(Map<String, Object> paramMap) {
        return payInsideRechargeDao.findSum(paramMap);
    }

    //导出
    private Workbook exportExcel(Map<String, Object> paramMap) {
        // 显式标明开始构建
        DefaultStreamExcelBuilder defaultExcelBuilder = DefaultStreamExcelBuilder.of(PayInsideRechargeExportDTO.class)
                .start();
        List<PayInsideRechargeExportDTO> dataList = this.findDateList(paramMap);
        defaultExcelBuilder.append(dataList);
        Workbook workbook = defaultExcelBuilder.build();
        return workbook;
    }

    @Override
    public File makeReport(ReportTask task) {
        Workbook workbook = this.exportExcel(task.getParamMap());
        return fileUploader.makeCommon(workbook);
    }

    @Override
    public List<Long> isRecharge(String ids) {
        return payInsideRechargeDao.isRecharge(ids);
    }

}
