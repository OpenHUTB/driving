package com.xhb.pay.service.impl;

import com.fhs.common.constant.Constant;
import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.StringUtil;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.fhs.core.exception.ParamException;
import com.xhb.park.service.ParkMonthlyRuleService;
import com.xhb.pay.bean.PayInsideBalanceChangeLog;
import com.xhb.pay.bean.PayInsideCar;
import com.xhb.pay.bean.PayInsideContract;
import com.xhb.pay.bean.PayInsideRefund;
import com.xhb.pay.dao.PayInsideRefundDao;
import com.xhb.pay.dto.RefundInfoDTO;
import com.xhb.pay.service.PayInsideBalanceChangeLogService;
import com.xhb.pay.service.PayInsideCarService;
import com.xhb.pay.service.PayInsideContractService;
import com.xhb.pay.service.PayInsideRefundService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 内部用户账户退款(PayInsideRefund)表服务实现类
 *
 * @author makejava
 * @since 2019-05-31 17:06:10
 */
@Service("payInsideRefundService")
@DataSource("park")
public class PayInsideRefundServiceImpl extends BaseServiceImpl<PayInsideRefund> implements PayInsideRefundService {

    @Autowired
    private PayInsideBalanceChangeLogService balanceChangeLogService;

    @Autowired
    private PayInsideCarService payInsideCarService;

    @Autowired
    private PayInsideContractService payInsideContractService;

    @Autowired
    private PayInsideRefundDao payInsideRefundDao;

    @Override
    public boolean insertRefund(RefundInfoDTO refundInfoDTO) {
        PayInsideCar payInsideCar = payInsideCarService.selectById(refundInfoDTO.getInsideId());
        BigDecimal balance = new BigDecimal(payInsideCar.getBalance());
        balance = balance.subtract(new BigDecimal(refundInfoDTO.getRefundAmont()));

        //内部用户账户退款表
        PayInsideRefund payInsideRefund = new PayInsideRefund();
        payInsideRefund.preInsert(refundInfoDTO.getUserId());
        payInsideRefund.setId(idHelper.nextId());
        BeanUtils.copyProperties(refundInfoDTO, payInsideRefund);
        payInsideRefund.setIsSync(Constant.INT_FALSE);
        //内部用户余额变动日志表
        PayInsideBalanceChangeLog balanceChangeLog = new PayInsideBalanceChangeLog();
        balanceChangeLog.preInsert(refundInfoDTO.getUserId());
        BeanUtils.copyProperties(refundInfoDTO, balanceChangeLog);
        balanceChangeLog.setIsSync(Constant.INT_FALSE);
        balanceChangeLog.setPKey(payInsideRefund.getId());

        //如果不是储户租时段的话，多处理一个结束时间，更改Contract信息
        if (!ParkMonthlyRuleService.MONTHLY_TYPE_LEASE_HOUR.equals(payInsideCar.getMonthlyType())) {

            //月租户退款
            payInsideRefund.setIsContract(Constant.INT_TRUE);
            payInsideRefund.setContractId(refundInfoDTO.getContractId());
            this.insert(payInsideRefund);

            //月租结束时间更新
            PayInsideContract payInsideContract = payInsideContractService.selectById(refundInfoDTO.getContractId());
            payInsideContractService.updateSelectiveById(PayInsideContract.builder().id(refundInfoDTO.getContractId()).endDate(refundInfoDTO.getMonthlyEndDate()).remark(ConverterUtils.toString(payInsideContract.getRemark()) + "因用户退费,结束时间改为" + refundInfoDTO.getMonthlyEndDate()).isSync(Constant.INT_FALSE).build());

            //修改内部用户表结束时间
            payInsideCarService.updateSelectiveById(PayInsideCar.builder().id(refundInfoDTO.getInsideId()).endDate(refundInfoDTO.getMonthlyEndDate()).isSync(Constant.INT_FALSE).build());

            // 5 提前结束包月入账log
            balanceChangeLog.setId(idHelper.nextId());
            balanceChangeLog.setIsAdd(Constant.INT_TRUE);
            balanceChangeLog.setAmount(new BigDecimal(refundInfoDTO.getRefundAmont()).add(new BigDecimal(refundInfoDTO.getServiceAmount())).doubleValue());
            balanceChangeLog.setType(PayInsideBalanceChangeLogService.PAY_LOG_MONTH_AMOUNT_ADD);
            balanceChangeLog.setRemark("月租用户结束包月入账" + balanceChangeLog.getAmount() + "元,现结束日期为" + refundInfoDTO.getMonthlyEndDate());
            balanceChangeLogService.insert(balanceChangeLog);

            // 6 退款给客户log
            balanceChangeLog.setId(idHelper.nextId());
            balanceChangeLog.setIsAdd(Constant.INT_FALSE);
            balanceChangeLog.setAmount(refundInfoDTO.getRefundAmont());
            balanceChangeLog.setType(PayInsideBalanceChangeLogService.PAY_LOG_REFUND_TO_CUST);
            balanceChangeLog.setRemark("退款给客户" + payInsideCar.getOwnerName() + "," + refundInfoDTO.getRefundCusName() + "接收退款" + refundInfoDTO.getRefundAmont() + "元");
            balanceChangeLogService.insert(balanceChangeLog);

            if (refundInfoDTO.getServiceAmount() > 0d) {
                //月租退款手续费
                balanceChangeLog.setId(idHelper.nextId());
                balanceChangeLog.setAmount(refundInfoDTO.getServiceAmount());
                balanceChangeLog.setType(PayInsideBalanceChangeLogService.PAY_LOG_SERVICE_AMOUNT);
                balanceChangeLog.setRemark("收取月租用户退款手续费:" + refundInfoDTO.getServiceAmount());
                balanceChangeLogService.insert(balanceChangeLog);
            }

        } else {
            //储户时段租用户退款
            payInsideRefund.setIsContract(Constant.INT_FALSE);
            this.insert(payInsideRefund);

            //7 余额退款手续费log
            if (!CheckUtils.isNullOrEmpty(refundInfoDTO.getServiceAmount()) && refundInfoDTO.getServiceAmount() > 0d) {
                balance = balance.subtract(new BigDecimal(refundInfoDTO.getServiceAmount()));
                balanceChangeLog.setId(idHelper.nextId());
                balanceChangeLog.setAmount(refundInfoDTO.getServiceAmount());
                balanceChangeLog.setIsAdd(Constant.INT_FALSE);
                balanceChangeLog.setType(PayInsideBalanceChangeLogService.PAY_LOG_SERVICE_AMOUNT);
                balanceChangeLog.setRemark("储户时段租用户,余额退款手续费" + refundInfoDTO.getServiceAmount() + "元");
                balanceChangeLogService.insert(balanceChangeLog);
            }

            //8 赠送金额扣除log
            if (!CheckUtils.isNullOrEmpty(refundInfoDTO.getDeductGiveAmount()) && refundInfoDTO.getDeductGiveAmount() > 0d) {
                balance = balance.subtract(new BigDecimal(refundInfoDTO.getDeductGiveAmount()));
                balanceChangeLog.setId(idHelper.nextId());
                balanceChangeLog.setAmount(refundInfoDTO.getDeductGiveAmount());
                balanceChangeLog.setIsAdd(Constant.INT_FALSE);
                balanceChangeLog.setType(PayInsideBalanceChangeLogService.PAY_LOG_GIVEAMOUNT_DEDUCT);
                balanceChangeLog.setRemark("储户时段租用户退费,赠送金额扣除:" + refundInfoDTO.getDeductGiveAmount() + "元");
                balanceChangeLogService.insert(balanceChangeLog);
            }

            if (balance.doubleValue() < 0d) {
                throw new ParamException("扣除赠送金额+退款金额+服务费不能大于账户余额");
            }

            // 6 退款给客户log
            balanceChangeLog.setId(idHelper.nextId());
            balanceChangeLog.setAmount(refundInfoDTO.getRefundAmont());
            balanceChangeLog.setIsAdd(Constant.INT_FALSE);
            balanceChangeLog.setType(PayInsideBalanceChangeLogService.PAY_LOG_REFUND_TO_CUST);
            balanceChangeLog.setRemark("储户时段租用户,退款给客户" + refundInfoDTO.getRefundAmont() + "元");
            balanceChangeLogService.insert(balanceChangeLog);

            //用户余额
            payInsideCarService.updateSelectiveById(PayInsideCar.builder().id(refundInfoDTO.getInsideId()).balance(balance.doubleValue()).isSync(Constant.INT_FALSE).build());
        }
        return Boolean.TRUE;
    }

    @Override
    public List<PayInsideRefund> findPayInsideRefundListByCondition(Map<String, Object> paramMap) {
        return payInsideRefundDao.findPayInsideRefundListByCondition(paramMap);
    }

    @Override
    public int findCount(Map<String, Object> paramMap) {
        return payInsideRefundDao.findCount(paramMap);
    }

    @Override
    public PayInsideRefund findSum(Map<String, Object> paramMap) {
        return payInsideRefundDao.findSum(paramMap);
    }


}
