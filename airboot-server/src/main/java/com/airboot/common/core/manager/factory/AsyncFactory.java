package com.airboot.common.core.manager.factory;

import com.airboot.common.core.constant.Constants;
import com.airboot.common.core.utils.LogUtils;
import com.airboot.common.core.utils.ServletUtils;
import com.airboot.common.core.utils.ip.AddressUtils;
import com.airboot.common.core.utils.ip.IpUtils;
import com.airboot.common.core.utils.spring.SpringUtils;
import com.airboot.common.model.enums.SuccessEnum;
import com.airboot.common.security.RecordLogininforVO;
import com.airboot.project.monitor.model.entity.SysLogininfor;
import com.airboot.project.monitor.model.entity.SysOperLog;
import com.airboot.project.monitor.service.ISysLogininforService;
import com.airboot.project.monitor.service.ISysOperLogService;
import eu.bitwalker.useragentutils.UserAgent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import java.util.TimerTask;

/**
 * 异步工厂（产生任务用）
 *
 * @author airboot
 */
public class AsyncFactory {
    
    private static final Logger sys_user_logger = LoggerFactory.getLogger("sys-user");
    
    /**
     * 记录登录信息
     *
     * @param recordLogininforVO 记录信息VO
     * @param args     列表
     * @return 任务task
     */
    public static TimerTask recordLogininfor(RecordLogininforVO recordLogininforVO,
                                             final Object... args) {
        final UserAgent userAgent = UserAgent.parseUserAgentString(ServletUtils.getRequest().getHeader("User-Agent"));
        final String ip = IpUtils.getIpAddr(ServletUtils.getRequest());
        return new TimerTask() {
            @Override
            public void run() {
                String address = AddressUtils.getRealAddressByIP(ip);
                StringBuilder s = new StringBuilder();
                s.append(LogUtils.getBlock(ip));
                s.append(address);
                s.append(LogUtils.getBlock(recordLogininforVO.getUserId()));
                s.append(LogUtils.getBlock(recordLogininforVO.getAccount()));
                s.append(LogUtils.getBlock(recordLogininforVO.getStatus()));
                s.append(LogUtils.getBlock(recordLogininforVO.getMessage()));
                // 打印信息到日志
                sys_user_logger.info(s.toString(), args);
                // 获取客户端操作系统
                String os = userAgent.getOperatingSystem().getName();
                // 获取客户端浏览器
                String browser = userAgent.getBrowser().getName();
                // 封装对象
                SysLogininfor logininfor = new SysLogininfor();
                logininfor.setUserId(recordLogininforVO.getUserId());
                logininfor.setAccount(recordLogininforVO.getAccount());
                logininfor.setDevice(recordLogininforVO.getDevice());
                logininfor.setIpaddr(ip);
                logininfor.setLoginLocation(address);
                logininfor.setLoginTime(new Date());
                logininfor.setBrowser(browser);
                logininfor.setOs(os);
                logininfor.setMsg(recordLogininforVO.getMessage());
                // 日志状态
                if (Constants.LOGIN_SUCCESS.equals(recordLogininforVO.getStatus()) || Constants.LOGOUT.equals(recordLogininforVO.getStatus())) {
                    logininfor.setStatus(SuccessEnum.成功);
                } else if (Constants.LOGIN_FAIL.equals(recordLogininforVO.getStatus())) {
                    logininfor.setStatus(SuccessEnum.失败);
                }
                // 插入数据
                SpringUtils.getBean(ISysLogininforService.class).save(logininfor);
            }
        };
    }
    
    /**
     * 操作日志记录
     *
     * @param operLog 操作日志信息
     * @return 任务task
     */
    public static TimerTask recordOper(final SysOperLog operLog) {
        return new TimerTask() {
            @Override
            public void run() {
                // 远程查询操作地点
                operLog.setOperLocation(AddressUtils.getRealAddressByIP(operLog.getOperIp()));
                SpringUtils.getBean(ISysOperLogService.class).save(operLog);
            }
        };
    }
}
