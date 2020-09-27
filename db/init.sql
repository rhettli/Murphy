create table articles
(
    id                 int auto_increment
        primary key,
    product_channel_id int                  null,
    title              varchar(300)         null,
    member_id          int                  null,
    real_member_id     int                  null,
    content            text                 null,
    descr              varchar(500)         null,
    status             tinyint    default 0 null comment '0 草稿 ， 1 发布',
    created_at         int                  null,
    refresh_at         int                  null,
    updated_at         int                  null,
    is_virtual         tinyint(1) default 0 null comment '是否虚拟用户发布',
    comment_num        int        default 0 null comment '评论数量',
    view_num           int                  null comment '查看次数'
)
    comment '文章表' charset = utf8;

create table attentions
(
    id         int auto_increment
        primary key,
    created_at int                  null,
    updated_at int                  null,
    content    text                 null,
    is_watched tinyint(1) default 0 null
);

create table banners
(
    id                  int unsigned auto_increment
        primary key,
    operator_id         int           null,
    name                varchar(255)  null,
    image               varchar(255)  null,
    url                 varchar(255)  null,
    created_at          int           null,
    status              int           null,
    `rank`              int           null,
    type                int           null,
    platforms           varchar(255)  null,
    partner_ids         text          null,
    material_type       int default 0 null,
    material_ids        text          null,
    template_id         int           null,
    xcx_url             varchar(255)  null,
    product_channel_ids varchar(511)  null,
    app_url             varchar(255)  null
)
    engine = MyISAM
    collate = utf8_bin;

create table cloud
(
    id         int auto_increment
        primary key,
    created_at int              null,
    updated_at int              null,
    vip_expire int              null comment 'vip到期时间',
    member_id  int              null,
    total_size bigint           null,
    used_size  bigint default 0 null,
    remark     varchar(200)     null
);

create table cloud_file
(
    id              int auto_increment
        primary key,
    pid             int    default 0             null,
    created_at      int                          null,
    updated_at      int                          null,
    name            varchar(500) charset utf8mb4 null,
    md5             varchar(50)                  null,
    folder          varchar(500)                 null comment '文件所在目录',
    file_created_at int                          null,
    file_updated_at int                          null,
    member_id       int                          null,
    share_uri       varchar(100)                 null comment '分享地址 有则可以分享',
    share_expire    int                          null comment '分享到期时间',
    share_psw       varchar(20)                  null,
    mime            varchar(50)                  not null,
    real_size       bigint default 0             null,
    size            bigint default 64000         null comment '用于计算用户文件总大小的尺寸，默认64k'
)
    comment '用户云文件表';

create index cloud_file_folder_index
    on cloud_file (folder);

create index cloud_file_md5_index
    on cloud_file (md5);

create index cloud_file_pid_index
    on cloud_file (pid);

create table cloud_file_history
(
    id         int auto_increment
        primary key,
    created_at int     null,
    operate    tinyint null,
    file_id    int     null
);

create table codes
(
    id            int auto_increment
        primary key,
    title         varchar(500)         not null,
    created_at    int                  null,
    updated_at    int        default 0 null,
    member_id     int                  not null,
    is_private    tinyint(1) default 0 null,
    content_all   text                 null,
    content_win   text                 null,
    content_mac   text                 null,
    content_linux text                 null,
    status        tinyint    default 0 null,
    source        tinyint    default 0 null comment '0 自己撰写，1 github， 2 gitee',
    use_cli       tinyint(1) default 0 null comment '是否使用cli命令行执行',
    platform      varchar(30)          null comment '1 全部平台 2 linux 3 mac 4 linux&mac',
    alias         varchar(50)          null,
    language      varchar(30)          null
);

create table comment_article
(
    id              int auto_increment
        primary key,
    parent_id       int        default 0     null comment '评论的父id（父评论id）',
    reply_member_id int                      null comment '被回复的人的id',
    created_at      int                      null,
    content         tinytext charset utf8mb4 null,
    member_id       int                      null comment '发表评论的人的id',
    real_member_id  int                      null comment '真正发表人id（用做虚拟用户的时候使用）',
    is_virtual      tinyint(1) default 0     null,
    article_id      int                      null,
    like_num        int        default 0     null,
    sub_comment_num int        default 0     null
);

create table comment_code
(
    id             int auto_increment
        primary key,
    created_at     int                      null,
    content        tinytext charset utf8mb4 null,
    member_id      int                      null,
    real_member_id int                      null,
    is_virtual     tinyint(1) default 0     null
);

create table covers
(
    id         int auto_increment
        primary key,
    created_at int                          null,
    updated_at int                          null,
    title      varchar(200) charset utf8mb4 null,
    descr      varchar(500) charset utf8mb4 null,
    path       varchar(200)                 null,
    member_id  int                          null,
    type       int                          null,
    status     int default 0                null,
    md5        varchar(32)                  null,
    tags       varchar(300)                 null
);

create table cw_package
(
    id            int auto_increment
        primary key,
    member_id     int           null,
    name          varchar(100)  null,
    title         varchar(200)  null,
    port          varchar(200)  null,
    git_source    varchar(355)  null,
    platform      varchar(100)  null,
    created_at    int           null,
    updated_at    int default 0 null,
    run_type      varchar(50)   null comment 'package cmd plugs',
    install_times int default 0 null,
    remark        tinytext      null,
    status        int default 0 null
);

create index cw_package_member_id_name_index
    on cw_package (member_id, name);

create table cw_program
(
    id            int auto_increment
        primary key,
    member_id     int           null,
    name          varchar(50)   null,
    git_source    tinytext      null comment '保存的git地址',
    install_times int default 0 null comment '安装次数',
    created_at    int           null,
    updated_at    int default 0 null
);

create index cw_program_member_id_name_pk
    on cw_program (member_id, name);

create table device
(
    id                 int unsigned auto_increment
        primary key,
    product_channel_id int          null,
    platform           varchar(255) null comment 'windows drawin linux',
    version_code       int          null,
    version_name       varchar(255) null,
    sid                varchar(255) null,
    member_id          int          null comment '当前设备最后一个登录的member_id',
    reg_num            int          null,
    status             int          null comment '1 正常 2 禁封',
    ip                 varchar(255) null,
    created_at         int          null,
    device_no          varchar(255) null,
    last_at            int          null,
    latitude           int          null,
    longitude          int          null,
    net                varchar(255) null,
    constraint device_pk
        unique (device_no)
)
    engine = MyISAM
    collate = utf8_bin;

create table file
(
    id         int auto_increment
        primary key,
    user_id    int           null comment '用户id',
    md5        int           null comment '公司id',
    type       int default 1 null comment '0图片',
    created_at int           null
)
    comment '用户上传的图片保存表' engine = MyISAM
                         collate = utf8_bin;

create table gb_history
(
    id         int auto_increment
        primary key,
    b          bigint default 0 null comment '用户剩余资产（字节）1024b*1024b*1024b=1GB',
    type       int              null comment '记录交易类型',
    created_at int    default 0 null,
    update_at  int    default 0 null,
    member_id  int              null
)
    comment '用户资产1GB=1元';

create table gb_storage_history
(
    id               int auto_increment
        primary key,
    member_id        int              null,
    b                bigint default 0 null comment '用户剩余资产（字节）1024b*1024b*1024b=1GB',
    type             int              null comment '记录交易类型',
    b_time_inc       bigint default 0 null comment '用户增长时间的字节，当达到50GB的时候，立即增加期限4个月，然后归零，重新开始计算',
    b_time_inc_total bigint default 0 null comment '用户总共增长时间的字节，不归零，仅仅用做统计',
    created_at       int    default 0 null,
    update_at        int    default 0 null
);

create table gb_ticket
(
    id             int auto_increment
        primary key,
    member_id      int              null,
    created_at     int              null,
    update_at      int              null,
    gb             bigint default 0 null,
    gb_left        bigint default 0 null,
    inc_time       int    default 0 null comment '剩余增长时间',
    inc_time_total int    default 0 null comment '总共增长时间',
    uid            varchar(100)     null
)
    comment '存储票据，gb历史可以兑换票据，票据可以兑换存储';

create table member
(
    id                 int unsigned auto_increment comment '用户ID'
        primary key,
    uid                int                                 null,
    username           char(16)                            not null comment '用户名',
    password           char(32)                            null comment '密码',
    nickname           varchar(20)                         null,
    email              char(32)                            null comment '用户邮箱',
    mobile             char(15)  default ''                null comment '用户手机',
    reg_ip             varchar(20)                         null comment '注册IP',
    last_login_time    timestamp default CURRENT_TIMESTAMP not null comment '最后登录时间',
    last_login_ip      varchar(20)                         null comment '最后登录IP',
    update_time        int unsigned                        null comment '更新时间',
    status             tinyint   default 0                 null comment '用户状态0待审核1正常2小黑屋',
    qq_openid          varchar(100)                        null,
    sina_openid        varchar(100)                        null,
    login_type         tinyint(1)                          null comment '会员登录方式：1pc2app3cmd',
    is_test            int                                 null comment '是否是内部测试号',
    sid                varchar(100)                        null,
    product_channel_id int unsigned                        null,
    last_at            int                                 null,
    created_at         int                                 null,
    device_id          int                                 null,
    openid             varchar(255)                        null,
    xcx_openid         varchar(255)                        null,
    latitude           float                               null,
    longitude          float                               null,
    device_no          varchar(100)                        null,
    balance            decimal(10, 2)                      null,
    wx_third_unionid   varchar(100)                        null,
    user_status        int       default 0                 null,
    avatar             varchar(200)                        null,
    sex                int                                 null,
    expire_app_at      int                                 null comment 'app可以直接执行代码到期时间
',
    expire_cmd_at      int                                 null comment '用户可以使用cmd到期时间',
    is_random          tinyint                             null,
    sync_id            varchar(200)                        null,
    can_virtual        tinyint   default 0                 null comment '是否可以操作虚拟用户',
    tags               varchar(100)                        null comment '空格分割的标签',
    words              varchar(200)                        null comment '他的至理名言',
    article_num        int                                 null comment '发布的文章数量',
    code_num           int                                 null comment '发布的功能代码数量',
    gb                 bigint                              null,
    gb_storage         bigint                              null,
    device_num         int       default 6                 null,
    constraint hd_member_sid_uindex
        unique (sid),
    constraint member_email_uindex
        unique (email),
    constraint member_username_uindex
        unique (username)
)
    comment '用户表' charset = utf8;

create table merchant_products
(
    id         int unsigned auto_increment
        primary key,
    user_id    int null,
    product_id int null,
    type       int null,
    status     int null,
    created_at int null,
    updated_at int null,
    `rank`     int null,
    score      int null,
    sale_num   int null
)
    engine = MyISAM
    collate = utf8_bin;

create table operating_records
(
    id          int unsigned auto_increment
        primary key,
    operator_id int          null,
    table_name  varchar(255) null,
    target_id   int          null,
    action_type varchar(255) null,
    data        text         null,
    updated_at  int          null,
    created_at  int          null
)
    engine = MyISAM
    collate = utf8_bin;

create table operator
(
    id                  int unsigned auto_increment
        primary key,
    status              int          null,
    username            varchar(255) null,
    password            varchar(255) null,
    role                varchar(255) null,
    updated_at          int          null,
    ip                  varchar(255) null,
    active_at           int          null,
    created_at          int          null,
    operator_role_id    int          null,
    warehouse_ids       tinytext     null,
    password_updated_at int          null
)
    engine = MyISAM
    collate = utf8_bin;

create table operator_login_histories
(
    id          int unsigned auto_increment
        primary key,
    operator_id int          null,
    ip          varchar(255) null,
    login_at    int          null,
    created_at  int          null,
    updated_at  int          null,
    location    varchar(255) null
)
    engine = MyISAM
    collate = utf8_bin;

create table operator_role
(
    id               int unsigned auto_increment
        primary key,
    name             varchar(255) null,
    status           int          null,
    update_at        int          null,
    created_at       int          null,
    permission_items text         null
)
    engine = MyISAM
    collate = utf8_bin;

create table orders
(
    id                 int auto_increment
        primary key,
    product_channel_id int         null,
    payment_channel_id int         null,
    member_id          int         null,
    payment_no         int         null,
    payment_status     int         null comment '1 已支付 0 未支付',
    notify_status      int         null,
    payment_type       varchar(20) null,
    buy_type           varchar(20) null,
    buy_time           varchar(20) null,
    created_at         int         null,
    payed_at           int         null,
    updated_at         int         null,
    cny_amount         decimal(2)  null
);

create table partners
(
    id                    int unsigned auto_increment
        primary key,
    name                  varchar(255) null,
    fr                    varchar(255) null,
    product_channel_ids   varchar(255) null,
    created_at            int          null,
    status                int          null,
    notify_callback       varchar(255) null,
    member_group_id       int          null,
    invite_code           varchar(255) null,
    company_name          varchar(255) null,
    company_icp           varchar(255) null,
    company_service_phone varchar(255) null,
    kefu_mobile           varchar(255) null
)
    engine = MyISAM
    collate = utf8_bin;

create table payment_channel_product_channels
(
    id                 int unsigned auto_increment
        primary key,
    payment_channel_id int null,
    product_channel_id int null,
    created_at         int null
);

create table payment_channels
(
    id           int unsigned auto_increment
        primary key,
    mer_no       varchar(255)   null,
    app_id       varchar(255)   null,
    app_password text           null,
    gateway_url  varchar(255)   null,
    `rank`       int            null,
    status       int            null,
    name         varchar(255)   null,
    clazz        varchar(255)   null,
    created_at   int            null,
    updated_at   int            null,
    mer_name     varchar(255)   null,
    fee          decimal(10, 5) null,
    platform     varchar(255)   null,
    need_vesion  varchar(255)   null,
    app_key      text           null,
    payment_type varchar(255)   null,
    discount     decimal(10, 2) null
);

create table product_channels
(
    id                                    int unsigned auto_increment
        primary key,
    name                                  varchar(255)  null,
    code                                  varchar(255)  null,
    company_name                          varchar(255)  null,
    domain                                varchar(255)  null,
    service_phone                         varchar(255)  null,
    avatar                                varchar(255)  null,
    sms_sign                              varchar(255)  null,
    status                                int           null,
    icp                                   varchar(255)  null,
    weixin_domain                         varchar(255)  null,
    weixin_appid                          varchar(255)  null,
    weixin_secret                         varchar(255)  null,
    weixin_token                          varchar(255)  null,
    weixin_name                           varchar(255)  null,
    weixin_white_list                     text          null,
    weixin_type                           varchar(255)  null,
    created_at                            int           null,
    updated_at                            int           null,
    agreement_company_name                varchar(255)  null,
    agreement_company_shortname           varchar(255)  null,
    ios_app_id                            varchar(255)  null,
    ios_app_key                           varchar(255)  null,
    ios_app_secret                        varchar(255)  null,
    ios_app_master_secret                 varchar(255)  null,
    ios_bundle_no                         varchar(255)  null,
    android_app_id                        varchar(255)  null,
    android_app_key                       varchar(255)  null,
    android_app_secret                    varchar(255)  null,
    android_app_master_secret             varchar(255)  null,
    ckey                                  varchar(255)  null,
    apple_stable_version                  int           null,
    android_stable_version                int           null,
    ios_client_theme_stable_version       int           null,
    android_client_theme_stable_version   int           null,
    ios_client_theme_test_version         int default 0 null,
    ios_client_theme_foreign_version_code int default 0 null,
    cooperation_weixin                    varchar(255)  null,
    cooperation_email                     varchar(255)  null,
    cooperation_phone_number              varchar(255)  null,
    official_website                      varchar(255)  null,
    weixin_theme                          varchar(255)  null,
    weixin_menu_template_id               int           null,
    weixin_fr                             varchar(255)  null,
    weixin_no                             varchar(255)  null,
    weixin_qrcode                         varchar(255)  null,
    touch_name                            varchar(255)  null,
    touch_domain                          varchar(255)  null,
    touch_theme                           varchar(255)  null,
    touch_fr                              varchar(255)  null,
    web_domain                            varchar(255)  null,
    web_name                              varchar(255)  null,
    web_fr                                varchar(255)  null,
    web_theme                             varchar(255)  null,
    weixin_welcome                        varchar(255)  null,
    xcx_name                              varchar(255)  null,
    xcx_domain                            varchar(255)  null,
    xcx_theme                             varchar(255)  null,
    xcx_secret                            varchar(255)  null,
    xcx_appid                             varchar(255)  null,
    xcx_token                             varchar(255)  null,
    xcx_fr                                varchar(255)  null,
    operator_id                           int           null,
    xcx_stable_version                    int           null,
    role                                  int           null
);

create table products
(
    id                     int unsigned auto_increment
        primary key,
    name                   varchar(255)                null,
    icon                   varchar(255)                null,
    amount                 decimal(10, 2)              null,
    status                 int                         null,
    `rank`                 int                         null,
    created_at             int                         null,
    updated_at             int                         null,
    discount_level         int                         null,
    gold_member_amount     decimal(10, 2)              null,
    standard_member_amount decimal(10, 2)              null,
    sale_num               int                         null,
    category_id            int                         null,
    brand_id               int                         null,
    start_order_num        int                         null,
    multiple_num           int                         null,
    is_essence             int                         null,
    is_bargain             int                         null,
    is_free_post           int                         null,
    free_post_num          int                         null,
    remark                 tinytext                    null,
    description            text                        null,
    is_new                 int                         null,
    unit                   tinytext                    null,
    supplier_id            int            default 0    null,
    express_company_ids    text                        null,
    purchase_name          varchar(255)                null,
    c_cash_score           int                         null,
    c_amount               decimal(10, 2)              null,
    tax_rate               decimal(10, 4)              null,
    outsourcing            int            default 0    null,
    promotion              int            default 0    null,
    quality                int            default 0    null,
    material_form          int                         null,
    ordinary_amount        decimal(10, 2) default 0.00 null,
    activity_image         varchar(200)                null,
    update_reason          varchar(191)                null,
    update_status          int            default 0    null,
    vip_member_amount      decimal(10, 2)              null,
    params                 varchar(1024)               null,
    unique_no              int                         null,
    standard_member_range  varchar(255)                null,
    gold_member_range      varchar(255)                null,
    type                   int            default 0    null,
    sell_type              int            default 0    null
)
    engine = MyISAM
    collate = utf8_bin;

create table question
(
    id                 int auto_increment
        primary key,
    product_channel_id int  null,
    member_id          int  null,
    title              text null,
    status             int  null,
    content            text null,
    created_at         int  null,
    updated_at         int  null
);

create table schema_migrations
(
    version varchar(255) null,
    constraint version
        unique (version)
);

create table sid
(
    id         int auto_increment
        primary key,
    created_at int default 0 null,
    updated_at int default 0 null,
    member_id  int           null,
    device_id  int           null,
    sid        varchar(50)   null,
    constraint sid_pk
        unique (sid)
);

create table skus
(
    id                     int unsigned auto_increment
        primary key,
    product_id             int            null,
    amount                 decimal(10, 2) null,
    standard_member_amount decimal(10, 2) null,
    gold_member_amount     decimal(10, 2) null,
    attribute_item_ids     text           null,
    status                 int            null,
    `rank`                 int            null,
    created_at             int            null,
    updated_at             int            null,
    weight                 decimal(20, 6) null,
    volume                 decimal(20, 6) null,
    length                 decimal(10, 2) null,
    width                  decimal(10, 2) null,
    height                 decimal(10, 2) null,
    is_package             int            null,
    attribute_descr        varchar(255)   null,
    code                   varchar(255)   null,
    c_cash_score           int            null,
    c_amount               decimal(10, 2) null,
    have_receipt           int default 0  null,
    presell_num            int            null,
    ordinary_amount        decimal(10, 2) null,
    vip_member_amount      decimal(10, 2) null,
    image                  varchar(255)   null,
    unique_no              int            null
)
    engine = MyISAM
    collate = utf8_bin;

create table slice_codes
(
    id         int auto_increment
        primary key,
    article_id int                  null,
    created_at int                  null,
    updated_at int                  null,
    member_id  int                  null,
    content    text charset utf8mb4 null,
    exec_times int                  null,
    lan        varchar(20)          null,
    new_column int                  null,
    is_freedom tinyint(1) default 0 null comment '是否是冗余代码段'
);

create table sms_channels
(
    id                  int unsigned auto_increment
        primary key,
    name                varchar(255) null,
    username            varchar(255) null,
    password            varchar(255) null,
    url                 varchar(255) null,
    clazz               varchar(255) null,
    status              int          null,
    `rank`              int          null,
    signature           varchar(255) null,
    created_at          int          null,
    sms_type            varchar(255) null,
    template            varchar(255) null,
    company_no          varchar(127) null,
    mobile_operator     int          null,
    product_channel_ids text         null,
    operator_id         int          null
)
    engine = MyISAM
    collate = utf8_bin;

create table sms_histories
(
    id                 int unsigned auto_increment
        primary key,
    sms_channel_id     int          null,
    mobile             varchar(255) null,
    sms_type           varchar(255) null,
    content            varchar(255) null,
    auth_status        int          null,
    send_status        int          null,
    expired_at         int          null,
    created_at         int          null,
    product_channel_id int          null,
    device_id          int          null,
    sms_token          varchar(255) null,
    context            text         null,
    updated_at         int          null
)
    engine = MyISAM
    collate = utf8_bin;

create table stats
(
    id                 int unsigned auto_increment
        primary key,
    stat_at            int                       null,
    time_type          int                       null,
    province_id        int          default -1   null,
    platform           varchar(255) default '-1' null,
    version_code       int          default -1   null,
    product_channel_id int          default -1   null,
    partner_id         int          default -1   null,
    sex                int          default -1   null,
    data               text                      null
)
    engine = MyISAM
    collate = utf8_bin;

create table tags
(
    id         int auto_increment
        primary key,
    pid        int               null comment '用户id',
    title      varchar(100)      null,
    created_at int               null,
    update_at  int               null,
    type       tinyint default 0 null comment '1 随意 2 语言种类',
    icon       varchar(200)      null,
    constraint tags_title_uindex
        unique (title)
)
    engine = MyISAM
    collate = utf8_bin;

create table tags_map_article
(
    id         int auto_increment
        primary key,
    tag_id     int null,
    article_id int null,
    created_at int null
);

create table tags_map_code
(
    id         int auto_increment
        primary key,
    tag_id     int not null,
    code_id    int not null,
    created_at int null
);

