package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.StringUtil;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.service.ParkParkingService;
import com.xhb.report.dto.MonthlyParkDTO;
import com.xhb.report.dto.OtherBusinessDTO;
import com.xhb.report.dto.TempParkDTO;
import com.xhb.report.service.IncomeOverviewService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * <per>
 * 收入全览
 *
 * @author wangjie
 * @Date 2019/6/13 11:27
 * </per>
 */
@RestController
@RequestMapping("/ms/incomeOverview")
public class IncomeOverviewAction extends ModelSuperAction<TempParkDTO> {

    @Autowired
    private IncomeOverviewService incomeOverviewService;

    @Autowired
    private ParkParkingService parkingService;

    /**
     * 临停收入
     *
     * @param request
     * @return
     */
    @RequiresPermissions("income_overview:see")
    @RequestMapping("findTempParkData")
    public Object findTempParkData(HttpServletRequest request) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        Long parkId = ConverterUtils.toLong(paramMap.get("parkId"));
        Set<Long> parkIdSet = new HashSet<>();
        if (parkId == null) {
            parkIdSet.add(parkId);
            if (ParkParkingService.ROOT.equals(parkingService.selectById(parkId).getParentParkId())) {
                parkIdSet.addAll(parkingService.getAllParkIdsForBigParkReturnList(parkId));
            }
            paramMap.put("parkId", StringUtil.getStrToIn(parkIdSet.stream().map(ConverterUtils::toString).collect(Collectors.toList())));
        }
        List<TempParkDTO> tempParkDTOList = incomeOverviewService.findTempParkDataList(paramMap);
        TempParkDTO tempParkDTO = new TempParkDTO("合计", 0d, 0d, 0d, 0d, 0);
        if (tempParkDTOList.size() > 0) {
            for (TempParkDTO parkDTO : tempParkDTOList) {
                tempParkDTO.setAmountTotal(tempParkDTO.getAmountTotal() + parkDTO.getAmountTotal());
                tempParkDTO.setPavilionAmount(tempParkDTO.getPavilionAmount() + parkDTO.getPavilionAmount());
                tempParkDTO.setLiftingRodAmount(tempParkDTO.getLiftingRodAmount() + parkDTO.getLiftingRodAmount());
                tempParkDTO.setElectronicPayment(tempParkDTO.getElectronicPayment() + parkDTO.getElectronicPayment());
                tempParkDTO.setOutCarNumber(tempParkDTO.getOutCarNumber() + parkDTO.getOutCarNumber());
            }
        }
        tempParkDTOList.add(0, tempParkDTO);
        return tempParkDTOList;
    }

    /**
     * 月租户收入
     *
     * @param request
     * @return
     */
    @RequiresPermissions("income_overview:see")
    @RequestMapping("findMonthlyParkData")
    public Object findMonthlyParkData(HttpServletRequest request) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        List<MonthlyParkDTO> monthlyParkDTOList = incomeOverviewService.findMonthlyParkDataList(paramMap);
        MonthlyParkDTO monthlyParkDTO = new MonthlyParkDTO("合计", 0d, 0, 0d, 0, 0d, 0, 0d, 0);
        if (monthlyParkDTOList.size() > 0) {
            for (MonthlyParkDTO parkDTO : monthlyParkDTOList) {
                monthlyParkDTO.setIncomeAmount(monthlyParkDTO.getIncomeAmount() + parkDTO.getIncomeAmount());
                monthlyParkDTO.setIncomePark(monthlyParkDTO.getIncomePark() + parkDTO.getIncomePark());
                monthlyParkDTO.setRefundAmount(monthlyParkDTO.getRefundAmount() + parkDTO.getRefundAmount());
                monthlyParkDTO.setRefundPark(monthlyParkDTO.getRefundPark() + parkDTO.getRefundPark());
                monthlyParkDTO.setElectronicPay(monthlyParkDTO.getElectronicPay() + parkDTO.getElectronicPay());
                monthlyParkDTO.setElectronicPark(monthlyParkDTO.getElectronicPark() + parkDTO.getElectronicPark());
                monthlyParkDTO.setAmountTotal(monthlyParkDTO.getAmountTotal() + parkDTO.getAmountTotal());
            }
            monthlyParkDTO.setParkTotal(monthlyParkDTOList.get(0).getParkTotal());
        }
        monthlyParkDTOList.add(0, monthlyParkDTO);
        return monthlyParkDTOList;
    }

    /**
     * 其它业务收入
     *
     * @param request
     * @return
     */
    @RequiresPermissions("income_overview:see")
    @RequestMapping("findOtherBusinessData")
    public Object findOtherBusinessData(HttpServletRequest request) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        List<OtherBusinessDTO> list = incomeOverviewService.findOtherBusinessDataList(paramMap);
        OtherBusinessDTO otherBusinessDTO = new OtherBusinessDTO("合计", 0d, 0, 0, 0d, 0, 0d, 0, 0d, 0d, 0);
        if (list.size() > 0) {
            for (OtherBusinessDTO businessDTO : list) {
                otherBusinessDTO.setBusinessRechargeAmount(otherBusinessDTO.getBusinessRechargeAmount() + businessDTO.getBusinessRechargeAmount());
                otherBusinessDTO.setBusinessRechargeCount(otherBusinessDTO.getBusinessRechargeCount() + businessDTO.getBusinessRechargeCount());
                otherBusinessDTO.setCouponUsedCount(otherBusinessDTO.getCouponUsedCount() + businessDTO.getCouponUsedCount());
                otherBusinessDTO.setRechargeAmount(otherBusinessDTO.getRechargeAmount() + businessDTO.getRechargeAmount());
                otherBusinessDTO.setRechargeCarCharging(otherBusinessDTO.getRechargeCarCharging() + businessDTO.getRechargeCarCharging());
                otherBusinessDTO.setRechargeNumber(otherBusinessDTO.getRechargeNumber() + businessDTO.getRechargeNumber());
                otherBusinessDTO.setRefundAmount(otherBusinessDTO.getRefundAmount() + businessDTO.getRefundAmount());
                otherBusinessDTO.setRefundNumber(otherBusinessDTO.getRefundNumber() + businessDTO.getRefundNumber());
            }
            otherBusinessDTO.setRechargeCarSurplus(list.get(0).getRechargeCarSurplus());
            otherBusinessDTO.setRechargeSurplusNumber(list.get(0).getRechargeSurplusNumber());
        }
        list.add(0, otherBusinessDTO);
        return list;
    }

}
