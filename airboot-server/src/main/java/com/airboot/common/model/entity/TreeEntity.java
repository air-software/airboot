package com.airboot.common.model.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.util.ArrayList;
import java.util.List;

/**
 * Tree基类
 *
 * @author airboot
 */
@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public class TreeEntity extends BaseEntity {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 父菜单名称
     */
    private String parentName;
    
    /**
     * 父菜单ID
     */
    private Long parentId;
    
    /**
     * 显示顺序
     */
    private Integer orderNum;
    
    /**
     * 祖级列表
     */
    private String ancestors;
    
    /**
     * 子部门
     */
    @Builder.Default
    private List<?> children = new ArrayList<>();
    
}
