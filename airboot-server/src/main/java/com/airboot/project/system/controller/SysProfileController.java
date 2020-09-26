package com.airboot.project.system.controller;

import com.airboot.common.component.BaseController;
import com.airboot.common.core.aspectj.lang.annotation.Log;
import com.airboot.common.core.config.ProjectConfig;
import com.airboot.common.core.exception.CustomException;
import com.airboot.common.core.utils.StringUtils;
import com.airboot.common.core.utils.file.FileUploadUtils;
import com.airboot.common.core.utils.security.Md5Utils;
import com.airboot.common.model.vo.AjaxResult;
import com.airboot.common.security.LoginUser;
import com.airboot.common.security.LoginUserContextHolder;
import com.airboot.common.security.service.TokenService;
import com.airboot.project.monitor.model.enums.BusinessTypeEnum;
import com.airboot.project.system.model.entity.SysUser;
import com.airboot.project.system.service.ISysUserService;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 个人信息 业务处理
 *
 * @author airboot
 */
@RestController
@RequestMapping("/system/user/profile")
public class SysProfileController extends BaseController {
    
    @Resource
    private ISysUserService userService;
    
    @Resource
    private TokenService tokenService;
    
    /**
     * 个人信息
     */
    @GetMapping
    public AjaxResult profile() {
        LoginUser loginUser = LoginUserContextHolder.getLoginUser();
        SysUser user = loginUser.getUser();
        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("user", user);
        dataMap.put("roleGroup", userService.getUserRoleGroup(loginUser.getUserId()));
        dataMap.put("postGroup", userService.getUserPostGroup(loginUser.getUserId()));
        return AjaxResult.success(dataMap);
    }
    
    /**
     * 修改用户
     */
    @Log(title = "个人信息", businessType = BusinessTypeEnum.修改)
    @PutMapping
    public AjaxResult updateProfile(@RequestBody SysUser user) {
        if (userService.updateUserProfile(user)) {
            LoginUser loginUser = LoginUserContextHolder.getLoginUser();
            // 更新缓存用户信息
            loginUser.getUser().setNickname(user.getNickname());
            loginUser.getUser().setMobile(user.getMobile());
            loginUser.getUser().setEmail(user.getEmail());
            loginUser.getUser().setGender(user.getGender());
            tokenService.setLoginUser(loginUser);
            return AjaxResult.success();
        }
        return AjaxResult.error("修改个人信息异常，请联系管理员");
    }
    
    /**
     * 重置密码
     */
    @Log(title = "个人信息", businessType = BusinessTypeEnum.修改)
    @PutMapping("/updatePwd")
    public AjaxResult updatePwd(String oldPassword, String newPassword) {
        if (StringUtils.isBlank(oldPassword) || StringUtils.isBlank(newPassword) || newPassword.length() < 6 || newPassword.length() > 50) {
            throw new CustomException("密码长度必须在6-50位之间");
        }
        
        LoginUser loginUser = LoginUserContextHolder.getLoginUser();
        SysUser user = userService.getByIdWithPwd(loginUser.getUserId());
        if (!Md5Utils.verifyPassword(oldPassword, user.getPassword())) {
            return AjaxResult.error("修改密码失败，旧密码错误");
        }
        
        if (userService.updateUserProfile(SysUser.builder()
            .id(user.getId())
            .password(Md5Utils.encryptPassword(newPassword))
            .build())) {
            return AjaxResult.success();
        }
        return AjaxResult.error("修改密码异常，请联系管理员");
    }
    
    /**
     * 头像上传
     */
    @Log(title = "个人信息", businessType = BusinessTypeEnum.修改)
    @PostMapping("/avatar")
    public AjaxResult avatar(@RequestParam("avatarfile") MultipartFile file) throws IOException {
        if (!file.isEmpty()) {
            LoginUser loginUser = LoginUserContextHolder.getLoginUser();
            String avatar = FileUploadUtils.upload(ProjectConfig.getAvatarPath(), file);
            if (userService.updateUserProfile(SysUser.builder()
                .id(loginUser.getUserId())
                .avatar(avatar)
                .build())) {
                // 更新缓存用户头像
                loginUser.getUser().setAvatar(avatar);
                tokenService.setLoginUser(loginUser);
                return AjaxResult.success(avatar);
            }
        }
        return AjaxResult.error("上传图片异常，请联系管理员");
    }
}
