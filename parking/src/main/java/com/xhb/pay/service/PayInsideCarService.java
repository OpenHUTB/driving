package com.xhb.pay.service;


import com.baomidou.mybatisplus.core.metadata.IPage;
import com.fhs.core.base.service.BaseService;
import com.xhb.pay.bean.PayInsideCar;
import com.xhb.pay.vo.MonthlyVehicleVo;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * 内部客户管理(PayInsideCar)表服务接口
 *
 * @author makejava
 * @since 2019-05-22 10:12:37
 */
public interface PayInsideCarService extends BaseService<PayInsideCar> {

    /**
     * 默认账户余额
     */
    Double DEFAULT_BALANCE = 0d;

    /**
     * 默认结束日期
     */
    String DEFAULT_END_DATA = "2099-12-31";

    /**
     * 默认所属类型
     */
    Integer DEFAULT_FROM_TYPE = 1;

    /**
     * 默认按月充
     */
    String DEFAULT_IS_BY_MONTH = "0";

    /**
     * 免费用户
     */
    String MONTHLY_TYPE_FREE = "3";

    /**
     * 储库时段
     */
    String MONTHLY_TYPE_DEPOSITOR = "4";

    /**
     * 收费员收取现金
     */
    int FROM_TYPE_CASH = 5;

    /**
     * 批量导入
     *
     * @param paramMap 当前登录用户Id（sysUserId）,停车场id（parkId）集团编码（groupCode）
     * @param file     文件
     * @return
     */
    boolean batchImport(Map<String, String> paramMap, MultipartFile file);

    /**
     * 根据车牌号和车场id查询内部客户
     *
     * @param plateNumber
     * @param parkId
     * @return
     */

    PayInsideCar findFreeCustom(Long parkId, String plateNumber);

}
