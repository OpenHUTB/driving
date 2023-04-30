package com.xhb.pay.service.impl;

import com.xhb.pay.bean.PayCarcomeExt;
import com.xhb.pay.dao.PayCarcomeExtDao;
import com.xhb.pay.service.PayCarcomeExtService;
import org.springframework.stereotype.Service;
import com.fhs.core.base.service.impl.BaseServiceImpl;

import javax.annotation.Resource;
import java.util.List;

/**
 * 车辆入场记录扩展字段表(PayCarcomeExt)表服务实现类
 *
 * @author wanglei
 * @since 2022-04-19 16:09:39
 */
@Service("payCarcomeExtService")
public class PayCarcomeExtServiceImpl extends BaseServiceImpl<PayCarcomeExt> implements PayCarcomeExtService {
    @Override
    public int insertJpa(PayCarcomeExt entity) {
        if (super.selectById(entity.getId()) == null) {
            return super.insertJpa(entity);
        }
        return 0;
    }
}
