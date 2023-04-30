package com.xhb.park.service.impl;

import com.fhs.core.db.DataSource;
import com.xhb.park.bean.ParkParkingPort;
import com.xhb.park.dao.ParkParkingPortDao;
import com.xhb.park.service.ParkParkingPortService;
import com.xhb.park.service.ParkParkingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fhs.core.base.service.impl.BaseServiceImpl;

/**
 * 进出口管理(ParkParkingPort)表服务实现类
 *
 * @author jackwong
 * @since 2019-03-13 20:22:11
 */
@Service("parkParkingPortService")
@DataSource("park")
public class ParkParkingPortServiceImpl extends BaseServiceImpl<ParkParkingPort> implements ParkParkingPortService {

    @Autowired
    private ParkParkingPortDao portDao;

    @Autowired
    private ParkParkingService parkParkingService;

}
