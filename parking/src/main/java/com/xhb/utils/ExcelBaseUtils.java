package com.xhb.utils;


import com.xhb.utils.ExcelField;
import com.alibaba.excel.EasyExcel;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fhs.system.bean.Wordbook;
import com.fhs.system.service.WordBookService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.BidiMap;
import org.apache.commons.collections4.bidimap.DualHashBidiMap;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Excel工具栏 v1.0
 * 目前支持高版本后最为【.xlsx】
 *
 * @author yutao
 * @date 2022-05-06
 */
@Slf4j
public class ExcelBaseUtils {

    /**
     * Excel 导出
     *
     * @param datas
     * @param fields
     * @return
     */
    public static OutputStream exportExcel(OutputStream outputStream, List<ExcelField> fields, List<?> datas) {
        try {
            SXSSFWorkbook workbook = new SXSSFWorkbook();
            SXSSFSheet sheet = workbook.createSheet();
            //设置边框颜色
            CellStyle cellStyle = PoiExcelUtils.setCellStyle(workbook);
            //设置表头
            Row row = sheet.createRow(0);
            //过滤不导出的
            fields = fields.stream().filter(x -> null != x.getExport() && x.getExport()).collect(Collectors.toList());
            //标题填充
            for (int i = 0; i < fields.size(); i++) {
                //单个单元格对象
                ExcelField excelField = fields.get(i);
                Cell cell = row.createCell(i);
                Integer with = 2000;
                if(null != excelField.getWith()){
                    with = excelField.getWith();
                }
                sheet.setColumnWidth(i, with); //设置列宽
                cell.setCellStyle(cellStyle);
                cell.setCellValue(excelField.getName());
                //隐藏列
                if(null != excelField.getHidden() && excelField.getHidden()){
                    sheet.setColumnHidden(i,true);
                }
            }
            //导出内容填充
            for (int i = 0; i < datas.size(); i++) {
                Object data = datas.get(i);
                int rowIndex = i + 1;
                Row rowContent = sheet.createRow(rowIndex);
                JSONObject jsonObject = JSON.parseObject(JSON.toJSONString(data));
                for (int j = 0; j < fields.size(); j++) {
                    //单个单元格对象
                    ExcelField excelField = fields.get(j);
                    Cell cell = rowContent.createCell(j);
                    Integer with = 2000;
                    if(null != excelField.getWith()){
                        with = excelField.getWith();
                    }
                    sheet.setColumnWidth(j, with); //设置列宽
                    cell.setCellStyle(cellStyle);
                    cell.setCellValue(jsonObject.getString(excelField.getCode()));
                }
            }
            //FileOutputStream outputStream=new FileOutputStream("C:\\Users\\Administrator\\Desktop\\write.xlsx");
            workbook.write(outputStream);
            outputStream.flush();
            return outputStream;
        } catch (Exception e) {
            log.error("excel生成失败 e={}", e);
        }

        return outputStream;
    }


    /**
     * Excel导入
     *
     * @param <T>
     * @param is          文件流
     * @param fields      标题模板
     * @param resultClass
     * @return
     */
    public static <T> List<T> easyImportExcel(InputStream is, List<ExcelField> fields, Class<T> resultClass, WordBookService wordBookService) {
        Map<String, String> fieldMap = fields.stream().collect(Collectors.toMap(ExcelField::getName, ExcelField::getCode));
        //excel数据读取
        List<Map<Integer, String>> listMap = EasyExcel.read(is).sheet(0).headRowNumber(0).doReadSync();
        log.info("importExcel excel info = {}", JSON.toJSONString(listMap));

        //解析数据集合
        List<Map<String, String>> dataList = new ArrayList<>();
        //标题集合
        BidiMap<Integer, String> titleMap = new DualHashBidiMap<>();
        for (int i = 0; i < listMap.size(); i++) {
            // 返回每条数据的键值对 表示所在的列 和所在列的值
            Map<Integer, String> integerStringMap = listMap.get(i);
            Map<String, String> codeValue = new HashMap<>();
            if (i == 0) {
                //标题列
                titleMap = new DualHashBidiMap<>(integerStringMap);
            } else {
                //内容
                for (Integer no : integerStringMap.keySet()) {
                    String name = titleMap.get(no);
                    codeValue.put(fieldMap.get(name), integerStringMap.get(no));
                }
                dataList.add(codeValue);
            }
        }
        //校验
        StringBuilder validStr = valid(dataList, fields, wordBookService);
        if (validStr.length() > 0) {
            throw new RuntimeException(validStr.toString());
        }
        return JSON.parseArray(JSON.toJSONString(dataList), resultClass);
    }

    /**
     * Excel校验
     * <p>
     * keng 1.需要补充查询字典接口
     *
     * @param dataList 解析数据集合
     * @param fields   标题模板
     * @return
     */
    public static StringBuilder valid(List<Map<String, String>> dataList, List<ExcelField> fields, WordBookService wordBookService) {
        StringBuilder errorStr = new StringBuilder();
        Map<String, ExcelField> fieldCodeMap = fields.stream().collect(Collectors.toMap(e -> e.getCode(), v -> v));
        HashMap<String, List<String>> WordbookMap = new HashMap<>();
        for (ExcelField field : fields) {
            //TODO keng 查询字典数据库
            if (!StringUtils.isBlank(field.getType()) && field.getType().contains("select")) {
                List<Wordbook> wordBookList = wordBookService.getWordBookList(field.getSelectWordbookCode());
                List<String> wordbookDescList = wordBookList.stream().map(Wordbook::getWordbookDesc).collect(Collectors.toList());
                if (!wordbookDescList.isEmpty()) {
                    WordbookMap.put(field.getSelectWordbookCode(), wordbookDescList);
                }
            }
        }
        for (int i = 0; i < dataList.size(); i++) {
            StringBuilder rowError = new StringBuilder();
            //下标从0开始，标题多占一行，所以+2
            int index = i + 2;
            rowError.append("\n第" + index + "行：");
            boolean columnErrorFlag = false;

            Map<String, String> dataMap = dataList.get(i);
            for (String field : dataMap.keySet()) {
                String value = dataMap.get(field);
                ExcelField excelField = fieldCodeMap.get(field);
                //必填校验
                if (!StringUtils.isBlank(excelField.getRule()) && excelField.getRule().contains("required")) {
                    if (StringUtils.isBlank(value)) {
                        rowError.append(excelField.getName() + "字段为必填项,");
                        columnErrorFlag = true;
                    }
                }
                //重复校验
                if (null != excelField.getNotRepeat() && excelField.getNotRepeat()) {
                    List<Map<String, String>> valueList = dataList.stream().filter(a ->
                            !StringUtils.isBlank(a.get(field)) &&
                                    a.get(field).equals(value)
                    ).collect(Collectors.toList());

                    if (valueList.size() > 1) {
                        rowError.append(excelField.getName() + "字段内容 {" + value + "} 为不能重复,");
                        columnErrorFlag = true;
                    }
                }
                //下拉校验
                if (!StringUtils.isBlank(excelField.getType()) && excelField.getType().contains("select")) {
                    //查询字典
                    if (WordbookMap.containsKey(excelField.getSelectWordbookCode())) {
                        List<String> wordbookCodeList = WordbookMap.get(excelField.getSelectWordbookCode());
                        if (!wordbookCodeList.contains(value)) {
                            rowError.append(excelField.getName() + "字段内容 {" + value + "} 与字典配置不相同,");
                            columnErrorFlag = true;
                        }

                    }
                }
            }

            //添加行错误信息
            if (columnErrorFlag) {
                //去掉最后一位 ','
                errorStr.append(rowError.substring(0, rowError.length() - 1));
            }

        }
        return errorStr;
    }

    /**
     * 导出excel模板
     * 1. 创建一个workbook
     * 2. 通过workbook的creatSheet创建一个Sheet
     * 3. 通过Sheet的createRow创建row
     * 4. 通过row的createCell创建cell
     * <p>
     * keng 1.需要补充查询字典接口
     *
     * @param fields
     */
    public static void exportTemplate(OutputStream outputStream, List<ExcelField> fields, WordBookService wordBookService) {
        SXSSFWorkbook workbook = new SXSSFWorkbook();
        SXSSFSheet sheet = workbook.createSheet();
        //设置边框颜色
        CellStyle cellStyle = PoiExcelUtils.setCellStyle(workbook);
        //设置表头
        Row row = sheet.createRow(0);
        //过滤不导出的
        fields = fields.stream().filter(x -> null != x.getImportFlag() && x.getImportFlag()).collect(Collectors.toList());
        for (int i = 0; i < fields.size(); i++) {
            //单个单元格对象
            ExcelField excelField = fields.get(i);
            Cell cell = row.createCell(i);
            sheet.setColumnWidth(i, excelField.getWith()); //设置列宽

            //必填样式
            if (!StringUtils.isBlank(excelField.getRule()) && excelField.getRule().contains("required")) {
                PoiExcelUtils.addComment(cell, "必填", "xlsx");
            }
            //下拉填充
            if (!StringUtils.isBlank(excelField.getType()) && excelField.getType().contains("select")) {
                List<Wordbook> wordBookList = wordBookService.getWordBookList(excelField.getSelectWordbookCode());
                List<String> wordbookDescList = wordBookList.stream().map(Wordbook::getWordbookDesc).collect(Collectors.toList());
                if (!wordbookDescList.isEmpty()) {
                    PoiExcelUtils.createSheetSelect(sheet, wordbookDescList, i, 1, 1000);
                }
            }
            cell.setCellStyle(cellStyle);
            cell.setCellValue(excelField.getName());
        }
        try {
            //FileOutputStream outputStream = new FileOutputStream("C:\\Users\\Administrator\\Desktop\\test.xlsx");
            workbook.write(outputStream);
            outputStream.flush();
        } catch (Exception e) {
            log.error("excel生成失败 e={}", e);
        }
    }

}
