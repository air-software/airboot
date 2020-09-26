package com.airboot.project.system.model.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 证件类型枚举
 *
 * @author airoland
 */
@Getter
@AllArgsConstructor
public enum CardTypeEnum {
    其他(0),
    身份证(1),
    ;
    
    @EnumValue
    private Integer code;
}
