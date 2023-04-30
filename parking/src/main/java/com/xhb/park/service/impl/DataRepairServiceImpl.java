package com.xhb.park.service.impl;

import com.fhs.common.utils.Logger;
import com.fhs.core.db.DataSource;
import com.xhb.park.dao.DataRepairDao;
import com.xhb.park.service.DataRepairService;
import com.xhb.park.service.ParkParkingService;
import com.xhb.park.vo.DataRepairVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@DataSource("park")
public class DataRepairServiceImpl implements DataRepairService {

    private static final Logger LOG = Logger.getLogger(DataRepairServiceImpl.class);


    @Autowired
    private ParkParkingService parkParkingService;


    @Autowired
    private DataRepairDao dataRepairDao;

    private String parkTableName = "t_park_parking";

    @Override
    public void repairAllData(Long parkId) {
        repairOneParkAllData(parkId);
        //大停车场的parkid。
        List<Long> childrenParking = parkParkingService.getAllParkIdsForBigParkReturnList(parkId);
        childrenParking.forEach(childrenParkId -> {
            repairOneParkAllData(childrenParkId);
        });

    }

    private void repairOneParkAllData(Long parkId) {
        List<Map<String, String>> tblSett = getTblSett();
        for (Map<String, String> map : tblSett) {
            String tableName = map.get("tableName");
            if (parkTableName.equals(tableName)) {
                dataRepairDao.updateDataByTableName(tableName, parkId);
            } else {
                dataRepairDao.updateOneData(tableName, parkId);
            }
        }
    }

    private void repairOneParkData(List<DataRepairVO> dataRepairVOList,Long parkId) {
        for (DataRepairVO dataRepairVO : dataRepairVOList) {
            if (parkTableName.equals(dataRepairVO.getTableName())){
                dataRepairDao.updateDataByParkTableNameAndTime(dataRepairVO.getTableName(),parkId,dataRepairVO.getStaData(),dataRepairVO.getEndData());
            }else {
                dataRepairDao.updateDataByTableNameAndTime(dataRepairVO.getTableName(),parkId,dataRepairVO.getStaData(),dataRepairVO.getEndData());
            }
        }



    }

    @Override
    public void repairData(List<DataRepairVO> dataRepairVOList,Long parkId) {
        repairOneParkData(dataRepairVOList,parkId);
    }
}
