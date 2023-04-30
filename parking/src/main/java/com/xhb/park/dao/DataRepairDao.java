package com.xhb.park.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;


@Repository
public interface DataRepairDao {

    /**
     * 根据表名和车场id更新状态
     * @param tableName
     * @param parkId
     */
    void updateOneData(@Param("tableName") String tableName, @Param("parkId")Long parkId);

    /**
     * 根据表名和车场id更新状态
     * @param tableName
     * @param parkId
     */
    void updateDataByTableName(@Param("tableName") String tableName, @Param("parkId")Long parkId);


    /**
     * park表 根据表名 和车场id 和时间 更新
     * @param tableName
     * @param parkId

     */
    void updateDataByParkTableNameAndTime(@Param("tableName") String tableName, @Param("parkId") Long parkId,@Param("startDate") String startDate,@Param("endDate") String endDate);


    /**
     * 根据表名,车场id起始,截止时间更新
     * @param tableName
     * @param parkId
     * @param startDate
     * @param endDate
     */
    void updateDataByTableNameAndTime(@Param("tableName") String tableName, @Param("parkId")Long parkId,@Param("startDate")String startDate, @Param("endDate")String endDate);
}
