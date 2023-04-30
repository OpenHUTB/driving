package com.xhb.pay.service.impl;


import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fhs.common.constant.Constant;
import com.fhs.common.excel.ExcelValidor;
import com.fhs.common.utils.*;
import com.fhs.context.UserContext;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.fhs.core.event.datadel.DataDelManager;
import com.fhs.core.exception.ParamException;
import com.xhb.park.bean.ParkLeaseType;
import com.xhb.park.bean.ParkMonthlyRule;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.service.ParkLeaseTypeService;
import com.xhb.park.service.ParkMonthlyRuleService;
import com.xhb.park.service.ParkParkingService;
import com.xhb.pay.bean.PayInsideCar;
import com.xhb.pay.bean.PayInsideContract;
import com.xhb.pay.bean.PayInsidePlateBind;
import com.xhb.pay.dao.PayInsideCarDao;
import com.xhb.pay.dao.PayInsideContractDao;
import com.xhb.pay.dao.PayInsidePlateBindDao;
import com.xhb.pay.dto.MonthInsideCarTemplateDTO;
import com.xhb.pay.service.PayInsideCarService;
import com.xhb.pay.service.PayInsideContractService;
import com.xhb.pay.service.PayInsidePlateBindService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 内部客户管理(PayInsideCar)表服务实现类
 * PayInsideCarServiceImpl<insert>  这个insert不要删除，删除了项目跑不起来，但是不知道原因。。有空在看
 *
 * @author wanglei
 * @since 2019-05-22 10:12:37
 */
@Service("payInsideCarService")
@DataSource("park")
public class PayInsideCarServiceImpl<insert> extends BaseServiceImpl<PayInsideCar> implements PayInsideCarService {

    private static final Logger LOG = Logger.getLogger(PayInsideCarServiceImpl.class);

    @Autowired
    private ParkLeaseTypeService parkLeaseTypeService; //租户类型Service
    @Autowired
    private ParkMonthlyRuleService parkMonthlyRuleService; //月租收费规则
    @Lazy
    @Autowired
    private PayInsidePlateBindService payInsidePlateBindService; //内部用户和车牌号绑定记录
    @Lazy
    @Autowired
    private PayInsideContractService payInsideContractService; //月租户付费记录
    @Autowired
    private PayInsideCarDao payInsideCarDao;
    @Autowired
    private ParkParkingService parkParkingService;
    @Autowired
    private PayInsideContractDao payInsideContractDao;
    @Autowired
    private PayInsidePlateBindDao payInsidePlateBindDao;

    @Autowired
    private DataDelManager dataDelManager;

    private static class ImportDataValidator implements ExcelValidor {

        private Map<String, Long> leaseTypeMap;

        private Map<String, Long> monthlyRuleMap;

        private Set<String> plateNumberSet;

        private ParkLeaseTypeService parkLeaseTypeService; //租户类型Service

        private ParkMonthlyRuleService parkMonthlyRuleService; //月租收费规则

        private PayInsidePlateBindService payInsidePlateBindService;

        private Long parkId;

        public ImportDataValidator(ParkMonthlyRuleService monthlyRuleService, ParkLeaseTypeService parkLeaseTypeService, Long parkId, PayInsidePlateBindService payInsidePlateBindService) {
            this.parkMonthlyRuleService = monthlyRuleService;
            this.parkLeaseTypeService = parkLeaseTypeService;
            this.parkId = parkId;
            this.payInsidePlateBindService = payInsidePlateBindService;
        }

        //(验证日期是yyyy-MM-dd支持闰年的正则表达式)
        // String rexp1 = "((\\d{2}(([02468][048])|([13579][26]))[\\-]((((0?[13578])|(1[02]))[\\-]((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-]((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-]((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-]((((0?[13578])|(1[02]))[\\-]((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-]((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-]((0?[1-9])|(1[0-9])|(2[0-8]))))))";
        public boolean validParam(Object param, String valid, StringBuilder errorBuilder, char colName, int rowIndex) {
            if (CheckUtils.isNullOrEmpty(param)) {
                errorBuilder.append("第" + rowIndex + "行，第" + colName + "列为必填;");
                return false;
            }
            boolean validedSuccess = false;
            switch (valid) {
                case "ex.rule":
                    validedSuccess = monthlyRuleMap.containsKey(param);
                    break;
                case "ex.leaseType":
                    validedSuccess = leaseTypeMap.containsKey(param);
                    break;
                case "ex.plateNums":
                    String regets = ",|，|\\s+";
                    String[] plateNums = ConverterUtils.toString(param).split(regets);
                    boolean isAllPass = true;
                    for (String palteNumber : plateNums) {
                        if (plateNumberSet.contains(palteNumber)) {
                            isAllPass = false;
                            continue;
                        }
                        plateNumberSet.add(ConverterUtils.toString(palteNumber));
                    }
                    validedSuccess = isAllPass;
                    break;
            }
            if (!validedSuccess) {
                errorBuilder.append("第" + rowIndex + "行，第" + colName + "列输入有误;");
                return false;
            }
            return true;
        }

        public void init(Map<String, String> paramMap) {
            Long parkId = ConverterUtils.toLong(paramMap.get("parkId"));
            List<ParkLeaseType> parkLeaseTypeList = parkLeaseTypeService.findForList(ParkLeaseType.builder().parkId(parkId).groupCode(paramMap.get("groupCode")).build());
            leaseTypeMap = parkLeaseTypeList.stream().collect(Collectors.toMap(ParkLeaseType::getLeaseName, ParkLeaseType::getId));
            List<ParkMonthlyRule> monthlyRuleList = parkMonthlyRuleService.findForList(ParkMonthlyRule.builder().parkId(parkId).groupCode(paramMap.get("groupCode")).build());
            monthlyRuleMap = monthlyRuleList.stream().collect(Collectors.toMap(ParkMonthlyRule::getRuleName, ParkMonthlyRule::getId));
            List<PayInsidePlateBind> insidePlateBindList = payInsidePlateBindService.findForList(PayInsidePlateBind.builder().parkId(parkId).groupCode(paramMap.get("groupCode")).build());
            plateNumberSet = insidePlateBindList.stream().map(PayInsidePlateBind::getPlateNumber).collect(Collectors.toSet());
        }
    }


    @Override
    public boolean batchImport(Map<String, String> paramMap, MultipartFile file) {
        try {
            ImportDataValidator validator = new ImportDataValidator(this.parkMonthlyRuleService, this.parkLeaseTypeService, ConverterUtils.toLong(paramMap.get("parkId")), this.payInsidePlateBindService);
            validator.init(paramMap);
            List<MonthInsideCarTemplateDTO> insideCarTemplateDTOS = ExcelUtils.formartExcelData(MonthInsideCarTemplateDTO.class, file.getInputStream(), "[" +
                    "{'index':'b','valid':['required'],'field':'ownerName'}," +
                    "{'index':'c','field':'ownerMobile'}," +
                    "{'index':'d','valid':['required','int'],'field':'lotNum'}," +
                    "{'index':'e','valid':'ex.leaseType','field':'leaseTypeId'}," +
                    "{'index':'f','valid':['required','double'],'field':'balance'}," +
                    "{'index':'g','valid':'ex.plateNums','field':'plateNums'}," +
                    "{'index':'h','valid':'ex.rule','field':'ruleId'}," +
                    "{'index':'i','field':'startDate'}," +
                    "{'index':'j','field':'endDate'}," +
                    "]", 0, 10, validator);

            List<PayInsideCar> actInsertList = new ArrayList<>();
            List<PayInsidePlateBind> bindInsertList = new ArrayList<>();
            List<PayInsideContract> contractInsertList = new ArrayList<>();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

            for (int i = 0; i < insideCarTemplateDTOS.size(); i++) {
                PayInsideCar payInsideCar = new PayInsideCar();
                String start = insideCarTemplateDTOS.get(i).getStartDate();
                String end = insideCarTemplateDTOS.get(i).getEndDate();
                String startDate = "";
                String endDate = "";
                if (!start.isEmpty() || !end.isEmpty()) {
                    startDate = df.format(df.parse(start));
                    endDate = df.format(df.parse(end));
                }
                //ID主键值.添加 1月卡，2车辆 还会绑定
                Long id = idHelper.nextId();
                payInsideCar.setId(id);
                payInsideCar.setInsideName(insideCarTemplateDTOS.get(i).getOwnerName() + insideCarTemplateDTOS.get(i).getOwnerMobile());
                payInsideCar.setOwnerName(insideCarTemplateDTOS.get(i).getOwnerName());
                payInsideCar.setOwnerMobile(insideCarTemplateDTOS.get(i).getOwnerMobile());
                payInsideCar.setLotNum(insideCarTemplateDTOS.get(i).getLotNum());
                payInsideCar.setBalance(insideCarTemplateDTOS.get(i).getBalance());
                payInsideCar.setPlateNums(insideCarTemplateDTOS.get(i).getPlateNums().replace("，", ","));
                payInsideCar.preInsert(paramMap.get("sysUserId"));
                payInsideCar.setParkId(ConverterUtils.toLong(paramMap.get("parkId")));
                payInsideCar.setGroupCode(paramMap.get("groupCode"));
                payInsideCar.setIsSync(Constant.INT_FALSE);
                payInsideCar.setFromType(DEFAULT_FROM_TYPE);
                if (!start.isEmpty() || !end.isEmpty()) {
                    payInsideCar.setStartDate(startDate);
                    payInsideCar.setEndDate(endDate);
                } else {
                    payInsideCar.setStartDate(DateUtils.getCurrentDateStr(DateUtils.DATETIME_PATTERN_DATE));
                    payInsideCar.setEndDate(DEFAULT_END_DATA);
                }
                //未给字段值 前段用户id（front_user_id），次数（time_number），房间号（room_num）

                //月租户类型 t_park_lease_type查询
                payInsideCar.setLeaseTypeId(validator.leaseTypeMap.get(insideCarTemplateDTOS.get(i).getLeaseTypeId()));
                //月租户收费规则 t_park_monthly_rule查询
                Long ruleId = validator.monthlyRuleMap.get(insideCarTemplateDTOS.get(i).getRuleId());
                payInsideCar.setRuleId(ruleId);
                //租赁类型
                payInsideCar.setMonthlyType(parkMonthlyRuleService.selectById(ruleId).getMonthlyType());

                /**
                 * //遍历车牌号， 插入t_pay_inside_plate_bind
                 */
                String plateNums = insideCarTemplateDTOS.get(i).getPlateNums();
                String regets = ",|，|\\s+";
                String[] arry = plateNums.split(regets);
                for (int j = 0; j < arry.length; j++) {
                    PayInsidePlateBind payInsidePlateBind = new PayInsidePlateBind();
                    payInsidePlateBind.setId(idHelper.nextId());
                    payInsidePlateBind.setPlateNumber(arry[j]);
                    payInsidePlateBind.setIsSync(Constant.INT_FALSE);
                    //内部用户ID
                    payInsidePlateBind.setInsideId(id);
                    payInsidePlateBind.setParkId(ConverterUtils.toLong(paramMap.get("parkId")));
                    payInsidePlateBind.setGroupCode(paramMap.get("groupCode"));
                    payInsidePlateBind.preInsert(paramMap.get("sysUserId"));

                    //添加 内部用户和车牌号绑定记录 List
                    bindInsertList.add(payInsidePlateBind);
                }

                /**
                 * 如果有月卡开始日期，插入t_pay_inside_contract
                 */
                if (!startDate.isEmpty() && !endDate.isEmpty()) {
                    PayInsideContract payInsideContract = new PayInsideContract();
                    payInsideContract.setId(idHelper.nextId());
                    payInsideContract.setInsideId(id);
                    payInsideContract.setParkId(ConverterUtils.toLong(paramMap.get("parkId")));
                    payInsideContract.setStartDate(startDate);
                    payInsideContract.setEndDate(endDate);
                    payInsideContract.setIsByMonth(DEFAULT_IS_BY_MONTH);
                    payInsideContract.setIsSync(Constant.INT_FALSE);
                    payInsideContract.preInsert(paramMap.get("sysUserId"));
                    payInsideContract.setGroupCode(paramMap.get("groupCode"));
                    payInsideContract.setFromType(DEFAULT_FROM_TYPE);
                    payInsideContract.setAmount(DEFAULT_BALANCE);
                    payInsideContract.setRemark("导入");

                    //添加 月租户付费记录 List
                    contractInsertList.add(payInsideContract);
                }
                //添加 内部客户 List
                actInsertList.add(payInsideCar);
            }

            if (!actInsertList.isEmpty()) {
                //调用业务层
                this.batchInsert(actInsertList);
            }
            if (!bindInsertList.isEmpty()) {
                payInsidePlateBindService.batchInsert(bindInsertList);
            }
            if (!contractInsertList.isEmpty()) {
                payInsideContractService.batchInsert(contractInsertList);
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

    /**
     * 根据车牌号和车场id查询内部客户
     *
     * @param plateNumber
     * @param parkId
     * @return
     */
    @Override
    public PayInsideCar findFreeCustom(Long parkId, String plateNumber) {
        if (parkId == null) {
            return payInsideCarDao.selectBalance(new ArrayList<>(), plateNumber);
        }
        ParkParking parentPark = parkParkingService.getParentPark(parkId);
        Set<Long> parkIdList = new HashSet<Long>() {
            {
                add(parkId);
                add(parentPark.getParkId());
            }
        };
        return payInsideCarDao.selectBalance(new ArrayList<Long>(parkIdList), plateNumber);
    }

    @Override
    public int insert(PayInsideCar entity) {
        entity.setId(idHelper.nextId());
        if (entity.getGroupCode() == null) {
            entity.setGroupCode(UserContext.getSessionuser().getGroupCode());
        }
        int result = super.insert(entity);
        if (RequestContextHolder.getRequestAttributes() != null &&
                !StringUtil.isEmpty(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getParameter("pay_inside_plate_bind"))) {
            List<PayInsidePlateBind> binds = parseBinds(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getParameter("pay_inside_plate_bind"), entity.getId());
            if (binds != null && !binds.isEmpty()) {
                payInsidePlateBindService.batchInsert(binds);
            }
        }
        return result;
    }

    /**
     * 格式化绑定的车牌号
     *
     * @param payInsidePlateBindJson
     * @return
     */
    private List<PayInsidePlateBind> parseBinds(String payInsidePlateBindJson, Long insideCarId) {
        List<PayInsidePlateBind> binds = JSONObject.parseObject(payInsidePlateBindJson, new TypeReference<ArrayList<PayInsidePlateBind>>() {
        });
        for (PayInsidePlateBind bind : binds) {
            bind.setIsSync(Constant.INT_FALSE);
            bind.setInsideId(insideCarId);
            bind.setGroupCode(UserContext.getSessionuser().getGroupCode());
            if (bind.getPkey() != null) {
                bind.setId(bind.getPkey());
            } else {
                bind.setId(idHelper.nextId());
            }
        }
        return binds;
    }


    @Override
    public int updateSelectiveById(PayInsideCar entity) {
        int result = super.updateSelectiveById(entity);
        if (RequestContextHolder.getRequestAttributes() != null &&
                !StringUtil.isEmpty(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getParameter("pay_inside_plate_bind"))) {
            //已经有的
            Set<Long> oldBindIds = payInsidePlateBindService.selectListMP(new LambdaQueryWrapper<PayInsidePlateBind>().eq(PayInsidePlateBind::getInsideId, entity.getId()))
                    .stream().map(PayInsidePlateBind::getId).collect(Collectors.toSet());
            List<PayInsidePlateBind> binds = parseBinds(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getParameter("pay_inside_plate_bind"), entity.getId());
            //排除掉本次还存在的
            for (PayInsidePlateBind bind : binds) {
                if (oldBindIds.contains(bind.getId())) {
                    oldBindIds.remove(bind.getId());
                }
            }
            for (Long oldBindId : oldBindIds) {
                dataDelManager.onDel("pay_inside_plate_bind", oldBindId);
            }
            payInsidePlateBindService.deleteBean(PayInsidePlateBind.builder().insideId(entity.getId()).build());
            if (binds != null && !binds.isEmpty()) {
                payInsidePlateBindService.batchInsert(binds);
            }

        }
        return result;
    }
}
