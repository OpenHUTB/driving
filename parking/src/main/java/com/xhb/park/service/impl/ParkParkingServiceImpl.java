package com.xhb.park.service.impl;

import com.fhs.common.utils.*;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.fhs.core.strategy.GenInfo;
import com.fhs.redis.service.RedisCacheService;
import com.rabbitmq.client.Channel;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.dao.ParkParkingDao;
import com.xhb.park.service.ParkParkingService;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 停车场表(ParkParking)表服务实现类
 *
 * @author jackwong
 * @since 2019-03-13 15:10:45
 */
@Service("parkParkingService")
@DataSource("park")
public class ParkParkingServiceImpl extends BaseServiceImpl<ParkParking> implements ParkParkingService {

    @Autowired
    private ParkParkingDao parkParkingDao;

    @Autowired
    private ConnectionFactory connectionFactory;

    @Autowired
    private RedisCacheService redisCacheService;


    private Long getParentParkId(Long parkId) {
        ParkParking park = super.selectById(parkId);
        if (ParkParkingService.ROOT.equals(park.getParentParkId())) {
            return park.getParkId();
        }
        return park.getParentParkId();
    }

    @Override
    public ParkParking getParentPark(Long parkId) {
        ParkParking park = super.selectById(parkId);
        if (park == null) {
            super.log.error("停车场不存在:" + parkId);
            return null;
        }
        if (ParkParkingService.ROOT.equals(park.getParentParkId())) {
            return park;
        }
        return super.selectById(park.getParentParkId());
    }


    @Override
    public List<Long> getAllParkIdsForBigParkReturnList(Long parkId) {
        Long parentParkId = this.getParentParkId(parkId);
        List<ParkParking> parkParkings = super.findForList(ParkParking.builder().parentParkId(parentParkId).build());
        if (parkParkings.isEmpty()) {
            return Arrays.asList(parkId);
        }
        return ListUtils.appendField(parkParkings, "parkId").stream().map(ConverterUtils::toLong).collect(Collectors.toList());
    }



    @GenInfo
    @Override
    public int insert(ParkParking park) {
        if (park.getParkId() == null) {
            park.setParkId(idHelper.nextId());
        }
        int insert = parkParkingDao.insert(park);
        Channel channel = connectionFactory.createConnection().createChannel(false);
        try {
            //数据下发队列
            channel.queueDeclare(park.getParkId() + "_data_lower_hair_queque", true, false, false, null);
            //订单支付队列
            channel.queueDeclare(park.getParkId() + "_order_pay_event_queque", true, false, false, null);
            channel.queueDeclare(park.getParkId() + "_lift_rod_envent_queque", true, false, false, null);
            //数据删除事件队列
            channel.queueDeclare(park.getParkId() + "_data_del_event_queque", true, false, false, null);
            channel.queueBind(park.getParkId() + "_data_lower_hair_queque", "data_lower_hair_exchange",
                    park.getParkId() + "");
            channel.queueBind(park.getParkId() + "_order_pay_event_queque", "order_pay_success_exchange",
                    park.getParkId() + "");
            channel.queueBind(park.getParkId() + "_lift_rod_envent_queque", "lift_rod_exchange",
                    park.getParkId() + "");
            channel.queueBind(park.getParkId() + "_data_del_event_queque", "data_del_exchange",
                    park.getParkId() + "");
            Map<String, String> message = new HashMap<>();
            message.put("transType", "pagex");
            message.put("namespace", "parking");
            redisCacheService.convertAndSend("trans", JsonUtils.map2json(message));
        } catch (IOException e) {
            super.log.error("创建queue错误，停车场id:" + park.getParkId(), e);
        }
        return insert;
    }

}
