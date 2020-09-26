package com.airboot.project.system.model.vo;

import com.airboot.common.model.vo.BaseSearchVO;
import lombok.Data;

/**
 * 查询部门分页条件
 *
 * @author airboot
 */
@Data
public class SearchSysMenuVO extends BaseSearchVO {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 菜单名称
     */
    private String menuName;
    
    /**
     * 是否隐藏（0显示 1隐藏）
     */
    private Boolean hidden;
    
    /**
     * 用户ID
     */
    private Long userId;

}
