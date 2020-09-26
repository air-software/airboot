package com.airboot.project.system.mapper;

import com.airboot.common.component.MyBaseMapper;
import com.airboot.project.system.model.entity.SysMenu;
import com.airboot.project.system.model.vo.SearchSysMenuVO;

import java.util.List;

/**
 * 菜单表 数据层
 *
 * @author airboot
 */
public interface SysMenuMapper extends MyBaseMapper<SysMenu> {
    
    /**
     * 查询系统菜单列表
     *
     * @param search 查询条件
     * @return 菜单列表
     */
    List<SysMenu> findList(SearchSysMenuVO search);
    
    /**
     * 根据用户所有权限
     *
     * @return 权限列表
     */
    List<String> findMenuPerms();
    
    /**
     * 根据用户查询系统菜单列表
     *
     * @param search 查询条件
     * @return 菜单列表
     */
    List<SysMenu> findListByUserId(SearchSysMenuVO search);
    
    /**
     * 根据用户ID查询权限
     *
     * @param userId 用户ID
     * @return 权限列表
     */
    List<String> findMenuPermsByUserId(Long userId);
    
    /**
     * 根据用户ID查询菜单
     *
     * @return 菜单列表
     */
    List<SysMenu> findMenuTreeAll();
    
    /**
     * 根据用户ID查询菜单
     *
     * @param userId 用户ID
     * @return 菜单列表
     */
    List<SysMenu> findMenuTreeByUserId(Long userId);
    
    /**
     * 根据角色ID查询菜单树信息
     *
     * @param roleId 角色ID
     * @return 选中菜单列表
     */
    List<Long> findIdListByRoleId(Long roleId);
    
    /**
     * 是否存在菜单子节点
     *
     * @param menuId 菜单ID
     * @return 结果
     */
    int hasChildByMenuId(Long menuId);
    
}
