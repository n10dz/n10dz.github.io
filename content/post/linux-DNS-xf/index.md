---
title: "解决国产信创Linux系统DNS配置被重置问题"
date: 2025-03-20T16:45:00+08:00
draft: false
categories: ["关于运维"]
tags: ["信创", "Linux"]
cover:
    image: "https://source.unsplash.com/featured/?linux,server"
    alt: "Linux服务器网络配置"
    caption: "Linux系统DNS配置问题排查"
comments: true  # 启用Utterances评论
---

本文针对麒麟、统信UOS、Ubuntu等Linux发行版中出现的`/etc/resolv.conf`文件被强制重置为`127.0.0.53`问题，提供两种解决方案。

## 问题现象
- 麒麟系统无法上网，打不开网页。
- 手动修改`/etc/resolv.conf`后，重启系统或网络服务时配置被覆盖。
- DNS服务器被强制设置为`127.0.0.53`（systemd-resolved服务地址）。

## 解决方案

### 一：临时修改DNS（重启后失效）
```bash
# 编辑DNS配置文件
sudo vim /etc/resolv.conf

# 替换为以下内容（示例使用Google DNS）
nameserver 8.8.8.8  
nameserver 8.8.4.4
```
### 二：永久解决方案（推荐）
#### 步骤1：停用systemd-resolved服务
```bash
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
```
#### 步骤2：安装unbound解析器
```bash
sudo apt update && sudo apt install unbound -y
```
#### 步骤3：配置NetworkManager
```bash
sudo vim /etc/NetworkManager/NetworkManager.conf
#在 [main] 段落添加配置：

ini
dns=unbound
```
#### 步骤4：应用配置
```bash
sudo systemctl restart NetworkManager
```
### 验证结果
```bash
cat /etc/resolv.conf  # 应显示实际配置的DNS服务器
ping baidu.com        # 测试网络连通性
```

### 📌技术原理
systemd-resolved 是新一代DNS解析服务，会强制接管DNS配置。本方案通过：

1.  用unbound替代默认解析器
2.  修改NetworkManager的DNS管理策略
3.  建立稳定的DNS配置托管机制

### 故障排查
#### 如遇网络异常，可通过以下命令恢复：
```bash
sudo systemctl enable systemd-resolved --now
sudo rm /etc/NetworkManager/conf.d/dns.conf
```

> 本文适用于以下国产信创系统：
> 麒麟Kylin V10
> 统信UOS 20
> Ubuntu 18.04+/Debian 10+

