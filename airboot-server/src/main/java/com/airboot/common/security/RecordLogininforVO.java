package com.airboot.common.security;

import com.airboot.common.model.enums.DeviceEnum;
import lombok.Builder;
import lombok.Data;

/**
 * 用户登录信息记录
 *
 * @author airoland
 */
@Data
@Builder
public class RecordLogininforVO {
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 登录账号（手机号、邮箱或用户名等）
     */
    private String account;
    
    /**
     * 登录设备
     */
    private DeviceEnum device;
    
    /**
     * 结果状态
     */
    private String status;
    
    /**
     * 消息
     */
    private String message;
    
}
