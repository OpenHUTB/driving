package com.xhb.report.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.report.bean.ReportNoGetOutCar;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * (ReportNoGetOutCar)表数据库访问层
 *
 * @author makeJun
 * @since 2020-01-17 14:42:14
 */
@MapperDefinition(domainClass = ReportNoGetOutCar.class, orderBy = " update_time DESC")
@Repository
public interface ReportNoGetOutCarDao extends BaseDao<ReportNoGetOutCar> {

    List<ReportNoGetOutCar> findNoOutCar(Map<String, Object> paramMap);

    Integer findNoOutCarCount(Map<String, Object> paramMap);

    List<String> findNotPayCar(ReportNoGetOutCar noGetOutCar);
}