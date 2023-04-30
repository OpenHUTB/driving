package com.xhb.park.dao;

import com.fhs.common.utils.EMap;
import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.park.bean.ParkRegionLot;
import io.swagger.models.auth.In;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * (ParkRegionLot)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-24 10:37:43
 */
@Repository
@MapperDefinition(domainClass = ParkRegionLot.class, orderBy = " update_time DESC")
public interface ParkRegionLotDao extends BaseDao<ParkRegionLot> {
    /**
     * 查询区域名称_车位号
     *
     * @param id
     * @return
     */
    String getLotAndRegionInfo(Long id);

    /**
     * 解绑地磁
     * @param sn
     * @return
     */
    int noBoundParkingSpace(@Param("sn") String sn);
}
