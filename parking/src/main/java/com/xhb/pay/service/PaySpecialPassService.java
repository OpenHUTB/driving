package com.xhb.pay.service;

import com.xhb.pay.bean.PaySpecialPass;

import java.util.List;
import java.util.Map;

import com.fhs.core.base.service.BaseService;
import com.xhb.pay.dto.PaySpecialPassDTO;

/**
 * 特殊放行纪录(PaySpecialPass)表服务接口
 *
 * @author makejava
 * @since 2019-05-13 15:15:35
 */
public interface PaySpecialPassService extends BaseService<PaySpecialPass> {

    /**
     * 分页查询特殊放行记录
     *
     * @param param
     * @return
     */

    List<PaySpecialPassDTO> findPage(Map param);

    /**
     * 获取总条数
     *
     * @param param
     * @return
     */

    int getCount(Map param);

}
