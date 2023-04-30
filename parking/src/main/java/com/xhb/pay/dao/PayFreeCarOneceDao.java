package com.xhb.pay.dao;

import com.xhb.pay.bean.PayFreeCarOnece;
import org.apache.ibatis.annotations.Param;

import java.util.List;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 一次性免费车(PayFreeCarOnece)表数据库访问层
 *
 * @author makejava
 * @since 2019-04-12 14:24:57
 */
@MapperDefinition(domainClass = PayFreeCarOnece.class, orderBy = " update_time DESC")
public interface PayFreeCarOneceDao extends BaseDao<PayFreeCarOnece> {

}
