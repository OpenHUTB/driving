package com.xhb.pay.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.pay.bean.PayInsideRecharge;
import com.xhb.pay.dto.PayInsideRechargeExportDTO;
import com.xhb.report.bean.ReportTask;
import org.apache.poi.ss.usermodel.Workbook;

import java.io.File;
import java.util.List;
import java.util.Map;

/**
 * 充值记录表(PayInsideRecharge)表服务接口
 *
 * @author makejava
 * @since 2019-05-22 17:59:39
 */
public interface PayInsideRechargeService extends BaseService<PayInsideRecharge> {

    /**
     * 后台系统
     */
    int BACK_OFFICE_SYSTEM = 1;

    /**
     * 公众号/支付宝
     */
    int MP_AND_ALIPAY = 2;

    /**
     * App
     */
    int APP = 3;

    /**
     * 小程序
     */
    int MINI_PROGRAMS = 4;

    /**
     * 不是月租户充值
     */
    int MONTHLY_FALSE = 0;

    /**
     * 未充值
     */
    int STATE_NO_RECHARGE = 0;
    /**
     * 已充值
     */
    int STATE_RECHARGE = 1;
    /**
     * 已到期
     */
    int STATIE_EXPIRED = 2;


    /**
     * 余额充值
     *
     * @param entity
     * @param isSync 同步
     */
    void insertRecharge(PayInsideRecharge entity, int isSync);

    /**
     * 查询储户时段租用户最后一次充值记录
     *
     * @param build
     * @return
     */
    PayInsideRecharge findLastRecord(PayInsideRecharge build);

    /**
     * 查询内部客户充值记录
     *
     * @param paramMap 过滤条件：停车场，客户姓名，电话，车牌号，起止时间
     * @return
     */
    List<PayInsideRechargeExportDTO> findDateList(Map<String, Object> paramMap);


    /**
     * 查询内部客户充值记录总数
     *
     * @return
     */
    int findCount(Map<String, Object> paramMap);

    /**
     * 查询内部客户 充值金额和赠送金额 合计
     *
     * @param paramMap 过滤条件：停车场，客户姓名，电话，车牌号，起止时间
     * @return
     */
    PayInsideRecharge findSum(Map<String, Object> paramMap);

    /**
     * 创建月报表返回文件对象
     *
     * @param task
     * @return
     */
    File makeReport(ReportTask task);

    /**
     * 查询出充值过的内部客户id
     *
     * @param ids
     * @return
     */
    List<Long> isRecharge(String ids);

}
