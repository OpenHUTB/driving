package com.xhb.pay.util;

import com.alibaba.fastjson.JSON;
import com.fhs.common.utils.Logger;
import com.fhs.core.config.EConfig;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.AlgorithmParameters;
import java.security.Key;
import java.security.Security;
import java.util.Base64;

/**
 * jdyfy 加密
 *
 * @author yutao
 * @date 2019 -11-02 11:22:09
 */
@Component
public class AesUtils {

    private static final Logger LOG = Logger.getLogger(AesUtils.class);

    static {
        //如果是PKCS7Padding填充方式，则必须加上下面这行
        Security.addProvider(new BouncyCastleProvider());
    }

    public static String encrypt(byte[] dataByte, byte[] keyByte, byte[] ivByte) throws Exception {

        //加密之前，先从Base64格式还原到原始格式
        Base64.Decoder decoder = Base64.getDecoder();

        String encryptedData = null;

        //指定算法，模式，填充方式，创建一个Cipher
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS7Padding", "BC");

        //生成Key对象
        Key sKeySpec = new SecretKeySpec(keyByte, "AES");

        //把向量初始化到算法参数
        AlgorithmParameters params = AlgorithmParameters.getInstance("AES");
        params.init(new IvParameterSpec(ivByte));

        //指定用途，密钥，参数 初始化Cipher对象
        cipher.init(Cipher.ENCRYPT_MODE, sKeySpec, params);

        //指定加密
        byte[] result = cipher.doFinal(dataByte);

        //对结果进行Base64编码，否则会得到一串乱码，不便于后续操作
        Base64.Encoder encoder = Base64.getEncoder();
        encryptedData = encoder.encodeToString(result);
        return encryptedData;
    }

    public String decrypt(String encryptedData, String sessionKey, String iv) throws Exception {

        //解密之前先把Base64格式的数据转成原始格式
        Base64.Decoder decoder = Base64.getDecoder();
        byte[] dataByte = decoder.decode(encryptedData);
        byte[] keyByte = sessionKey.getBytes();
        byte[] ivByte = iv.getBytes();

        String data = null;

        //指定算法，模式，填充方法 创建一个Cipher实例
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS7Padding");

        //生成Key对象
        Key sKeySpec = new SecretKeySpec(keyByte, "AES");

        //把向量初始化到算法参数
        AlgorithmParameters params = AlgorithmParameters.getInstance("AES");
        params.init(new IvParameterSpec(ivByte));

        //指定用途，密钥，参数 初始化Cipher对象
        cipher.init(Cipher.DECRYPT_MODE, sKeySpec, params);

        //执行解密
        byte[] result = cipher.doFinal(dataByte);

        //解密后转成字符串
        data = new String(result, "UTF-8");

        return data;
    }



}
