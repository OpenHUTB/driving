package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayInsideContract;
import com.xhb.pay.vo.PayInsideContractVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 内部车承包时间段表(PayInsideContract)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-22 17:53:07
 */
@Repository
@MapperDefinition(domainClass = PayInsideContract.class, orderBy = " update_time DESC")
public interface PayInsideContractDao extends BaseDao<PayInsideContract> {

    /**
     * 根据内部用户id查询最后一次充值记录
     *
     * @param payInsideContract
     * @return
     */

    PayInsideContract findLastRecord(PayInsideContract payInsideContract);

    /**
     * 查询用户是否在月租有效期内
     *
     * @param insideId
     * @return
     */

    int selectValidMonthly(Long insideId);

    /**
     * 按照年月份，停车场查询: 包月每天费用
     */
    Double findDailyParameterCost(@Param("parkId") Long parkId, @Param("dateTime") String dateTime, @Param("monthDays") Integer monthDays);


}
