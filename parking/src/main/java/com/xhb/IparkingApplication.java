package com.xhb;

import com.alicp.jetcache.anno.config.EnableCreateCacheAnnotation;
import com.alicp.jetcache.anno.config.EnableMethodCache;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.cloud.netflix.feign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;


@SpringBootApplication
@MapperScan(basePackages = {"com.fhs.*.dao", "com.fhs.*.*.dao", "com.xhb.*.*.dao", "com.xhb.*.dao"})
@EnableMethodCache(basePackages = {"com.xhb", "com.fhs"})
@EnableCreateCacheAnnotation
@EnableConfigurationProperties
@EnableFeignClients(basePackages = {"com.fhs", "com.xhb"})
@ComponentScan({"com.fhs", "com.xhb"})
@ServletComponentScan(basePackages = {"com.xhb.collector.filter"})
public class IparkingApplication {
    public static void main(String[] args) {

        try {
            SpringApplication.run(IparkingApplication.class, args);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
