package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.CollectorChangeShifts;
import com.xhb.pay.bean.PayCarcomeExt;
import com.xhb.pay.bean.PaySpecialPass;
import com.xhb.pay.dto.PaySpecialPassDTO;
import com.xhb.pay.vo.PaySpecialPassVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 特殊放行纪录(PaySpecialPass)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-13 15:15:35
 */
@Repository
@MapperDefinition(domainClass = PaySpecialPass.class, orderBy = " update_time DESC")
public interface PaySpecialPassDao extends BaseDao<PaySpecialPass> {

    List<PaySpecialPassDTO> findPage(Map param);

    int getCount(Map param);

    /**
     * 查询收银员 特殊放行总金额和数量
     *
     * @param collectorChangeShifts 收银员id,上班时间，下班时间
     * @return
     */
    Map<String, Object> findPaySpecialPassAmountByTime(CollectorChangeShifts collectorChangeShifts);

    /**
     * 查询 特殊放行下班记录 名称，总金额，数量
     *
     * @param collectorChangeShifts 收银员id,上班时间，下班时间
     * @return
     */
    List<PaySpecialPassVo> findPaySpecialPassByCollectorId(CollectorChangeShifts collectorChangeShifts);

}
