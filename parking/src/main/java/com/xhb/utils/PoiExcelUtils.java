package com.xhb.utils;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.xssf.streaming.SXSSFFormulaEvaluator;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.*;

import java.util.List;

public class PoiExcelUtils {

    /**
     * 给Cell添加批注
     *
     * @param cell 单元格
     * @param value 批注内容
     * @param extension 扩展名
     */
    public static void addComment(Cell cell, String value, String extension) {
        Sheet sheet = cell.getSheet();
        cell.removeCellComment();
        if ("xls".equals(extension)) {
            ClientAnchor anchor = new HSSFClientAnchor();
            // 关键修改
            anchor.setDx1(0);
            anchor.setDx2(0);
            anchor.setDy1(0);
            anchor.setDy2(0);
            anchor.setCol1(cell.getColumnIndex());
            anchor.setRow1(cell.getRowIndex());
            anchor.setCol2(cell.getColumnIndex() + 5);
            anchor.setRow2(cell.getRowIndex() + 6);
            // 结束
            Drawing drawing = sheet.createDrawingPatriarch();
            Comment comment = drawing.createCellComment(anchor);
            // 输入批注信息
            comment.setString(new HSSFRichTextString(value));
            // 将批注添加到单元格对象中
            cell.setCellComment(comment);
        } else if ("xlsx".equals(extension)) {
            ClientAnchor anchor = new XSSFClientAnchor();
            // 关键修改
            anchor.setDx1(0);
            anchor.setDx2(0);
            anchor.setDy1(0);
            anchor.setDy2(0);
            anchor.setCol1(cell.getColumnIndex());
            anchor.setRow1(cell.getRowIndex());
            anchor.setCol2(cell.getColumnIndex() + 5);
            anchor.setRow2(cell.getRowIndex() + 6);
            // 结束
            Drawing drawing = sheet.createDrawingPatriarch();
            Comment comment = drawing.createCellComment(anchor);
            // 输入批注信息
            comment.setString(new XSSFRichTextString(value));
            // 将批注添加到单元格对象中
            cell.setCellComment(comment);
        }
    }


    /**
     * 添加下拉
     * @param targetSheet 指定sheet页
     * @param list 下拉数据
     * @param cloumnIndex 设置列index
     * @param fromRow 设置起始行 (一般从1开始)
     * @param toRow 设置结束行
     */
    public static void createSheetSelect(Sheet targetSheet, List<String> list, int cloumnIndex, int fromRow, int toRow){
            DataValidationHelper helper = targetSheet.getDataValidationHelper();
            DataValidationConstraint constraint = helper.createExplicitListConstraint(list.toArray(new String[]{}));
            CellRangeAddressList rangeList = new CellRangeAddressList(fromRow, toRow, cloumnIndex, cloumnIndex);

            DataValidation validation = helper.createValidation(constraint, rangeList);
            //这两行设置单元格只能是列表中的内容，否则报错
            validation.setSuppressDropDownArrow(true);
            validation.setShowErrorBox(true);
            targetSheet.addValidationData(validation);
    }

    /**
     * 设置单元格样式
     * @param workbook
     * @param fontsize
     * @return
     */
    public static CellStyle setCellStyle(Workbook workbook){
        CellStyle style = workbook.createCellStyle();

        style.setBorderTop(BorderStyle.THIN);
        //设置右边框线条类型
        style.setBorderRight(BorderStyle.THIN);
        //设置下边框线条类型
        style.setBorderBottom(BorderStyle.THIN);
        //设置左边框线条类型

        //水平居中
        style.setAlignment(HorizontalAlignment.CENTER);
        //垂直居中
        style.setVerticalAlignment(VerticalAlignment.CENTER);

        DataFormat dataFormat = workbook.createDataFormat();
        // 设置为文本格式
        style.setDataFormat(dataFormat.getFormat("@"));
        return style;
    }


    /**
     * 获取CellValue的值
     * @param cellValue CellValue
     * @param workbook 工作薄
     * @return 解析完的数据
     */
    private static Object getCellData(CellValue cellValue, Workbook workbook) {
        Object result = null;

        CellType cellType = cellValue.getCellTypeEnum();
        switch (cellType) {
            case STRING:
                result = cellValue.getStringValue();
                break;
            case BOOLEAN:
                result = cellValue.getBooleanValue();
                break;
            case NUMERIC:
                result = cellValue.getNumberValue();
                break;
            default:
                break;
        }
        return result;
    }

    /**
     * 解析列
     * @param cell 单元格
     * @param workbook 工作簿
     * @return 解析完的数据
     */
    public static Object getCellData(Cell cell, Workbook workbook) {
        Object result = null;
        CellType cellType = cell.getCellTypeEnum();
        switch (cellType) {
            case STRING:
                result = cell.getStringCellValue();
                break;
            case BOOLEAN:
                result = cell.getBooleanCellValue();
                break;
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    result = cell.getDateCellValue();
                } else {
                    result = cell.getNumericCellValue();
                }
                break;
            case FORMULA:
                FormulaEvaluator formulaEvaluator = null;
                if (workbook instanceof HSSFWorkbook) {
                    formulaEvaluator = new HSSFFormulaEvaluator((HSSFWorkbook) workbook);
                } else if (workbook instanceof XSSFWorkbook) {
                    formulaEvaluator = new XSSFFormulaEvaluator((XSSFWorkbook) workbook);
                } else if (workbook instanceof SXSSFWorkbook) {
                    formulaEvaluator = new SXSSFFormulaEvaluator((SXSSFWorkbook) workbook);
                }
                if (formulaEvaluator != null) {
                    CellValue evaluate = formulaEvaluator.evaluate(cell);
                    result = getCellData(evaluate, workbook);
                }
                break;
            default:
                result = null;
                break;
        }
        return result;
    }
}
