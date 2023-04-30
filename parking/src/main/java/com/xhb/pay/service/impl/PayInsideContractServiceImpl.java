package com.xhb.pay.service.impl;

import com.fhs.common.constant.Constant;
import com.fhs.common.utils.CheckUtils;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.pay.bean.PayInsideBalanceChangeLog;
import com.xhb.pay.bean.PayInsideCar;
import com.xhb.pay.bean.PayInsideContract;
import com.xhb.pay.bean.PayInsideRecharge;
import com.xhb.pay.dao.PayInsideContractDao;
import com.xhb.pay.service.PayInsideBalanceChangeLogService;
import com.xhb.pay.service.PayInsideCarService;
import com.xhb.pay.service.PayInsideContractService;
import com.xhb.pay.service.PayInsideRechargeService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 内部车承包时间段表(PayInsideContract)表服务实现类
 *
 * @author makejava
 * @since 2019-05-22 17:53:07
 */
@Service("payInsideContractService")
@DataSource("park")
public class PayInsideContractServiceImpl extends BaseServiceImpl<PayInsideContract> implements PayInsideContractService {

    @Autowired
    private PayInsideBalanceChangeLogService payInsideBalanceChangeLogService;

    @Autowired
    private PayInsideRechargeService payInsideRechargeService;

    @Autowired
    private PayInsideContractDao payInsideContractDao;

    @Autowired
    private PayInsideCarService payInsideCarService;

    /**
     * 月租充值
     *
     * @param payInsideContract
     */

    public void insertContract(PayInsideContract payInsideContract) {
        payInsideContract.setFromType(1);
        //keng
        Double leaseMonthNum = payInsideContract.getLeaseMonthNum();
        payInsideContract.setLeaseMonthNum((double) Math.round(leaseMonthNum * 100) / 100);
        if (CheckUtils.isNullOrEmpty(payInsideContract.getGiveDayNum())) {
            payInsideContract.setGiveDayNum(0);
        }
        if (CheckUtils.isNullOrEmpty(payInsideContract.getGiveMonthMum())) {
            payInsideContract.setGiveMonthMum(0);
        }
        payInsideContract.setId(idHelper.nextId());
        super.insert(payInsideContract);
        PayInsideRecharge insideRecharge = new PayInsideRecharge();
        BeanUtils.copyProperties(payInsideContract, insideRecharge);
        insideRecharge.setId(idHelper.nextId());
        insideRecharge.setIsSync(Constant.INT_FALSE);
        insideRecharge.setIsContract(Constant.INT_TRUE);
        insideRecharge.setGiveAmount(0d);
        //月租充值时——添加充值记录
        payInsideRechargeService.insert(insideRecharge);
        //修改内部用户表结束时间
        payInsideCarService.updateSelectiveById(PayInsideCar.builder().id(payInsideContract.getInsideId()).endDate(payInsideContract.getEndDate()).isSync(Constant.INT_FALSE).build());
        PayInsideBalanceChangeLog balanceChangeLog = new PayInsideBalanceChangeLog();
        BeanUtils.copyProperties(insideRecharge, balanceChangeLog);
        balanceChangeLog.setPKey(payInsideContract.getId());
        balanceChangeLog.setId(idHelper.nextId());
        balanceChangeLog.setType(payInsideBalanceChangeLogService.PAY_LOG_MONTH_RECHARGE);
        balanceChangeLog.setIsAdd(Constant.INT_TRUE);
        balanceChangeLog.setRemark("包月充值" + payInsideContract.getLeaseMonthNum() + "月,赠送" + payInsideContract.getGiveMonthMum() + "月,赠送" + payInsideContract.getGiveDayNum() + "天,收取用户费用" + payInsideContract.getAmount() + "元");
        //月租充值时——添加余额变动日志
        payInsideBalanceChangeLogService.insert(balanceChangeLog);
        balanceChangeLog.setId(idHelper.nextId());
        balanceChangeLog.setType(payInsideBalanceChangeLogService.PAY_LOG_MONTH_REFUND);
        balanceChangeLog.setIsAdd(Constant.INT_FALSE);
        balanceChangeLog.setRemark("包月扣费" + payInsideContract.getAmount() + "元");
        //月租扣费时——添加余额变动日志
        payInsideBalanceChangeLogService.insert(balanceChangeLog);
    }

    /**
     * 查询最后一次充值记录
     *
     * @param payInsideContract
     * @return
     */

    @Override
    public PayInsideContract findLastRecord(PayInsideContract payInsideContract) {
        return payInsideContractDao.findLastRecord(payInsideContract);
    }

    /**
     * 查询用户是否在月租有效期内
     *
     * @param insideId
     * @return
     */

    @Override
    public int selectValidMonthly(Long insideId) {
        return payInsideContractDao.selectValidMonthly(insideId);
    }


}
