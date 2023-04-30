package com.xhb.common;

import com.fhs.common.utils.*;
import com.fhs.core.config.EConfig;
import org.apache.commons.io.FileUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Component;

import java.io.*;
import java.util.HashMap;
import java.util.Map;

/**
 * 上传文件到文件服务
 */
@Component
public class FileUploader {

    private static final Logger LOG = Logger.getLogger(FileUploader.class);

    public String updateFile(File file) {
        Map<String, File> fileMap = new HashMap<>();
        fileMap.put("Filedata", file);
        try {
            String httpResult = HttpUtils.uploadFile(EConfig.getPathPropertiesValue("uploadFileUrl"), fileMap);
            Map<String, Object> httpResultMap = JsonUtils.parseJSON2Map(httpResult);
            if (httpResultMap != null && httpResultMap.containsKey("fileId")) {
                return ConverterUtils.toString(httpResultMap.get("fileId"));
            } else {
                LOG.error("生成文件失败");
            }
        } catch (Exception e) {
            LOG.error("生成文件失败", e);
        } finally {
            file.delete();
        }
        return null;
    }


    /**
     * @param workbook
     * @return
     */
    public File makeCommon(Workbook workbook) {
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
            workbook.write(os);
        } catch (IOException e) {
            LOG.error("转换输入流失败");
        }
        byte[] content = os.toByteArray();
        InputStream is = new ByteArrayInputStream(content);
        //把InputStream 保存到本地
        String filePath = EConfig.getPathPropertiesValue("saveFilePath") + StringUtil.getUUID() + ".xlsx";
        try {
            FileUtils.copyInputStreamToFile(is, new File(filePath));
        } catch (IOException e) {
            LOG.error("生成文件失败");
        }
        return new File(filePath);
    }
}
