package com.airboot.project.system.model.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 性别枚举
 *
 * @author airoland
 */
@Getter
@AllArgsConstructor
public enum GenderEnum {
    保密(0),
    男(1),
    女(2),
    ;
    
    @EnumValue
    private Integer code;
}
