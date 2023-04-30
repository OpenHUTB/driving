package com.xhb.pay.service.impl;

import com.fhs.common.utils.ListUtils;
import com.fhs.common.utils.StringUtil;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.fhs.core.strategy.GenInfo;
import com.xhb.park.service.ParkMonthlyRuleService;
import com.xhb.pay.bean.PayInsideCar;
import com.xhb.pay.bean.PayInsidePlateBind;
import com.xhb.pay.service.PayCarcomeService;
import com.xhb.pay.service.PayInsideCarService;
import com.xhb.pay.service.PayInsideContractService;
import com.xhb.pay.service.PayInsidePlateBindService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 内部车和车牌号绑定记录(PayInsidePlateBind)表服务实现类
 *
 * @author makejava
 * @since 2019-05-22 17:54:52
 */
@Service("payInsidePlateBindService")
@DataSource("park")
public class PayInsidePlateBindServiceImpl extends BaseServiceImpl<PayInsidePlateBind> implements PayInsidePlateBindService {

    @Lazy
    @Autowired
    private PayInsideCarService payInsideCarService;


    @Autowired
    private PayCarcomeService payCarcomeService;

    @Lazy
    @Autowired
    private PayInsideContractService payInsideContractService;

    static Set<String> NEED_CHECK_MOTHLY_TYPE = new HashSet<>();

    static {
        NEED_CHECK_MOTHLY_TYPE.add(ParkMonthlyRuleService.MONTHLY_TYPE_ALLDAY);
        NEED_CHECK_MOTHLY_TYPE.add(ParkMonthlyRuleService.MONTHLY_TYPE_DAYTIME);
        NEED_CHECK_MOTHLY_TYPE.add(ParkMonthlyRuleService.MONTHLY_TYPE_NIGHT);
    }

    @Override
    public void insertPlateBind(PayInsidePlateBind payInsidePlateBind) {
        super.insert(payInsidePlateBind);
        updateplateNums(payInsidePlateBind.getInsideId());
    }

    @GenInfo
    @Override
    public int insertJpa(PayInsidePlateBind entity) {
        return super.insertJpa(entity);
    }

    @Override
    public void updatePlateBind(PayInsidePlateBind payInsidePlateBind) {
        super.updateSelectiveById(payInsidePlateBind);
        updateplateNums(payInsidePlateBind.getInsideId());
    }

    @Override
    public void deletePlateBind(Long id) {
        PayInsidePlateBind plateBind = super.selectById(id);
        super.deleteById(id);
        updateplateNums(plateBind.getInsideId());
    }

    /**
     * 更新内部车车牌
     *
     * @param insideId
     */
    private void updateplateNums(Long insideId) {
        List<PayInsidePlateBind> plateBindList = super.findForList(PayInsidePlateBind.builder().insideId(insideId).build());
        List<String> plateList = ListUtils.appendField(plateBindList, "plateNumber");
        String plateNums = StringUtil.getStrForIn(plateList, false);
        payInsideCarService.updateJpa(PayInsideCar.builder().id(insideId).plateNums(plateNums.equals("-10000") ? "" : plateNums).build());
    }


    /**
     * 判断是否月卡车
     *
     * @param plateNumber 车牌号
     * @param parkId      停车场id
     * @param nowTime     当前时间
     * @return 是否是月卡
     */
    private boolean checkIsMonthlyPayed(String plateNumber, Long parkId, String nowTime) {
        PayInsideCar payInsideCar = payInsideCarService.findFreeCustom(parkId, plateNumber);
        if (payInsideCar == null) {
            return Boolean.FALSE;
        }
        if (NEED_CHECK_MOTHLY_TYPE.contains(payInsideCar.getMonthlyType())) {
            if (payInsideContractService.selectValidMonthly(payInsideCar.getId()) > 0) {
                return Boolean.TRUE;
            }
        }
        if (ParkMonthlyRuleService.MONTHLY_TYPE_LEASE_HOUR.equals(payInsideCar.getMonthlyType())) {
            //储户时段租用户余额有钱
            return payInsideCar.getBalance() > 0d;
        }
        return Boolean.FALSE;
    }

}
