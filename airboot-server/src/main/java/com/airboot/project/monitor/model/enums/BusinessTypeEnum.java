package com.airboot.project.monitor.model.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 业务类型枚举
 *
 * @author airoland
 */
@Getter
@AllArgsConstructor
public enum BusinessTypeEnum {
    其它(0),
    新增(1),
    修改(2),
    删除(3),
    授权(4),
    导出(5),
    导入(6),
    强退(7),
    生成代码(8),
    清空数据(9),
    ;
    
    @EnumValue
    private Integer code;
}
