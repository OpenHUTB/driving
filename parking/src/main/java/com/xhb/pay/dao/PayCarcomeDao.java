package com.xhb.pay.dao;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayCarcome;
import com.xhb.pay.bean.PaySpecialPass;
import com.xhb.pay.bean.PayTempOrder;
import com.xhb.pay.dto.CarcomeCountDTO;
import com.xhb.pay.dto.FlowAnalyseDTO;
import com.xhb.pay.dto.PayCarcomeExportDTO;
import com.xhb.pay.form.PayCarcomeForm;
import com.xhb.pay.vo.VehicleEntryVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 车辆入场记录表(PayCarcome)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-13 14:56:26
 */
@Repository
@MapperDefinition(domainClass = PayCarcome.class, orderBy = " update_time DESC")
public interface PayCarcomeDao extends BaseDao<PayCarcome> {

    /**
     * 根据条件查询最后一条记录
     *
     * @return 最后一条记录
     */
    PayCarcome findLastRecfindLastRecord(PayCarcome payCarcome);

    /**
     * 查询总的入/出 场数
     *
     * @return
     */
    Integer findByTypeCount(@Param("type") int type, @Param("parkIds") String parkIds);

    /**
     * 查询今日总的入/出 场数
     *
     * @param type
     * @return
     */
    Integer findByTypeAndTimeCount(@Param("type") int type, @Param("parkIds") String parkIds);


    /**
     * 根据传入时间 查询当天总的入/出 场数
     *
     * @param paramMap 停车场、起止时间、集团编码
     * @return
     */
    List<Map<String, Object>> findByTypeAndDay(Map<String, Object> paramMap);

    /**
     * 根据根据开始和结束时间 查询起止的入/出 场数
     *
     * @param paramMap 停车场、起止日期、集团编码
     * @return
     */
    List<Map<String, Object>> findByTypeAndDate(Map<String, Object> paramMap);

    /**
     * 返回出入场总数
     *
     * @param paramMap 停车场、起止日期、集团编码
     * @return
     */
    Map<String, Object> findOutEnterCount(Map<String, Object> paramMap);

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
     * 场端出入场表格数据条数
     *
     * @param param
     * @return
     */

    int selectCarCount(Map param);

    /**
     * 获取这个月租户是否有多个没有出场的车辆
     *
     * @param parkId      停车场id
     * @param insideCarId 内部客户
     * @param plateNumber 车牌号
     * @return 有多少个未出场车辆
     */
    Integer selectInsideInParkPlateNum(@Param("parkId") Long parkId, @Param("insideCarId") Long insideCarId, @Param("plateNumber") String plateNumber);


    /**
     * 进出场 整月数量统计
     */
    List<CarcomeCountDTO> findCarcomeCount(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);

    /**
     * 进出场 按小时统计数量
     *
     * @param parkId
     * @param dateTime
     * @param type     0入 1出
     * @return
     */
    List<Map<String, Object>> findHourCarcomeCountByType(@Param("parkId") Long parkId, @Param("dateTime") String dateTime, @Param("type") Integer type);

    /**
     * 每日流量分析
     */
    List<FlowAnalyseDTO> findFlowAnalyse(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);

    /**
     * 工作日及其周末车流量分析
     */
    List<Map<String, Object>> findWorkAndWeekendFlowAnalyse(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);

    /**
     * 批量修改支付状态为已支付
     */
    int batchUpdateStatus(@Param("ids") String ids);

    /**
     * 根据车牌号去like 模糊撤出符合条件的入场记录
     *
     * @param toLikeList 需要like的车牌号集合
     * @param parkId     停车场id
     * @return 入场记录id
     */

    PayCarcome findCarComeByPlatNumberLike(@Param("toLikeList") List<String> toLikeList, @Param("parkId") Long parkId);

    /**
     * 修改车辆进出数据
     */
    void updateData2PayCarcome(PayCarcomeForm payCarcomeForm);

    /**
     * 新增车辆进出数据
     */
    void addData2PayCarcome(PayCarcomeForm payCarcomeForm);

    /**
     * 创造假数据100万条
     */
    void doInsert(List<PayCarcome> list);

}
