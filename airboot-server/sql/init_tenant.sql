-- ----------------------------
-- 关闭外键约束，避免被Quartz表中的外键影响启动。
-- 注意：如果重启了MySQL服务，要先用 select @@foreign_key_checks; 检查外键约束的值，如果值为1表示又被开启了，需要再运行下面这条SQL语句关闭约束。
-- ----------------------------
set global foreign_key_checks = 0;
set foreign_key_checks = 0;

-- ----------------------------
-- 如果准备做多租户应用，就用这个SQL脚本来新建数据库
-- 0、租户表
-- ----------------------------
drop table if exists sys_tenant;
create table sys_tenant (
  id                bigint(20)      not null auto_increment    comment '租户id',
  tenant_name       varchar(100)    not null                   comment '租户名称',
  person_name       varchar(20)     default ''               comment '负责人姓名',
  mobile            varchar(20)     default ''               comment '负责人手机号码',
  email             varchar(50)     default ''               comment '负责人邮箱',
  status            tinyint(4)      default 1                  comment '租户状态（0=停用,1=正常）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                  comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                  comment '乐观锁数据版本',
  primary key (id)
) engine=innodb auto_increment=100 comment = '租户表';

insert into sys_tenant values(1, '管理平台', 'airoland', '18812345678', '123456@qq.com', 1, 'admin', '2020-09-02 11-33-00', 'admin', '2020-09-02 11-33-00', '', 0, 0);

-- ----------------------------
-- 1、部门表
-- ----------------------------
drop table if exists sys_dept;
create table sys_dept (
  id                bigint(20)      not null auto_increment    comment '部门id',
  tenant_id         bigint(20)      not null                   comment '租户id',
  parent_id         bigint(20)      default 0                  comment '父部门id',
  ancestors         varchar(50)     default ''                 comment '祖级列表',
  dept_name         varchar(30)     default ''                 comment '部门名称',
  order_num         int(4)          default 0                  comment '显示顺序',
  leader            varchar(20)     default ''               comment '负责人',
  mobile             varchar(20)     default ''               comment '负责人手机号码',
  email             varchar(50)     default ''               comment '邮箱',
  status            tinyint(4)      default 1                  comment '部门状态（0=停用,1=正常）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                  comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                  comment '乐观锁数据版本',
  primary key (id)
) engine=innodb auto_increment=200 comment = '部门表';

-- ----------------------------
-- 初始化-部门表数据
-- ----------------------------
insert into sys_dept values(100, 1,  0,   '0',          '集团总部',   0, 'airoland', '15888888888', '123456@qq.com', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_dept values(101, 1,  100, '0,100',      '北京分公司', 1, 'airoland', '15888888888', '123456@qq.com', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_dept values(102, 1,  100, '0,100',      '长沙分公司', 2, 'airoland', '15888888888', '123456@qq.com', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_dept values(103, 1,  101, '0,100,101',  '研发部门',   1, 'airoland', '15888888888', '123456@qq.com', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_dept values(104, 1,  101, '0,100,101',  '市场部门',   2, 'airoland', '15888888888', '123456@qq.com', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_dept values(105, 1,  101, '0,100,101',  '测试部门',   3, 'airoland', '15888888888', '123456@qq.com', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_dept values(106, 1,  101, '0,100,101',  '财务部门',   4, 'airoland', '15888888888', '123456@qq.com', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_dept values(107, 1,  101, '0,100,101',  '运维部门',   5, 'airoland', '15888888888', '123456@qq.com', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_dept values(108, 1,  102, '0,100,102',  '市场部门',   1, 'airoland', '15888888888', '123456@qq.com', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_dept values(109, 1,  102, '0,100,102',  '财务部门',   2, 'airoland', '15888888888', '123456@qq.com', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);


-- ----------------------------
-- 2、用户信息表
-- ----------------------------
drop table if exists sys_user;
create table sys_user (
  id           bigint(20)      not null auto_increment    comment '用户ID',
  tenant_id         bigint(20)      not null                   comment '租户id',
  dept_id           bigint(20)      not null               comment '部门ID',
  username         varchar(50)     not null                   comment '用户名',
  nickname         varchar(50)     not null                   comment '用户昵称',
  email             varchar(100)     default ''                 comment '用户邮箱',
  mobile            varchar(20)     default ''                 comment '手机号码',
  gender            tinyint(4)       default 0                comment '用户性别（0=保密,1=男,2=女）',
  avatar            varchar(100)    default ''                 comment '头像地址',
  password          varchar(100)    default ''                 comment '密码',
  person_name       varchar(50)     default ''                   comment '用户姓名',
  id_card           varchar(50)     default ''                   comment '证件号码',
  card_type         tinyint(4)      default 1                   comment '证件类型',
  status            tinyint(4)       default 1                comment '帐号状态（0=停用,1=正常）',
  login_ip          varchar(50)     default ''                 comment '最后登录IP',
  login_location    varchar(190)    default ''                 comment '最后登录地点',
  login_date        datetime                                   comment '最后登录时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id),
  KEY `idx_mobile` (`mobile`)
) engine=innodb auto_increment=100 comment = '用户信息表';

-- ----------------------------
-- 初始化-用户信息表数据
-- ----------------------------
insert into sys_user values(1, 1,  103, 'admin', 'airoland', '123456@qq.com', '15888888888', '1', '', '41ae2142375ca87970787369850d8790330734b21cb8ee4e', '', '', 1, 1, '127.0.0.1', '内网地址', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '管理员', 0, 0);
insert into sys_user values(2, 1,  105, 'airboot', 'airoland', '456789@qq.com',  '15666666666', '1', '', '41ae2142375ca87970787369850d8790330734b21cb8ee4e', '', '', 1, 1, '127.0.0.1', '内网地址', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '测试员', 0, 0);


-- ----------------------------
-- 3、岗位信息表
-- ----------------------------
drop table if exists sys_post;
create table sys_post (
  id       bigint(20)      not null auto_increment    comment '岗位ID',
  tenant_id         bigint(20)      not null                   comment '租户id',
  post_code     varchar(64)     not null                   comment '岗位编码',
  post_name     varchar(50)     not null                   comment '岗位名称',
  post_sort     int(4)          not null                   comment '显示顺序',
  status        tinyint(4)       not null default 1      comment '状态（0=停用,1=正常）',
  create_by     varchar(64)     default ''                 comment '创建者',
  create_time   datetime                                    comment '创建时间',
  update_by     varchar(64)     default ''			             comment '更新者',
  update_time   datetime                                    comment '更新时间',
  remark        varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id)
) engine=innodb comment = '岗位信息表';

-- ----------------------------
-- 初始化-岗位信息表数据
-- ----------------------------
insert into sys_post values(1, 1, 'ceo',  '董事长',    1, 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_post values(2, 1, 'se',   '项目经理',  2, 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_post values(3, 1, 'hr',   '人力资源',  3, 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_post values(4, 1, 'user', '普通员工',  4, 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);


-- ----------------------------
-- 4、角色信息表
-- ----------------------------
drop table if exists sys_role;
create table sys_role (
  id           bigint(20)      not null auto_increment    comment '角色ID',
  tenant_id         bigint(20)      not null                   comment '租户id',
  role_name         varchar(30)     not null                   comment '角色名称',
  role_key          varchar(100)    not null                   comment '角色权限字符串',
  role_sort         int(4)          not null                   comment '显示顺序',
  data_scope        tinyint(4)         default 1                comment '数据范围（1=全部数据权限,2=自定义数据权限,3=本部门数据权限,4=本部门及以下数据权限,5=仅本人数据权限）',
  status            tinyint(4)         not null default 1        comment '角色状态（0=停用,1=正常）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id)
) engine=innodb auto_increment=100 comment = '角色信息表';

-- ----------------------------
-- 初始化-角色信息表数据
-- ----------------------------
insert into sys_role values('1', 1, '管理员',   'admin',  1, 1, 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '管理员', 0, 0);
insert into sys_role values('2', 1, '普通角色', 'common', 2, 2, 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '普通角色', 0, 0);


-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
drop table if exists sys_menu;
create table sys_menu (
  id           bigint(20)      not null auto_increment    comment '菜单ID',
  menu_name         varchar(50)     not null                   comment '菜单名称',
  parent_id         bigint(20)      default 0                  comment '父菜单ID',
  order_num         int(4)          default 0                  comment '显示顺序',
  path              varchar(100)    default ''                 comment '路由地址',
  component         varchar(190)    default ''               comment '组件路径',
  iframe          bit(1)          default 0                  comment '是否为外链（false=否,true=是）',
  menu_type         tinyint(4)         default 0                 comment '菜单类型（0=目录,1=菜单,2=按钮）',
  hidden           bit(1)         default 0                  comment '菜单状态（false=显示,true=隐藏）',
  status            tinyint(4)         default 1                  comment '菜单状态（0=停用,1=正常）',
  perms             varchar(100)    default ''               comment '权限标识',
  icon              varchar(100)    default '#'                comment '菜单图标',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''                 comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id)
) engine=innodb auto_increment=2000 comment = '菜单权限表';

-- ----------------------------
-- 初始化-菜单信息表数据
-- ----------------------------
-- 一级菜单
insert into sys_menu values('1', '系统管理', '0', '1', 'system',           '',   0, 0, 0, 1, '', 'system',   'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '系统管理目录', 0, 0);
insert into sys_menu values('2', '系统监控', '0', '2', 'monitor',          '',   0, 0, 0, 1, '', 'monitor',  'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '系统监控目录', 0, 0);
insert into sys_menu values('3', '系统工具', '0', '3', 'tool',             '',   0, 0, 0, 1, '', 'tool',     'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '系统工具目录', 0, 0);
insert into sys_menu values('4', 'Gitee', '0', '4', 'https://gitee.com/air-soft/airboot', '', 1, 0, 0, 1, '', 'guide',    'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', 'Airboot Gitee地址', 0, 0);
-- 二级菜单
insert into sys_menu values('100',  '用户管理', '1',   '1', 'user',       'system/user/index',        0, 1, 0, 1, 'system:user:page',        'user',          'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '用户管理菜单', 0, 0);
insert into sys_menu values('101',  '角色管理', '1',   '2', 'role',       'system/role/index',        0, 1, 0, 1, 'system:role:page',        'peoples',       'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '角色管理菜单', 0, 0);
insert into sys_menu values('102',  '菜单管理', '1',   '3', 'menu',       'system/menu/index',        0, 1, 0, 1, 'system:menu:list',        'tree-table',    'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '菜单管理菜单', 0, 0);
insert into sys_menu values('103',  '部门管理', '1',   '4', 'dept',       'system/dept/index',        0, 1, 0, 1, 'system:dept:list',        'tree',          'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '部门管理菜单', 0, 0);
insert into sys_menu values('104',  '岗位管理', '1',   '5', 'post',       'system/post/index',        0, 1, 0, 1, 'system:post:page',        'post',          'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '岗位管理菜单', 0, 0);
insert into sys_menu values('106',  '参数设置', '1',   '7', 'config',     'system/config/index',      0, 1, 0, 1, 'system:config:page',      'edit',          'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '参数设置菜单', 0, 0);
insert into sys_menu values('107',  '通知公告', '1',   '8', 'notice',     'system/notice/index',      0, 1, 0, 1, 'system:notice:page',      'message',       'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '通知公告菜单', 0, 0);
insert into sys_menu values('108',  '日志管理', '1',   '9', 'log',        'system/log/index',         0, 0, 0, 1, '',                        'log',           'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '日志管理菜单', 0, 0);
insert into sys_menu values('109',  '在线用户', '2',   '1', 'online',     'monitor/online/index',     0, 1, 0, 1, 'monitor:online:page',     'online',        'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '在线用户菜单', 0, 0);
insert into sys_menu values('110',  '定时任务', '2',   '2', 'job',        'monitor/job/index',        0, 1, 0, 1, 'monitor:job:page',        'job',           'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '定时任务菜单', 0, 0);
insert into sys_menu values('111',  '数据监控', '2',   '3', 'druid',      'monitor/druid/index',      0, 1, 0, 1, 'monitor:druid:list',      'druid',         'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '数据监控菜单', 0, 0);
insert into sys_menu values('112',  '服务监控', '2',   '4', 'server',     'monitor/server/index',     0, 1, 0, 1, 'monitor:server:list',     'server',        'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '服务监控菜单', 0, 0);
insert into sys_menu values('113',  '表单构建', '3',   '1', 'build',      'tool/build/index',         0, 1, 0, 1, 'tool:build:list',         'build',         'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '表单构建菜单', 0, 0);
insert into sys_menu values('114',  '代码生成', '3',   '2', 'gen',        'tool/gen/index',           0, 1, 0, 1, 'tool:gen:page',           'code',          'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '代码生成菜单', 0, 0);
insert into sys_menu values('115',  '系统接口', '3',   '3', 'swagger',    'tool/swagger/index',       0, 1, 0, 1, 'tool:swagger:list',       'swagger',       'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '系统接口菜单', 0, 0);
-- 三级菜单
insert into sys_menu values('500',  '操作日志', '108', '1', 'operlog',    'monitor/operlog/index',    0, 1, 0, 1, 'monitor:operlog:page',    'form',          'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '操作日志菜单', 0, 0);
insert into sys_menu values('501',  '登录日志', '108', '2', 'logininfor', 'monitor/logininfor/index', 0, 1, 0, 1, 'monitor:logininfor:page', 'logininfor',    'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '登录日志菜单', 0, 0);
-- 用户管理按钮
insert into sys_menu values('1001', '用户查询', '100', '1',  '', '', 0, 2, 0, 1, 'system:user:query',          '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1002', '用户新增', '100', '2',  '', '', 0, 2, 0, 1, 'system:user:add',            '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1003', '用户修改', '100', '3',  '', '', 0, 2, 0, 1, 'system:user:edit',           '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1004', '用户删除', '100', '4',  '', '', 0, 2, 0, 1, 'system:user:remove',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1005', '用户导出', '100', '5',  '', '', 0, 2, 0, 1, 'system:user:export',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1006', '用户导入', '100', '6',  '', '', 0, 2, 0, 1, 'system:user:import',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1007', '重置密码', '100', '7',  '', '', 0, 2, 0, 1, 'system:user:resetPwd',       '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 角色管理按钮
insert into sys_menu values('1008', '角色查询', '101', '1',  '', '', 0, 2, 0, 1, 'system:role:query',          '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1009', '角色新增', '101', '2',  '', '', 0, 2, 0, 1, 'system:role:add',            '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1010', '角色修改', '101', '3',  '', '', 0, 2, 0, 1, 'system:role:edit',           '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1011', '角色删除', '101', '4',  '', '', 0, 2, 0, 1, 'system:role:remove',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1012', '角色导出', '101', '5',  '', '', 0, 2, 0, 1, 'system:role:export',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 菜单管理按钮
insert into sys_menu values('1013', '菜单查询', '102', '1',  '', '', 0, 2, 0, 1, 'system:menu:query',          '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1014', '菜单新增', '102', '2',  '', '', 0, 2, 0, 1, 'system:menu:add',            '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1015', '菜单修改', '102', '3',  '', '', 0, 2, 0, 1, 'system:menu:edit',           '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1016', '菜单删除', '102', '4',  '', '', 0, 2, 0, 1, 'system:menu:remove',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 部门管理按钮
insert into sys_menu values('1017', '部门查询', '103', '1',  '', '', 0, 2, 0, 1, 'system:dept:query',          '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1018', '部门新增', '103', '2',  '', '', 0, 2, 0, 1, 'system:dept:add',            '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1019', '部门修改', '103', '3',  '', '', 0, 2, 0, 1, 'system:dept:edit',           '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1020', '部门删除', '103', '4',  '', '', 0, 2, 0, 1, 'system:dept:remove',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 岗位管理按钮
insert into sys_menu values('1021', '岗位查询', '104', '1',  '', '', 0, 2, 0, 1, 'system:post:query',          '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1022', '岗位新增', '104', '2',  '', '', 0, 2, 0, 1, 'system:post:add',            '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1023', '岗位修改', '104', '3',  '', '', 0, 2, 0, 1, 'system:post:edit',           '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1024', '岗位删除', '104', '4',  '', '', 0, 2, 0, 1, 'system:post:remove',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1025', '岗位导出', '104', '5',  '', '', 0, 2, 0, 1, 'system:post:export',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 参数设置按钮
insert into sys_menu values('1031', '参数查询', '106', '1', '#', '', 0, 2, 0, 1, 'system:config:query',        '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1032', '参数新增', '106', '2', '#', '', 0, 2, 0, 1, 'system:config:add',          '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1033', '参数修改', '106', '3', '#', '', 0, 2, 0, 1, 'system:config:edit',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1034', '参数删除', '106', '4', '#', '', 0, 2, 0, 1, 'system:config:remove',       '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1035', '参数导出', '106', '5', '#', '', 0, 2, 0, 1, 'system:config:export',       '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 通知公告按钮
insert into sys_menu values('1036', '公告查询', '107', '1', '#', '', 0, 2, 0, 1, 'system:notice:query',        '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1037', '公告新增', '107', '2', '#', '', 0, 2, 0, 1, 'system:notice:add',          '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1038', '公告修改', '107', '3', '#', '', 0, 2, 0, 1, 'system:notice:edit',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1039', '公告删除', '107', '4', '#', '', 0, 2, 0, 1, 'system:notice:remove',       '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 操作日志按钮
insert into sys_menu values('1040', '操作查询', '500', '1', '#', '', 0, 2, 0, 1, 'monitor:operlog:query',      '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1041', '操作删除', '500', '2', '#', '', 0, 2, 0, 1, 'monitor:operlog:remove',     '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1042', '日志导出', '500', '4', '#', '', 0, 2, 0, 1, 'monitor:operlog:export',     '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 登录日志按钮
insert into sys_menu values('1043', '登录查询', '501', '1', '#', '', 0, 2, 0, 1, 'monitor:logininfor:query',   '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1044', '登录删除', '501', '2', '#', '', 0, 2, 0, 1, 'monitor:logininfor:remove',  '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1045', '日志导出', '501', '3', '#', '', 0, 2, 0, 1, 'monitor:logininfor:export',  '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 在线用户按钮
insert into sys_menu values('1046', '在线查询', '109', '1', '#', '', 0, 2, 0, 1, 'monitor:online:query',       '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1047', '批量强退', '109', '2', '#', '', 0, 2, 0, 1, 'monitor:online:batchLogout', '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1048', '单条强退', '109', '3', '#', '', 0, 2, 0, 1, 'monitor:online:forceLogout', '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 定时任务按钮
insert into sys_menu values('1049', '任务查询', '110', '1', '#', '', 0, 2, 0, 1, 'monitor:job:query',          '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1050', '任务新增', '110', '2', '#', '', 0, 2, 0, 1, 'monitor:job:add',            '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1051', '任务修改', '110', '3', '#', '', 0, 2, 0, 1, 'monitor:job:edit',           '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1052', '任务删除', '110', '4', '#', '', 0, 2, 0, 1, 'monitor:job:remove',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1053', '状态修改', '110', '5', '#', '', 0, 2, 0, 1, 'monitor:job:changeStatus',   '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1054', '任务导出', '110', '7', '#', '', 0, 2, 0, 1, 'monitor:job:export',         '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
-- 代码生成按钮
insert into sys_menu values('1055', '生成查询', '114', '1', '#', '', 0, 2, 0, 1, 'tool:gen:query',             '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1056', '生成修改', '114', '2', '#', '', 0, 2, 0, 1, 'tool:gen:edit',              '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1057', '生成删除', '114', '3', '#', '', 0, 2, 0, 1, 'tool:gen:remove',            '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1058', '导入代码', '114', '2', '#', '', 0, 2, 0, 1, 'tool:gen:import',            '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1059', '预览代码', '114', '4', '#', '', 0, 2, 0, 1, 'tool:gen:preview',           '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_menu values('1060', '生成代码', '114', '5', '#', '', 0, 2, 0, 1, 'tool:gen:code',              '#', 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);


-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
drop table if exists sys_user_role;
create table sys_user_role (
  user_id   bigint(20) not null comment '用户ID',
  role_id   bigint(20) not null comment '角色ID',
  primary key(user_id, role_id)
) engine=innodb comment = '用户和角色关联表';

-- ----------------------------
-- 初始化-用户和角色关联表数据
-- ----------------------------
insert into sys_user_role values ('1', '1');
insert into sys_user_role values ('2', '2');


-- ----------------------------
-- 7、角色和菜单关联表  角色1-N菜单
-- ----------------------------
drop table if exists sys_role_menu;
create table sys_role_menu (
  role_id   bigint(20) not null comment '角色ID',
  menu_id   bigint(20) not null comment '菜单ID',
  primary key(role_id, menu_id)
) engine=innodb comment = '角色和菜单关联表';

-- ----------------------------
-- 初始化-角色和菜单关联表数据
-- ----------------------------
insert into sys_role_menu values ('2', '1');
insert into sys_role_menu values ('2', '2');
insert into sys_role_menu values ('2', '3');
insert into sys_role_menu values ('2', '4');
insert into sys_role_menu values ('2', '100');
insert into sys_role_menu values ('2', '101');
insert into sys_role_menu values ('2', '102');
insert into sys_role_menu values ('2', '103');
insert into sys_role_menu values ('2', '104');
insert into sys_role_menu values ('2', '105');
insert into sys_role_menu values ('2', '106');
insert into sys_role_menu values ('2', '107');
insert into sys_role_menu values ('2', '108');
insert into sys_role_menu values ('2', '109');
insert into sys_role_menu values ('2', '110');
insert into sys_role_menu values ('2', '111');
insert into sys_role_menu values ('2', '112');
insert into sys_role_menu values ('2', '113');
insert into sys_role_menu values ('2', '114');
insert into sys_role_menu values ('2', '115');
insert into sys_role_menu values ('2', '500');
insert into sys_role_menu values ('2', '501');
insert into sys_role_menu values ('2', '1000');
insert into sys_role_menu values ('2', '1001');
insert into sys_role_menu values ('2', '1002');
insert into sys_role_menu values ('2', '1003');
insert into sys_role_menu values ('2', '1004');
insert into sys_role_menu values ('2', '1005');
insert into sys_role_menu values ('2', '1006');
insert into sys_role_menu values ('2', '1007');
insert into sys_role_menu values ('2', '1008');
insert into sys_role_menu values ('2', '1009');
insert into sys_role_menu values ('2', '1010');
insert into sys_role_menu values ('2', '1011');
insert into sys_role_menu values ('2', '1012');
insert into sys_role_menu values ('2', '1013');
insert into sys_role_menu values ('2', '1014');
insert into sys_role_menu values ('2', '1015');
insert into sys_role_menu values ('2', '1016');
insert into sys_role_menu values ('2', '1017');
insert into sys_role_menu values ('2', '1018');
insert into sys_role_menu values ('2', '1019');
insert into sys_role_menu values ('2', '1020');
insert into sys_role_menu values ('2', '1021');
insert into sys_role_menu values ('2', '1022');
insert into sys_role_menu values ('2', '1023');
insert into sys_role_menu values ('2', '1024');
insert into sys_role_menu values ('2', '1025');
insert into sys_role_menu values ('2', '1026');
insert into sys_role_menu values ('2', '1027');
insert into sys_role_menu values ('2', '1028');
insert into sys_role_menu values ('2', '1029');
insert into sys_role_menu values ('2', '1030');
insert into sys_role_menu values ('2', '1031');
insert into sys_role_menu values ('2', '1032');
insert into sys_role_menu values ('2', '1033');
insert into sys_role_menu values ('2', '1034');
insert into sys_role_menu values ('2', '1035');
insert into sys_role_menu values ('2', '1036');
insert into sys_role_menu values ('2', '1037');
insert into sys_role_menu values ('2', '1038');
insert into sys_role_menu values ('2', '1039');
insert into sys_role_menu values ('2', '1040');
insert into sys_role_menu values ('2', '1041');
insert into sys_role_menu values ('2', '1042');
insert into sys_role_menu values ('2', '1043');
insert into sys_role_menu values ('2', '1044');
insert into sys_role_menu values ('2', '1045');
insert into sys_role_menu values ('2', '1046');
insert into sys_role_menu values ('2', '1047');
insert into sys_role_menu values ('2', '1048');
insert into sys_role_menu values ('2', '1049');
insert into sys_role_menu values ('2', '1050');
insert into sys_role_menu values ('2', '1051');
insert into sys_role_menu values ('2', '1052');
insert into sys_role_menu values ('2', '1053');
insert into sys_role_menu values ('2', '1054');
insert into sys_role_menu values ('2', '1055');
insert into sys_role_menu values ('2', '1056');
insert into sys_role_menu values ('2', '1057');
insert into sys_role_menu values ('2', '1058');
insert into sys_role_menu values ('2', '1059');
insert into sys_role_menu values ('2', '1060');

-- ----------------------------
-- 8、角色和部门关联表  角色1-N部门
-- ----------------------------
drop table if exists sys_role_dept;
create table sys_role_dept (
  role_id   bigint(20) not null comment '角色ID',
  dept_id   bigint(20) not null comment '部门ID',
  primary key(role_id, dept_id)
) engine=innodb comment = '角色和部门关联表';

-- ----------------------------
-- 初始化-角色和部门关联表数据
-- ----------------------------
insert into sys_role_dept values ('2', '105');


-- ----------------------------
-- 9、用户与岗位关联表  用户1-N岗位
-- ----------------------------
drop table if exists sys_user_post;
create table sys_user_post
(
  user_id   bigint(20) not null comment '用户ID',
  post_id   bigint(20) not null comment '岗位ID',
  primary key (user_id, post_id)
) engine=innodb comment = '用户与岗位关联表';

-- ----------------------------
-- 初始化-用户与岗位关联表数据
-- ----------------------------
insert into sys_user_post values ('1', '1');
insert into sys_user_post values ('2', '2');


-- ----------------------------
-- 10、操作日志记录
-- ----------------------------
drop table if exists sys_oper_log;
create table sys_oper_log (
  id           bigint(20)      not null auto_increment    comment '日志主键',
  tenant_id         bigint(20)      not null                   comment '租户id',
  title             varchar(50)     default ''                 comment '模块标题',
  business_type     tinyint(4)          default 0                  comment '业务类型（0=其它,1=新增,2=修改,3=删除,4=授权,5=导出,6=导入,7=强退,8=生成代码,9=清空数据）',
  method            varchar(100)    default ''                 comment '方法名称',
  request_method    varchar(10)     default ''                 comment '请求方式',
  device            tinyint(4)     default 10                comment '操作设备（10=PC端,20=手机APP,30=微信小程序）',
  oper_name         varchar(190)     default ''                 comment '操作人员账号',
  oper_user_id      bigint(20)      default 0                 comment '操作人员ID',
  dept_name         varchar(50)     default ''                 comment '部门名称',
  oper_url          varchar(500)    default ''                 comment '请求URL',
  oper_ip           varchar(50)     default ''                 comment '主机地址',
  oper_location     varchar(190)    default ''                 comment '操作地点',
  oper_param        varchar(2000)   default ''                 comment '请求参数',
  json_result       varchar(2000)   default ''                 comment '返回参数',
  status            tinyint(4)          default 1              comment '操作状态（0=失败,1=成功）',
  error_msg         varchar(2000)   default ''                 comment '错误消息',
  oper_time         datetime                                   comment '操作时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id)
) engine=innodb auto_increment=100 comment = '操作日志记录';


-- ----------------------------
-- 11、参数配置表
-- ----------------------------
drop table if exists sys_config;
create table sys_config (
  id         bigint(20)          not null auto_increment    comment '参数主键',
  tenant_id         bigint(20)      not null                   comment '租户id',
  config_name       varchar(100)    default ''                 comment '参数名称',
  config_key        varchar(100)    default ''                 comment '参数键名',
  config_value      varchar(500)    default ''                 comment '参数键值',
  built_in       bit(1)         default 0                comment '是否系统内置（false=否,true=是）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id)
) engine=innodb auto_increment=100 comment = '参数配置表';

insert into sys_config values(1, 1, '主框架页-默认皮肤样式名称', 'sys.index.skinName',     'skin-blue',     1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow', 0, 0);
insert into sys_config values(2, 1, '用户管理-账号初始密码',     'sys.user.initPassword',  '123456',        1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '初始化密码 123456', 0, 0);
insert into sys_config values(3, 1, '主框架页-侧边栏主题',       'sys.index.sideTheme',    'theme-dark',    1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '深色主题theme-dark，浅色主题theme-light', 0, 0);


-- ----------------------------
-- 12、系统访问记录
-- ----------------------------
drop table if exists sys_logininfor;
create table sys_logininfor (
  id        bigint(20)     not null auto_increment   comment '访问ID',
  tenant_id         bigint(20)      not null                   comment '租户id',
  account      varchar(190)    default ''                comment '用户登录账号',
  user_id        bigint(20)     default 0              comment '用户ID',
  ipaddr         varchar(50)    default ''                comment '登录IP地址',
  login_location varchar(190)   default ''                comment '登录地点',
  device         tinyint(4)     default 10                comment '登录设备（10=PC端,20=手机APP,30=微信小程序）',
  browser        varchar(50)    default ''                comment '浏览器类型',
  os             varchar(50)    default ''                comment '操作系统',
  login_result   tinyint(4)        default 1               comment '登录结果（1=登录成功,-1=登录失败,11=退出成功）',
  msg            varchar(190)   default ''                comment '提示消息',
  login_time     datetime                                 comment '登录时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id)
) engine=innodb auto_increment=100 comment = '系统访问记录';


-- ----------------------------
-- 13、定时任务调度表
-- ----------------------------
drop table if exists sys_job;
create table sys_job (
  id              bigint(20)    not null auto_increment    comment '任务ID',
  job_name            varchar(64)   default ''                 comment '任务名称',
  job_group           varchar(64)   default 'DEFAULT'          comment '任务组名',
  invoke_target       varchar(500)  not null                   comment '调用目标字符串',
  cron_expression     varchar(190)  default ''                 comment 'cron执行表达式',
  misfire_policy      tinyint(4)   default '3'                comment '计划执行错误策略（0=默认,1=立即执行,2=执行一次,3=放弃执行）',
  concurrent          bit(1)       default 0                comment '是否并发执行（false=禁止,true=允许）',
  status              tinyint(4)       default 1                comment '状态（0=暂停,1=正常）',
  create_by           varchar(64)   default ''                 comment '创建者',
  create_time         datetime                                 comment '创建时间',
  update_by           varchar(64)   default ''                 comment '更新者',
  update_time         datetime                                 comment '更新时间',
  remark              varchar(500)  default ''                 comment '备注信息',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id, job_name, job_group)
) engine=innodb auto_increment=100 comment = '定时任务调度表';

insert into sys_job values(1, '系统默认（无参）', 'DEFAULT', 'taskTest.noParams',        '0/10 * * * * ?', '3', 0, 0, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_job values(2, '系统默认（有参）', 'DEFAULT', 'taskTest.params(\'test\')',  '0/15 * * * * ?', '3', 0, 0, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);
insert into sys_job values(3, '系统默认（多参）', 'DEFAULT', 'taskTest.multipleParams(\'test\', true, 2000L, 316.50D, 100)',  '0/20 * * * * ?', '3', 0, 0, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '', 0, 0);


-- ----------------------------
-- 14、定时任务调度日志表
-- ----------------------------
drop table if exists sys_job_log;
create table sys_job_log (
  id          bigint(20)     not null auto_increment    comment '任务日志ID',
  job_name            varchar(64)    not null                   comment '任务名称',
  job_group           varchar(64)    not null                   comment '任务组名',
  invoke_target       varchar(500)   not null                   comment '调用目标字符串',
  job_message         varchar(500)                              comment '日志信息',
  status              tinyint(4)        default 1                comment '执行状态（0=失败,1=正常）',
  exception_info      varchar(2000)  default ''                 comment '异常信息',
  start_time       datetime                                   comment '任务开始时间',
  stop_time        datetime                                   comment '任务结束时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id)
) engine=innodb comment = '定时任务调度日志表';


-- ----------------------------
-- 15、通知公告表
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice (
  id         bigint(20)          not null auto_increment    comment '公告ID',
  tenant_id         bigint(20)      not null                   comment '租户id',
  notice_title      varchar(50)     not null                   comment '公告标题',
  notice_type       tinyint(4)         not null                   comment '公告类型（1=通知,2=公告）',
  notice_content    varchar(2000)   default ''               comment '公告内容',
  status            tinyint(4)         default 1                comment '公告状态（0=关闭,1=正常）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id)
) engine=innodb auto_increment=10 comment = '通知公告表';

-- ----------------------------
-- 初始化-公告信息表数据
-- ----------------------------
insert into sys_notice values('1', 1, '温馨提醒：新版本发布啦', '2', '新版本内容', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '管理员', 0, 0);
insert into sys_notice values('2', 1, '维护通知：系统凌晨维护', '1', '维护内容', 1, 'admin', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', '管理员', 0, 0);


-- ----------------------------
-- 16、代码生成业务表
-- ----------------------------
drop table if exists gen_table;
create table gen_table (
  id          bigint(20)      not null auto_increment    comment '主键',
  table_name        varchar(200)    default ''                 comment '表名称',
  table_comment     varchar(500)    default ''                 comment '表描述',
  class_name        varchar(100)    default ''                 comment '实体类名称',
  tpl_category      varchar(50)     default 'crud'             comment '使用的模板（crud单表操作 tree树表操作）',
  package_name      varchar(100)                               comment '生成包路径',
  module_name       varchar(30)                                comment '生成模块名',
  business_name     varchar(30)                                comment '生成业务名',
  function_name     varchar(50)                                comment '生成功能名',
  function_author   varchar(50)                                comment '生成功能作者',
  options           varchar(1000)                              comment '其它生成选项',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id)
) engine=innodb auto_increment=1 comment = '代码生成业务表';


-- ----------------------------
-- 17、代码生成业务表字段
-- ----------------------------
drop table if exists gen_table_column;
create table gen_table_column (
  id         bigint(20)      not null auto_increment    comment '主键',
  table_id          varchar(64)                                comment '归属表编号',
  column_name       varchar(200)                               comment '列名称',
  column_comment    varchar(500)                               comment '列描述',
  column_type       varchar(100)                               comment '列类型',
  java_type         varchar(500)                               comment 'JAVA类型',
  java_field        varchar(200)                               comment 'JAVA字段名',
  primary_key       bit(1)                                    comment '是否主键（false=否,true=是）',
  incremental      bit(1)                                    comment '是否自增（false=否,true=是）',
  required       bit(1)                                    comment '是否必填（false=否,true=是）',
  insertable     bit(1)                                    comment '是否为插入字段（false=否,true=是）',
  edit           bit(1)                                    comment '是否编辑字段（false=否,true=是）',
  list           bit(1)                                    comment '是否列表字段（false=否,true=是）',
  excel_export      bit(1)                                    comment '是否导出字段（false=否,true=是）',
  excel_import      bit(1)                                    comment '是否导入字段（false=否,true=是）',
  query          bit(1)                                    comment '是否查询字段（false=否,true=是）',
  query_type        varchar(50)     default 'EQ'               comment '查询方式（等于、不等于、大于、小于、范围）',
  html_type         varchar(100)                               comment '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  enum_full_name         varchar(150)    default ''                 comment '枚举类全限定名',
  sort              int(4)                                     comment '排序',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''               comment '备注',
  deleted           bit(1)          default 0                comment '删除标志（false=存在,true=删除）',
  version           int(11)         default 0                comment '乐观锁数据版本',
  primary key (id)
) engine=innodb auto_increment=1 comment = '代码生成业务表字段';


-- 以下为quartz定时任务默认表

-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- 如果是utf8mb4编码，则作为索引的varchar字段不能大于767/4=191.75
-- ----------------------------
drop table if exists QRTZ_JOB_DETAILS;
create table QRTZ_JOB_DETAILS (
    sched_name           varchar(120)    not null,
    job_name             varchar(190)    not null,
    job_group            varchar(190)    not null,
    description          varchar(250)    null,
    job_class_name       varchar(250)    not null,
    is_durable           varchar(1)      not null,
    is_nonconcurrent     varchar(1)      not null,
    is_update_data       varchar(1)      not null,
    requests_recovery    varchar(1)      not null,
    job_data             blob            null,
    primary key (sched_name,job_name,job_group)
) engine=innodb;

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
drop table if exists QRTZ_TRIGGERS;
create table QRTZ_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(190)    not null,
    trigger_group        varchar(190)    not null,
    job_name             varchar(190)    not null,
    job_group            varchar(190)    not null,
    description          varchar(250)    null,
    next_fire_time       bigint(13)      null,
    prev_fire_time       bigint(13)      null,
    priority             integer         null,
    trigger_state        varchar(16)     not null,
    trigger_type         varchar(8)      not null,
    start_time           bigint(13)      not null,
    end_time             bigint(13)      null,
    calendar_name        varchar(200)    null,
    misfire_instr        smallint(2)     null,
    job_data             blob            null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,job_name,job_group) references QRTZ_JOB_DETAILS(sched_name,job_name,job_group)
) engine=innodb;

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
drop table if exists QRTZ_SIMPLE_TRIGGERS;
create table QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(190)    not null,
    trigger_group        varchar(190)    not null,
    repeat_count         bigint(7)       not null,
    repeat_interval      bigint(12)      not null,
    times_triggered      bigint(10)      not null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb;

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ----------------------------
drop table if exists QRTZ_CRON_TRIGGERS;
create table QRTZ_CRON_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(190)    not null,
    trigger_group        varchar(190)    not null,
    cron_expression      varchar(200)    not null,
    time_zone_id         varchar(80),
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb;

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ----------------------------
drop table if exists QRTZ_BLOB_TRIGGERS;
create table QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(190)    not null,
    trigger_group        varchar(190)    not null,
    blob_data            blob            null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb;

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ----------------------------
drop table if exists QRTZ_CALENDARS;
create table QRTZ_CALENDARS (
    sched_name           varchar(120)    not null,
    calendar_name        varchar(190)    not null,
    calendar             blob            not null,
    primary key (sched_name,calendar_name)
) engine=innodb;

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ----------------------------
drop table if exists QRTZ_PAUSED_TRIGGER_GRPS;
create table QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(120)    not null,
    trigger_group        varchar(190)    not null,
    primary key (sched_name,trigger_group)
) engine=innodb;

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ----------------------------
drop table if exists QRTZ_FIRED_TRIGGERS;
create table QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(120)    not null,
    entry_id             varchar(95)     not null,
    trigger_name         varchar(190)    not null,
    trigger_group        varchar(190)    not null,
    instance_name        varchar(190)    not null,
    fired_time           bigint(13)      not null,
    sched_time           bigint(13)      not null,
    priority             integer         not null,
    state                varchar(16)     not null,
    job_name             varchar(200)    null,
    job_group            varchar(200)    null,
    is_nonconcurrent     varchar(1)      null,
    requests_recovery    varchar(1)      null,
    primary key (sched_name,entry_id)
) engine=innodb;

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ----------------------------
drop table if exists QRTZ_SCHEDULER_STATE;
create table QRTZ_SCHEDULER_STATE (
    sched_name           varchar(120)    not null,
    instance_name        varchar(190)    not null,
    last_checkin_time    bigint(13)      not null,
    checkin_interval     bigint(13)      not null,
    primary key (sched_name,instance_name)
) engine=innodb;

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ----------------------------
drop table if exists QRTZ_LOCKS;
create table QRTZ_LOCKS (
    sched_name           varchar(120)    not null,
    lock_name            varchar(40)     not null,
    primary key (sched_name,lock_name)
) engine=innodb;

drop table if exists QRTZ_SIMPROP_TRIGGERS;
create table QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(190)    not null,
    trigger_group        varchar(190)    not null,
    str_prop_1           varchar(512)    null,
    str_prop_2           varchar(512)    null,
    str_prop_3           varchar(512)    null,
    int_prop_1           int             null,
    int_prop_2           int             null,
    long_prop_1          bigint          null,
    long_prop_2          bigint          null,
    dec_prop_1           numeric(13,4)   null,
    dec_prop_2           numeric(13,4)   null,
    bool_prop_1          varchar(1)      null,
    bool_prop_2          varchar(1)      null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb;

commit;
