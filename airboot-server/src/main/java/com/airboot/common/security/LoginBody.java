package com.airboot.common.security;

import com.airboot.common.model.enums.DeviceEnum;
import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * 用户登录对象
 *
 * @author airboot
 */
@Data
public class LoginBody {
    
    /**
     * 登录账号（手机号、邮箱或用户名等）
     */
    @NotBlank(message = "账号不能为空")
    private String account;
    
    /**
     * 用户密码
     */
    @NotBlank(message = "密码不能为空")
    private String password;
    
    /**
     * 验证码
     */
    private String code;
    
    /**
     * 唯一标识
     */
    private String uuid = "";
    
    /**
     * 登录设备
     */
    private DeviceEnum device;
    
}
