package com.xhb.pay.util;

import org.apache.commons.codec.binary.Base64;

import java.util.Map;


/**
 * @author zeming.fan@swiftpass.cn
 * 威富通的垃圾代码
 */
public class SignUtil {
    //private final static Logger log = LoggerFactory.getLogger(SignUtil.class);

    //请求时根据不同签名方式去生成不同的sign
    public static String getSign(String signType, String preStr, String secret, String mchPrivateKey) {
        if ("RSA_1_256".equals(signType)) {
            try {
                return SignUtil.sign(preStr, "RSA_1_256", mchPrivateKey);
            } catch (Exception e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
        } else {
            return MD5.sign(preStr, "&key=" + secret, "utf-8");
        }
        return null;
    }

    //对返回参数的验证签名
    public static boolean verifySign(String sign, String signType, Map<String, String> resultMap, String secret, String platPublicKey) {
        if ("RSA_1_256".equals(signType)) {
            Map<String, String> Reparams = SignUtils.paraFilter(resultMap);
            StringBuilder rebuf = new StringBuilder((Reparams.size() + 1) * 10);
            SignUtils.buildPayParams(rebuf, Reparams, false);
            String repreStr = rebuf.toString();
            try {
                if (SignUtil.verifySign(repreStr, sign, "RSA_1_256", platPublicKey)) {
                    return true;
                }
            } catch (Exception e) {
                return false;
            }
        } else if ("MD5".equals(signType)) {
            if (SignUtils.checkParam(resultMap, secret)) {
                return true;
            }
        }
        return false;
    }

    public static boolean verifySign(String preStr, String sign, String signType, String platPublicKey) throws Exception {
        // 调用这个函数前需要先判断是MD5还是RSA
        // 商户的验签函数要同时支持MD5和RSA
        RSAUtil.SignatureSuite suite = null;

        if ("RSA_1_1".equals(signType)) {
            suite = RSAUtil.SignatureSuite.SHA1;
        } else if ("RSA_1_256".equals(signType)) {
            suite = RSAUtil.SignatureSuite.SHA256;
        } else {
            throw new Exception("不支持的签名方式");
        }

        boolean result = RSAUtil.verifySign(suite, preStr.getBytes("UTF8"), Base64.decodeBase64(sign.getBytes("UTF8")),
                platPublicKey);

        return result;
    }

    public static String sign(String preStr, String signType, String mchPrivateKey) throws Exception {
        RSAUtil.SignatureSuite suite = null;
        if ("RSA_1_1".equals(signType)) {
            suite = RSAUtil.SignatureSuite.SHA1;
        } else if ("RSA_1_256".equals(signType)) {
            suite = RSAUtil.SignatureSuite.SHA256;
        } else {
            throw new Exception("不支持的签名方式");
        }
        byte[] signBuf = RSAUtil.sign(suite, preStr.getBytes("UTF8"),
                mchPrivateKey);
        return new String(Base64.encodeBase64(signBuf), "UTF8");
    }
}
