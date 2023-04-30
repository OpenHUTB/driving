package com.xhb.park.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.park.bean.ParkLeaseType;
import com.xhb.park.service.ParkLeaseTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.xhb.park.dao.ParkLeaseTypeDao;

/**
 * 租户类型(ParkLeaseType)表服务实现类
 *
 * @author jackwong
 * @since 2019-03-13 20:16:37
 */
@Service("parkLeaseTypeService")
@DataSource("park")
public class ParkLeaseTypeServiceImpl extends BaseServiceImpl<ParkLeaseType> implements ParkLeaseTypeService {

    @Autowired
    private ParkLeaseTypeDao parkLeaseTypeDao;

}
