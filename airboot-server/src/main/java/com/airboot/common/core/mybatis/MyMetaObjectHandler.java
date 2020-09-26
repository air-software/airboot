package com.airboot.common.core.mybatis;

import com.airboot.common.security.LoginUser;
import com.airboot.common.security.LoginUserContextHolder;
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;

import java.util.Date;

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
        if (loginUser != null) {
            this.setFieldValByName("createBy", loginUser.getAccount(), metaObject);
            this.setFieldValByName("updateBy", loginUser.getAccount(), metaObject);
        }
    }
    
    @Override
    public void updateFill(MetaObject metaObject) {
        this.setFieldValByName("updateTime", new Date(), metaObject);
    
        LoginUser loginUser = LoginUserContextHolder.getLoginUser();
        if (loginUser != null) {
            this.setFieldValByName("updateBy", loginUser.getAccount(), metaObject);
        }
    }
}
