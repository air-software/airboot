package com.airboot.common.core.config;

import com.airboot.common.core.config.properties.AppProp;
import com.airboot.common.core.constant.Constants;
import com.airboot.common.core.interceptor.RepeatSubmitInterceptor;
import com.airboot.common.security.interceptor.AuthInterceptor;
import com.airboot.common.security.interceptor.LoginInterceptor;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * MVC配置
 *
 * @author airoland
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    
    @Resource
    private LoginInterceptor loginInterceptor;
    
    @Resource
    private AuthInterceptor authInterceptor;
    
    @Resource
    private RepeatSubmitInterceptor repeatSubmitInterceptor;
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 本地文件上传路径
        registry.addResourceHandler(Constants.RESOURCE_PREFIX + "/**").addResourceLocations("file:" + ProjectConfig.getProfile() + "/");
        
        // swagger配置
        registry.addResourceHandler("swagger-ui.html").addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");
    }
    
    /**
     * 自定义拦截规则
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor).addPathPatterns("/**")
            .excludePathPatterns(Constants.EXCLUDE_PATH_PATTERNS);
        registry.addInterceptor(authInterceptor).addPathPatterns("/**")
            .excludePathPatterns(Constants.EXCLUDE_PATH_PATTERNS);
        registry.addInterceptor(repeatSubmitInterceptor).addPathPatterns("/**")
            .excludePathPatterns(Constants.EXCLUDE_PATH_PATTERNS);
    }
    
    /**
     * JSON序列化全局配置
     */
    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        // 针对分布式全局唯一Long型ID（比如Snowflake），需要统一转String给前端，以防止精度丢失
        MappingJackson2HttpMessageConverter jackson2HttpMessageConverter = new MappingJackson2HttpMessageConverter();
        ObjectMapper objectMapper = new ObjectMapper();
        SimpleModule simpleModule = new SimpleModule();
        // 超出JS整数范围的值转为String，参考 JsonLongSerializer
        simpleModule.addSerializer(Long.class, JsonLongSerializer.INSTANCE);
        simpleModule.addSerializer(Long.TYPE, JsonLongSerializer.INSTANCE);
        objectMapper.registerModule(simpleModule);
        jackson2HttpMessageConverter.setObjectMapper(objectMapper);
        converters.add(jackson2HttpMessageConverter);
        
        // 防止入参中有不匹配的属性时报400
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }
    
    /**
     * 跨域请求配置
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // 只有非生产环境才会设置允许跨域
        if (AppProp.NOT_PROD_ENV) {
            registry.addMapping("/**")
                .allowedMethods("*")
                .allowedOrigins("*")
                .allowedHeaders("*");
        }
    }
    
}
