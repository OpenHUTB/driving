package com.xhb.pay.dto;

import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.Logger;
import com.fhs.common.utils.StringUtil;
import com.fhs.core.base.bean.BaseObject;
import com.mybatis.jpa.common.ColumnNameUtil;
import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.core.util.QuickWriter;
import com.thoughtworks.xstream.io.HierarchicalStreamWriter;
import com.thoughtworks.xstream.io.naming.NoNameCoder;
import com.thoughtworks.xstream.io.xml.PrettyPrintWriter;
import com.thoughtworks.xstream.io.xml.XppDriver;
import com.xhb.pay.bean.ParkPayMch;
import com.xhb.pay.util.SignUtil;
import com.xhb.pay.util.SignUtils;
import lombok.Data;

import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

/**
 * 基础威富通DTO
 * by jackwong
 */
@Data
public class BaseSwiftpassDTO<T extends BaseSwiftpassDTO> extends BaseObject<T> {

    private static final Logger LOG = Logger.getLogger(BaseSwiftpassDTO.class);

    /**
     * 随机字符串
     */
    @XStreamAlias("nonce_str")
    private String nonceStr = StringUtil.getUUID();


    @XStreamAlias("sign_type")
    private String signType;
    /**
     * 商户id
     */
    @XStreamAlias("mch_id")
    private String mchId;


    /**
     * 签名
     */
    @XStreamAlias("sign")
    private String sign;

    /**
     * 初始化签名
     *
     * @param mch 商户信息
     */
    public void initSign(ParkPayMch mch) {
        this.mchId = mch.getSwiftpassMchId();
        this.signType = mch.getSignType();
        Map<String, Object> beanMap = super.asMap();
        Map<String, String> signMap = new HashMap<>();
        for (String key : beanMap.keySet()) {
            signMap.put(ColumnNameUtil.camelToUnderline(key), ConverterUtils.toString(beanMap.get(key)));
        }
        signMap = SignUtils.paraFilter(signMap);
        StringBuilder buf = new StringBuilder((signMap.size() + 1) * 10);
        SignUtils.buildPayParams(buf, signMap, false);
        String preStr = buf.toString();
        LOG.info("准备加签名" + preStr + mch.asJson());
        this.sign = SignUtil.getSign(mch.getSignType(), preStr, mch.getMchSecret(), mch.getPrivateKey());
        LOG.info("加签完成" + this.sign);

    }

    /**
     * 将自己转换为xml
     *
     * @return xml
     */
    public String toXml() {
        LOG.info("准备转换为xml" + this.asJson());
        XStream xstream = new XStream(new XppDriver(new NoNameCoder()) {

            @Override
            public HierarchicalStreamWriter createWriter(Writer out) {
                return new PrettyPrintWriter(out) {
                    // 对所有xml节点的转换都增加CDATA标记
                    boolean cdata = true;

                    @Override
                    @SuppressWarnings("rawtypes")
                    public void startNode(String name, Class clazz) {
                        super.startNode(name, clazz);
                    }

                    @Override
                    public String encodeNode(String name) {
                        return name;
                    }


                    @Override
                    protected void writeText(QuickWriter writer, String text) {
                        if (cdata) {
                            writer.write("<![CDATA[");
                            writer.write(text);
                            writer.write("]]>");
                        } else {
                            writer.write(text);
                        }
                    }
                };
            }
        });
        xstream.processAnnotations(this.getClass());
        String result = xstream.toXML(this);
        LOG.info("准备转换为xml" + this.asJson());
        return result;
    }
}
