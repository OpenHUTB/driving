package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayCarcomeHistory;
import com.xhb.pay.bean.PayTempOrderFeeBalance;
import com.xhb.pay.dto.PayCarcomeExportDTO;
import com.xhb.pay.form.PayCarcomeForm;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 车辆入场历史记录表
 */
@Repository
@MapperDefinition(domainClass = PayCarcomeHistory.class, orderBy = " update_time DESC")
public interface PayCarcomeHistoryDao extends BaseDao<PayCarcomeHistory> {

    /**
     * 查询临时订单列表
     */
    List<PayCarcomeExportDTO> queryPayCarcomePage(PayCarcomeForm payCarcomeForm);

    /**
     * 查询车辆进出详情
     */
    PayCarcomeExportDTO queryPayCarcome(Long id);

    /**
     * 统计一个车场内是否有数据
     */
    Long conuntCarcome(Map<String, Object> paramMap);

    /**
     * 车辆出入场数据查询 给前台返回
     *
     * @param paramMap 停车场，出入口，起止时间，车牌号
     * @return
     */
    List<PayCarcomeExportDTO> findListData(Map<String, Object> paramMap);

    /**
     * 删除车辆进出场数据
     */
    void delData2PayCarcomeHistory(Long id);

    /**
     * 修改车辆进出数据
     */
    void updateData2PayCarcomeHistory(PayCarcomeForm payCarcomeForm);

    /**
     * 新增车辆进出数据
     */
    void addData2PayCarcomeHistory(PayCarcomeForm payCarcomeForm);

}
