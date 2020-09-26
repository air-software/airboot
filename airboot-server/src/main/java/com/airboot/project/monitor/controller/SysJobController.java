package com.airboot.project.monitor.controller;

import com.airboot.common.component.BaseController;
import com.airboot.common.core.aspectj.lang.annotation.Log;
import com.airboot.common.core.exception.job.TaskException;
import com.airboot.common.core.utils.poi.ExcelUtil;
import com.airboot.common.model.vo.AjaxResult;
import com.airboot.project.monitor.model.entity.SysJob;
import com.airboot.project.monitor.model.enums.BusinessTypeEnum;
import com.airboot.project.monitor.model.vo.SearchSysJobVO;
import com.airboot.project.monitor.service.ISysJobService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.quartz.SchedulerException;
import com.airboot.common.security.annotation.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 调度任务信息操作处理
 *
 * @author airboot
 */
@RestController
@RequestMapping("/monitor/job")
public class SysJobController extends BaseController {
    
    @Resource
    private ISysJobService jobService;
    
    /**
     * 查询定时任务列表
     */
    @PreAuthorize("monitor:job:page")
    @GetMapping("/page")
    public AjaxResult page(SearchSysJobVO search) {
        IPage<SysJob> page = jobService.getPage(search);
        return AjaxResult.success(page);
    }
    
    /**
     * 导出定时任务列表
     */
    @PreAuthorize("monitor:job:export")
    @Log(title = "定时任务", businessType = BusinessTypeEnum.导出)
    @GetMapping("/export")
    public AjaxResult export(SearchSysJobVO search) {
        List<SysJob> list = jobService.getList(search);
        ExcelUtil<SysJob> util = new ExcelUtil<>(SysJob.class);
        return util.exportExcel(list, "定时任务");
    }
    
    /**
     * 获取定时任务详细信息
     */
    @PreAuthorize("monitor:job:query")
    @GetMapping(value = "/{jobId}")
    public AjaxResult getInfo(@PathVariable("jobId") Long jobId) {
        return AjaxResult.success(jobService.getById(jobId));
    }
    
    /**
     * 新增定时任务
     */
    @PreAuthorize("monitor:job:add")
    @Log(title = "定时任务", businessType = BusinessTypeEnum.新增)
    @PostMapping
    public AjaxResult add(@RequestBody SysJob sysJob) throws SchedulerException, TaskException {
        return toAjax(jobService.saveOrUpdate(sysJob));
    }
    
    /**
     * 修改定时任务
     */
    @PreAuthorize("monitor:job:edit")
    @Log(title = "定时任务", businessType = BusinessTypeEnum.修改)
    @PutMapping
    public AjaxResult edit(@RequestBody SysJob sysJob) throws SchedulerException, TaskException {
        return toAjax(jobService.saveOrUpdate(sysJob));
    }
    
    /**
     * 定时任务状态修改
     */
    @PreAuthorize("monitor:job:changeStatus")
    @Log(title = "定时任务", businessType = BusinessTypeEnum.修改)
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestBody SysJob job) throws SchedulerException {
        SysJob newJob = jobService.getById(job.getId());
        newJob.setStatus(job.getStatus());
        return toAjax(jobService.changeStatus(newJob));
    }
    
    /**
     * 定时任务立即执行一次
     */
    @PreAuthorize("monitor:job:changeStatus")
    @Log(title = "定时任务", businessType = BusinessTypeEnum.修改)
    @PutMapping("/run")
    public AjaxResult run(@RequestBody SysJob job) throws SchedulerException {
        jobService.run(job);
        return AjaxResult.success();
    }
    
    /**
     * 删除定时任务
     */
    @PreAuthorize("monitor:job:remove")
    @Log(title = "定时任务", businessType = BusinessTypeEnum.删除)
    @DeleteMapping("/{jobIds}")
    public AjaxResult remove(@PathVariable Long[] jobIds) throws SchedulerException, TaskException {
        jobService.deleteByIds(jobIds);
        return AjaxResult.success();
    }
}
