package com.xhb.pay.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.pay.bean.PaySpecialPass;
import com.xhb.pay.dao.PaySpecialPassDao;
import com.xhb.pay.dto.PaySpecialPassDTO;
import com.xhb.pay.service.PaySpecialPassService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 特殊放行纪录(PaySpecialPass)表服务实现类
 *
 * @author makejava
 * @since 2019-05-13 15:15:35
 */
@Service("paySpecialPassService")
@DataSource("park")
public class PaySpecialPassServiceImpl extends BaseServiceImpl<PaySpecialPass> implements PaySpecialPassService {

    @Autowired
    private PaySpecialPassDao paySpecialPassDao;

    /**
     * 分页查询特殊放行记录
     *
     * @param param
     * @return
     */

    @Override
    public List<PaySpecialPassDTO> findPage(Map param) {
        return paySpecialPassDao.findPage(param);
    }

    @Override
    public int getCount(Map param) {
        return paySpecialPassDao.getCount(param);
    }


}
