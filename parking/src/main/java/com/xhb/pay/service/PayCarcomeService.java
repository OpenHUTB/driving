package com.xhb.pay.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.pay.bean.PayCarcome;
import com.xhb.pay.dto.PayCarcomeExportDTO;
import com.xhb.report.bean.ReportTask;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.Map;

/**
 * 车辆入场记录表(PayCarcome)表服务接口
 *
 * @author jackwong
 * @since 2019-03-13 14:56:26
 */
public interface PayCarcomeService extends BaseService<PayCarcome> {
    /**
     * 进场纪录
     */
    int TYPE_COME = 0;

    /**
     * 出场纪录
     */
    int TYPE_OUT = 1;

    /**
     * 记录
     */
    int STATUS_INIT = 0;

    /**
     * 已经创建支付订单
     */
    int STATUS_CREATE_ORDER = 1;

    /**
     * 已经支付
     */
    int STATUS_CREATE_HAS_PAY = 2;

    /**
     * 没有入场记录，可能是车牌号识别错误
     */
    int NOT_INCOME_RECORE = 405;

    /**
     * 没有需要交费的出场记录
     */
    int NOT_PAY_OUT_RECORD = 406;

    /**
     * 云端某一出口最近的出场记录距离当前时间超过限制(最后一个车辆滞留时间过长或者场端断网或者场端车辆未识别到)
     */
    int INVALID_CAR_OUT_RECORD = 407;

    /**
     * 临时车
     */
    int RECORD_TYPE_TEMP = 0;

    /**
     * 月租车
     */
    int RECORD_TYPE_MONTHLY = 1;

    /**
     * 免费车
     */
    int RECORD_TYPE_FREE = 2;

    /**
     * 未知车辆
     */
    int CAR_TYPE_UNKNOWN = 0;

    /**
     * 普通蓝牌
     */
    int CAR_TYPE_LITTLE = 1;

    /**
     * 黑牌
     */
    int CAR_TYPE_BLACK = 2;

    /**
     * 营运车辆
     */
    int CAR_TYPE_OPERATING = 2;

    /**
     * 警察车辆
     */
    int CAR_TYPE_POLICE = 3;

    /**
     * 军队车辆
     */
    int CAR_TYPE_FORCES = 4;

    /**
     * 车辆出入场数据查询 给前台返回
     *
     * @param paramMap 停车场，出入口，起止时间，车牌号
     * @return
     */
    List<PayCarcomeExportDTO> findListData(Map<String, Object> paramMap);

    /**
     * 查询数量
     *
     * @param paramMap
     * @return
     */
    Long findCount(Map<String, Object> paramMap);


    /**
     * 生成excel文件 workbook
     *
     * @param paramMap
     * @return
     */
    Workbook exportCarcomeExcel(Map<String, Object> paramMap);

    /**
     * 创建 停车场 返回文件对象
     *
     * @param task
     * @return
     */
    File makeCarcome(ReportTask task);

    /**
     * 获取这个月租户是否有多个没有出场的车辆
     *
     * @param parkId      停车场id
     * @param insideCarId 内部客户
     * @param plateNumber 车牌号
     * @return 有多少个未出场车辆
     */
    int selectInsideInParkPlateNum(Long parkId, Long insideCarId, String plateNumber);

    /**
     * 入场记录批量导入
     *
     * @param paramMap
     * @param file
     * @return
     */

    Boolean batchImport(Map<String, Object> paramMap, MultipartFile file);

    /**
     * 批量修改支付状态
     *
     * @param ids
     */

    int batchUpdateStatus(String ids);


}
