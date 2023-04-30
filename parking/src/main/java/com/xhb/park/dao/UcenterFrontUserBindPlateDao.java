package com.xhb.park.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.park.bean.UcenterFrontUserBindPlate;
import org.apache.ibatis.annotations.Param;

/**
 * 前段用户绑定车牌号(UcenterFrontUserBindPlate)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-24 15:40:51
 */
@MapperDefinition(domainClass = UcenterFrontUserBindPlate.class, orderBy = " update_time DESC")
public interface UcenterFrontUserBindPlateDao extends BaseDao<UcenterFrontUserBindPlate> {


}