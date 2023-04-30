package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayInsideCar;
import com.xhb.pay.vo.MonthlyVehicleVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 内部车管理(PayInsideCar)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-22 10:12:37
 */
@Repository
@MapperDefinition(domainClass = PayInsideCar.class, orderBy = " update_time DESC")
public interface PayInsideCarDao extends BaseDao<PayInsideCar> {

    /**
     * 查询账户余额
     *
     * @param parkIdList  停车场id
     * @param plateNumber 车牌号码
     * @return 账户余额
     */
    PayInsideCar selectBalance(@Param("parkIdList") List<Long> parkIdList, @Param("plateNumber") String plateNumber);

    /**
     * 按照年月份，停车场查询 新增内部客户
     *
     * @param parkId
     * @param dateTime
     * @return
     */
    Integer findInsideCarCount(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);

}
