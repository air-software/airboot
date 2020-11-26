package com.airboot.common.core.mybatis;

import com.airboot.common.security.LoginUser;
import com.airboot.common.security.LoginUserContextHolder;
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.Optional;

/**
 * Mybatis-Plus自动填充处理器
 *
 * @author airoland
 * @date 2020/8/16 15:07
 */
@Component
public class MyMetaObjectHandler implements MetaObjectHandler {
    
    @Override
    public void insertFill(MetaObject metaObject) {
        this.setFieldValByName("createTime", new Date(), metaObject);
        this.setFieldValByName("updateTime", new Date(), metaObject);
        
        LoginUser loginUser = LoginUserContextHolder.getLoginUser();
        // 如果能获取到登录用户，则设置创建者/更新者为登录账号，否则设为空字符串
        if (loginUser != null) {
            this.setFieldValByName("createBy", loginUser.getAccount(), metaObject);
            this.setFieldValByName("updateBy", loginUser.getAccount(), metaObject);
        } else {
            String createBy = Optional.ofNullable((String) metaObject.getValue("createBy")).orElse("");
            this.setFieldValByName("createBy", createBy, metaObject);
            String updateBy = Optional.ofNullable((String) metaObject.getValue("updateBy")).orElse("");
            this.setFieldValByName("updateBy", updateBy, metaObject);
        }
    }
    
    @Override
    public void updateFill(MetaObject metaObject) {
        this.setFieldValByName("updateTime", new Date(), metaObject);
    
        LoginUser loginUser = LoginUserContextHolder.getLoginUser();
        if (loginUser != null) {
            this.setFieldValByName("updateBy", loginUser.getAccount(), metaObject);
        } else {
            String updateBy = Optional.ofNullable((String) metaObject.getValue("updateBy")).orElse("");
            this.setFieldValByName("updateBy", updateBy, metaObject);
        }
    }
}
