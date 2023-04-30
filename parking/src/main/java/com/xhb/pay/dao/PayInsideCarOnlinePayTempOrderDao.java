package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.fhs.core.db.DataSource;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayInsideCarOnlinePayTempOrder;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 内部客户网络支付订单(PayInsideCarOnlinePayTempOrder)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-25 15:38:01
 */
@Repository
@MapperDefinition(domainClass = PayInsideCarOnlinePayTempOrder.class, orderBy = " update_time DESC")
public interface PayInsideCarOnlinePayTempOrderDao extends BaseDao<PayInsideCarOnlinePayTempOrder> {

    /**
     * 根据insideId查询最后一条充值记录的车位信息
     *
     * @param insideId
     * @return
     */
    String selectLastRechargeRecord(Long insideId);

}
