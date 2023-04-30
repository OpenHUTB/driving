package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayInsidePlateBind;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 内部车和车牌号绑定记录(PayInsidePlateBind)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-22 17:54:52
 */
@Repository
@MapperDefinition(domainClass = PayInsidePlateBind.class, orderBy = " update_time DESC")
public interface PayInsidePlateBindDao extends BaseDao<PayInsidePlateBind> {

}
