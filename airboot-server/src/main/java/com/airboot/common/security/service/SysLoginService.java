package com.airboot.common.security.service;

import com.airboot.common.core.config.ProjectConfig;
import com.airboot.common.core.constant.Constants;
import com.airboot.common.core.exception.user.*;
import com.airboot.common.core.manager.AsyncManager;
import com.airboot.common.core.manager.factory.AsyncFactory;
import com.airboot.common.core.redis.RedisCache;
import com.airboot.common.core.utils.MessageUtils;
import com.airboot.common.core.utils.security.Md5Utils;
import com.airboot.common.model.enums.DeviceEnum;
import com.airboot.common.model.enums.StatusEnum;
import com.airboot.common.security.LoginBody;
import com.airboot.common.security.LoginUser;
import com.airboot.common.security.RecordLogininforVO;
import com.airboot.project.system.model.entity.SysUser;
import com.airboot.project.system.service.ISysUserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Collection;
import java.util.concurrent.TimeUnit;

/**
 * 登录校验方法
 *
 * @author airboot
 */
@Service
public class SysLoginService {
    
    @Resource
    private ISysUserService userService;
    
    @Resource
    private TokenService tokenService;
    
    @Resource
    private SysPermissionService permissionService;
    
    @Resource
    private RedisCache redisCache;
    
    @Resource
    private ProjectConfig projectConfig;
    
    /**
     * 登录验证
     */
    public String login(LoginBody loginBody) {
        String account = loginBody.getAccount();
        String password = loginBody.getPassword();
        DeviceEnum device = loginBody.getDevice() == null ? DeviceEnum.PC端 : loginBody.getDevice();
        
        // 记录登录信息
        RecordLogininforVO recordLogininforVO = RecordLogininforVO.builder()
            .account(account)
            .device(device)
            .status(Constants.LOGIN_FAIL)
            .build();
        
        // 是否需要验证码
        if (projectConfig.isCaptchaEnabled()) {
            verifyCaptchaCode(loginBody, recordLogininforVO);
        }
    
        SysUser user = userService.getByAccount(account);
        // 如果未查询到用户
        if (user == null) {
            recordLogininforVO.setMessage(MessageUtils.message("user.not.exist"));
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(recordLogininforVO));
            throw new UserNotExistException();
        }
        // 如果用户已被停用
        if (StatusEnum.停用.equals(user.getStatus())) {
            recordLogininforVO.setMessage(MessageUtils.message("user.blocked"));
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(recordLogininforVO));
            throw new UserException("user.blocked", null);
        }
    
        recordLogininforVO.setUserId(user.getId());
        
        // 如果密码不匹配
        if (!Md5Utils.verifyPassword(password, user.getPassword())) {
            recordLogininforVO.setMessage(MessageUtils.message("user.password.not.match"));
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(recordLogininforVO));
            throw new UserPasswordNotMatchException();
        }
    
        // 登录成功
        recordLogininforVO.setStatus(Constants.LOGIN_SUCCESS);
        recordLogininforVO.setMessage(MessageUtils.message("user.login.success"));
        AsyncManager.me().execute(AsyncFactory.recordLogininfor(recordLogininforVO));
        
        // 构建登录用户，并获取权限列表
        LoginUser loginUser = new LoginUser(user, permissionService.getMenuPermission(user));
        loginUser.setDevice(device);
        loginUser.setAccount(account);
        
        // 生成用户唯一标识
        String userKey = tokenService.genUserKey(loginUser);
        loginUser.setUserKey(userKey);
        // 是否唯一登录
        if (projectConfig.isUniqueLogin()) {
            handleUniqueLogin(loginUser);
        }
        
        // 生成token
        return tokenService.createToken(loginUser);
    }
    
    /**
     * 校验验证码
     * @param loginBody
     * @param recordLogininforVO
     */
    private void verifyCaptchaCode(LoginBody loginBody, RecordLogininforVO recordLogininforVO) {
        String uuid = loginBody.getUuid();
        String code = loginBody.getCode();
    
        String verifyKey = Constants.REDIS_CAPTCHA_CODE_KEY + uuid;
        String captcha = redisCache.getCacheObject(verifyKey);
        redisCache.deleteObject(verifyKey);
        // 验证码已过期
        if (captcha == null) {
            recordLogininforVO.setMessage(MessageUtils.message("user.jcaptcha.expire"));
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(recordLogininforVO));
            throw new CaptchaExpireException();
        }
        // 验证码不匹配
        if (!code.equalsIgnoreCase(captcha)) {
            recordLogininforVO.setMessage(MessageUtils.message("user.jcaptcha.error"));
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(recordLogininforVO));
            throw new CaptchaException();
        }
    }
    
    /**
     * 唯一登录处理
     * @param loginUser
     */
    private void handleUniqueLogin(LoginUser loginUser) {
        Collection<String> keys = redisCache.keys(Constants.REDIS_LOGIN_KEY + loginUser.getUserKey() + "," + "*");
        for (String key : keys) {
            LoginUser oldUser = redisCache.getCacheObject(key);
            // 把其他用户的踢出标识设为true
            // 之所以不直接将其他用户缓存删除，是为了提醒其他用户账号可能被盗
            oldUser.setKickout(true);
            redisCache.setCacheObject(key, oldUser, 8, TimeUnit.HOURS);
        }
    }
    
}
