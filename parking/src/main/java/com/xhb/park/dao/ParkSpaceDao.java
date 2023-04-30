package com.xhb.park.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.park.bean.ParkSpace;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * (ParkSpace)表数据库访问层
 *
 * @author makejava
 * @since 2019-04-19 16:01:15
 */
@Repository
@MapperDefinition(domainClass = ParkSpace.class, orderBy = " update_time DESC")
public interface ParkSpaceDao extends BaseDao<ParkSpace> {

    /**
     * 查询 车位占用、空闲 和 停车场名称
     *
     * @param map 数据权限,集团编码
     * @return
     */
    List<ParkSpace> findParkingSpaceNum(Map<String, Object> map);


}
