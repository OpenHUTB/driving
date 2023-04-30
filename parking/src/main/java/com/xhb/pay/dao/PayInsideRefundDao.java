package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayInsideRefund;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 内部客户账户退款(PayInsideRefund)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-31 17:06:10
 */
@Repository
@MapperDefinition(domainClass = PayInsideRefund.class, orderBy = " update_time DESC")
public interface PayInsideRefundDao extends BaseDao<PayInsideRefund> {

    /**
     * 内部客户退款记录
     *
     * @param paramMap 过滤条件：客户姓名，客户手机号，客户车牌号 ，起止日期， 停车场。
     * @return
     */
    List<PayInsideRefund> findPayInsideRefundListByCondition(Map<String, Object> paramMap);

    /**
     * 内部客户退款记录总数
     *
     * @return
     */
    int findCount(Map<String, Object> paramMap);

    /**
     * 查询 退款、赠送、手续的金额 合计
     *
     * @param paramMap
     * @return
     */
    PayInsideRefund findSum(Map<String, Object> paramMap);

}
