package com.xhb.park.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.park.bean.ParkSpace;
import com.xhb.park.dao.ParkSpaceDao;
import com.xhb.park.service.ParkSpaceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * (ParkSpace)表服务实现类
 *
 * @author makejava
 * @since 2019-04-19 16:01:16
 */
@Service("parkSpaceService")
@DataSource("park")
public class ParkSpaceServiceImpl extends BaseServiceImpl<ParkSpace> implements ParkSpaceService {

    @Autowired
    private ParkSpaceDao parkSpaceDao;

    @Override
    public List<ParkSpace> findParkingSpaceNum(Map<String, Object> paramMap) {
        return parkSpaceDao.findParkingSpaceNum(paramMap);
    }


}
