package com.xhb.pay.dao;

import com.xhb.pay.bean.PayCarcomeExt;
import com.xhb.pay.bean.PayCarcomeHistory;
import com.xhb.pay.form.PayCarcomeForm;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 车辆入场记录扩展字段表(PayCarcomeExt)表数据库访问层
 *
 * @author wanglei
 * @since 2022-04-19 16:09:39
 */
@MapperDefinition(domainClass = PayCarcomeExt.class, orderBy = " update_time DESC")
public interface PayCarcomeExtDao extends BaseDao<PayCarcomeExt> {
    /**
     * 删除车辆进出场数据
     */
    void delData2PayCarcomeExt(Long id);

    /**
     * 修改车辆进出数据
     */
    void updateData2PayCarcomeExt(PayCarcomeForm payCarcomeForm);

    /**
     * 新增车辆进出数据
     */
    void addData2PayCarcomeExt(PayCarcomeForm payCarcomeForm);

}
