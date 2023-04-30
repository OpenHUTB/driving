package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayInsideRecharge;
import com.xhb.pay.dto.PayInsideRechargeExportDTO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 充值记录表(PayInsideRecharge)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-22 17:59:38
 */
@Repository
@MapperDefinition(domainClass = PayInsideRecharge.class, orderBy = " update_time DESC")
public interface PayInsideRechargeDao extends BaseDao<PayInsideRecharge> {

    PayInsideRecharge findLastRecord(PayInsideRecharge payInsideRecharge);

    /**
     * 查询内部客户充值记录
     *
     * @param paramMap 过滤条件：客户姓名，客户手机号，客户车牌号 ，起止日期， 停车场
     * @return
     */
    List<PayInsideRechargeExportDTO> findDateList(Map<String, Object> paramMap);

    /**
     * 查询内部客户充值记录总数
     *
     * @return
     */
    int findCount(Map<String, Object> paramMap);

    /**
     * 查询内部客户 充值金额和赠送金额 合计
     *
     * @param paramMap
     * @return
     */
    PayInsideRecharge findSum(Map<String, Object> paramMap);

    /**
     * 查询出充值过的内部客户id
     *
     * @param ids
     * @return
     */
    List<Long> isRecharge(@Param("ids") String ids);


    /**
     * 按照年月份，停车场查询 内部客户充值总合
     *
     * @param parkId
     * @param dateTime yyyy-MM
     * @return
     */
    Double getMonthRecharge(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);
}
