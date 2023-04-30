/**
 * Project Name:payment
 * File Name:SignUtils.java
 * Package Name:cn.swiftpass.utils.payment.sign
 * Date:2014-6-27下午3:22:33
 */

package com.xhb.pay.util;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.xml.sax.InputSource;

import java.io.StringReader;
import java.net.URLEncoder;
import java.util.*;


/**
 * ClassName:SignUtils
 * Function: 签名用的工具箱
 * Date:     2014-6-27 下午3:22:33
 * @author
 */
public class SignUtils {
  /*  public static void main(String[] args) {
        String res = "<xml><appid><![CDATA[wx1f87d44db95cba7a]]></appid>\n" +
                "<charset><![CDATA[UTF-8]]></charset>\n" +
                "<mch_id><![CDATA[7551000001]]></mch_id>\n" +
                "<nonce_str><![CDATA[ad3d4b483b60430eb1244a1b8af8342d]]></nonce_str>\n" +
                "<pay_info><![CDATA[{\"appId\":\"wx1f87d44db95cba7a\",\"timeStamp\":\"1552016114182\",\"status\":\"0\",\"signType\":\"MD5\",\"package\":\"prepay_id=wx081135141463112a346658964074872122\",\"callback_url\":null,\"nonceStr\":\"1552016114182\",\"paySign\":\"9A912AB1E8429926883D16172775A94C\"}]]></pay_info>\n" +
                "<result_code><![CDATA[0]]></result_code>\n" +
                "<sign><![CDATA[1CC60CC442230624F6D321BDA19AEFB5]]></sign>\n" +
                "<sign_type><![CDATA[MD5]]></sign_type>\n" +
                "<status><![CDATA[0]]></status>\n" +
                "<token_id><![CDATA[112268ab98b7165d98ff9276379e8f808]]></token_id>\n" +
                "<version><![CDATA[2.0]]></version>\n" +
                "</xml>";
        Map<String, String> resultMap = null;
        try
        {
            resultMap = XmlUtils.toMap(res.getBytes(), "utf-8");
            res = XmlUtils.toXml(resultMap);
            System.out.println(SignUtils.checkParam(resultMap, "9d101c97133837e13dde2d32a5054abb"));
        }
       catch (Exception e)
       {
           e.printStackTrace();
       }


    }*/

    /** <一句话功能简述>
     * <功能详细描述>验证返回参数
     * @param params
     * @param key
     * @return
     * @see [类、类#方法、类#成员]
     */
    public static boolean checkParam(Map<String, String> params, String key) {
        boolean result = false;
        if (params.containsKey("sign")) {
            String sign = params.get("sign");
            params.remove("sign");
            StringBuilder buf = new StringBuilder((params.size() + 1) * 10);
            SignUtils.buildPayParams(buf, params, false);
            String preStr = buf.toString();
            String signRecieve = MD5.sign(preStr, "&key=" + key, "utf-8");
            result = sign.equalsIgnoreCase(signRecieve);
        }
        return result;
    }

    /**
     * 过滤参数
     * @author
     * @param sArray
     * @return
     */
    public static Map<String, String> paraFilter(Map<String, String> sArray) {
        Map<String, String> result = new HashMap<String, String>(sArray.size());
        if (sArray == null || sArray.size() <= 0) {
            return result;
        }
        for (String key : sArray.keySet()) {
            String value = sArray.get(key);
            if (value == null || value.equals("") || key.equalsIgnoreCase("sign")) {
                continue;
            }
            result.put(key, value);
        }
        return result;
    }

    /** <一句话功能简述>
     * <功能详细描述>将map转成String
     * @param payParams
     * @return
     * @see [类、类#方法、类#成员]
     */
    public static String payParamsToString(Map<String, String> payParams) {
        return payParamsToString(payParams, false);
    }

    public static String payParamsToString(Map<String, String> payParams, boolean encoding) {
        return payParamsToString(new StringBuilder(), payParams, encoding);
    }

    /**
     * @author
     * @param payParams
     * @return
     */
    public static String payParamsToString(StringBuilder sb, Map<String, String> payParams, boolean encoding) {
        buildPayParams(sb, payParams, encoding);
        return sb.toString();
    }

    /**
     * @author
     * @param payParams
     * @return
     */
    public static void buildPayParams(StringBuilder sb, Map<String, String> payParams, boolean encoding) {
        List<String> keys = new ArrayList<String>(payParams.keySet());
        Collections.sort(keys);
        for (String key : keys) {
            sb.append(key).append("=");
            if (encoding) {
                sb.append(urlEncode(payParams.get(key)));
            } else {
                sb.append(payParams.get(key));
            }
            sb.append("&");
        }
        sb.setLength(sb.length() - 1);
    }

    public static String urlEncode(String str) {
        try {
            return URLEncoder.encode(str, "UTF-8");
        } catch (Throwable e) {
            return str;
        }
    }


    public static Element readerXml(String body, String encode) throws DocumentException {
        SAXReader reader = new SAXReader(false);
        InputSource source = new InputSource(new StringReader(body));
        source.setEncoding(encode);
        Document doc = reader.read(source);
        Element element = doc.getRootElement();
        return element;
    }

}

