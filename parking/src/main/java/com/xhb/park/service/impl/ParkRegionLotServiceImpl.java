package com.xhb.park.service.impl;

import com.fhs.common.utils.*;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.fhs.core.exception.ParamException;
import com.xhb.park.bean.ParkRegionLot;
import com.xhb.park.dao.ParkRegionLotDao;
import com.xhb.park.service.ParkParkingService;
import com.xhb.park.service.ParkRegionLotService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;


/**
 * (ParkRegionLot)表服务实现类
 *
 * @author makejava
 * @since 2019-05-24 10:37:43
 */
@Service("parkRegionLotService")
@DataSource("park")
public class ParkRegionLotServiceImpl extends BaseServiceImpl<ParkRegionLot> implements ParkRegionLotService {
    @Autowired
    private ParkRegionLotDao parkRegionLotDao;

    @Autowired
    private ParkParkingService parkParkingService;

    @Override
    public boolean batchImport(Map<String, String> paramMap, MultipartFile file) {
        try {
            List<ParkRegionLot> parkRegionLotList = ExcelUtils.formartExcelData(ParkRegionLot.class, file.getInputStream(),
                    "[{'index':'b','valid':['required'],'field':'lotNo'}]"
                    , 0, 2);
            //排除相同停车位号的
            Set<String> hasLotNos = new HashSet<>(ListUtils.appendField(parkRegionLotList, "lotNo"));
            List<ParkRegionLot> need2InsertList = new ArrayList<>();
            Iterator it = hasLotNos.iterator();
            while (it.hasNext()) {
                ParkRegionLot parkRegionLot = new ParkRegionLot();
                parkRegionLot.setLotNo((String) it.next());
                parkRegionLot.setId(idHelper.nextId());
                parkRegionLot.setCreateUser(paramMap.get("sysUserId"));
                parkRegionLot.setCreateTime(DateUtils.getCurrentDateStr(DateUtils.DATETIME_PATTERN));
                parkRegionLot.setUpdateUser(paramMap.get("sysUserId"));
                parkRegionLot.setUpdateTime(DateUtils.getCurrentDateStr(DateUtils.DATETIME_PATTERN));
                parkRegionLot.setParkId(ConverterUtils.toLong(paramMap.get("parkId")));
                parkRegionLot.setRegionId(ConverterUtils.toLong(paramMap.get("regionId")));
                parkRegionLot.setIsSync(0);
                parkRegionLot.setGroupCode(paramMap.get("groupCode"));
                parkRegionLot.setStatus(0);
                //根据车车位号，车场ID，区域ID确认是否为同一车位
                if ((super.findForList(ParkRegionLot.builder().lotNo(parkRegionLot.getLotNo()).parkId(parkRegionLot.getParkId()).regionId(parkRegionLot.getRegionId()).build()).isEmpty())) {
                    need2InsertList.add(parkRegionLot);
                }
            }
            if (!need2InsertList.isEmpty()) {
                //调用业务层
                this.batchInsert(need2InsertList);
            }
            return true;
        } catch (IllegalArgumentException e) {
            log.error(this, e);
            throw new ParamException(e.getMessage());
        } catch (Exception e) {
            log.error(this, e);
            throw new ParamException("请检查模板是否正确");
        }
    }

    @Override
    public String getLotAndRegionInfo(Long id) {
        return parkRegionLotDao.getLotAndRegionInfo(id);
    }

    @Override
    public int noBoundParkingSpace(String sn) {
        return parkRegionLotDao.noBoundParkingSpace(sn);
    }

}
