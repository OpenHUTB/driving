package com.xhb.park.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.park.bean.UcenterTollCollector;
import com.xhb.park.dao.UcenterTollCollectorDao;
import com.xhb.park.service.UcenterTollCollectorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 收费人员表(UcenterTollCollector)表服务实现类
 *
 * @author makejava
 * @since 2019-04-03 17:32:36
 */
@Service("ucenterTollCollectorService")
@DataSource("park")
public class UcenterTollCollectorServiceImpl extends BaseServiceImpl<UcenterTollCollector> implements UcenterTollCollectorService {

}
