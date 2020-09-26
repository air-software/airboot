package com.airboot.common.core.utils;

import lombok.extern.slf4j.Slf4j;
import org.springframework.core.env.StandardEnvironment;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.stereotype.Component;
import org.springframework.util.ClassUtils;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.Map;

/**
 * 枚举工具类
 *
 * @author airoland
 * @date 2020/9/21 17:46
 */
@Slf4j
@Component
public class EnumUtil {
    
    private static final String ENUM_PACKAGE = "com.airboot.**.model.enums";
    
    private static final String DEFAULT_RESOURCE_PATTERN = "**/*.class";
    
    private static Map<String, String> ENUM_MAP = new HashMap<>();
    
    public static String getEnumFullNameByTableColumn(String columnName) {
        String key = StringUtils.snakeToPascalCase(columnName) + "Enum";
        return ENUM_MAP.get(key);
    }
    
    @PostConstruct
    private void init() {
        // 将包路径转换为文件目录路径
        String packageSearchPath = ResourcePatternResolver.CLASSPATH_ALL_URL_PREFIX
            + ClassUtils.convertClassNameToResourcePath(new StandardEnvironment().resolveRequiredPlaceholders(ENUM_PACKAGE))
            + '/'
            + DEFAULT_RESOURCE_PATTERN;
        ResourcePatternResolver resourceLoader = new PathMatchingResourcePatternResolver();
        try {
            // 通过Spring的resourceloader直接获取路径下的class文件
            Resource[] resources = resourceLoader.getResources(packageSearchPath);
            for (Resource resource : resources) {
                String filePath = resource.getURL().getPath();
                String enumFullName = "com." + filePath.replaceAll("/", ".").split("com\\.")[1].replaceAll(".class", "");
    
                String[] strArr = StringUtils.split(enumFullName, ".");
                ENUM_MAP.put(strArr[strArr.length - 1], enumFullName);
            }
        } catch (Exception e) {
            log.error("---初始化EnumUtil异常---", e);
            e.printStackTrace();
        }
    }
    
}
