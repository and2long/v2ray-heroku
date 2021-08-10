# Heroku Container Service for v2core

## 概述

部署完成后，每次启动应用将始终保持最新版本。

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://dashboard.heroku.com/new?template=https://github.com/and2long/v2ray-heroku/tree/v2core)

## 部署

对部署时需设定的变量名称做如下说明。

| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `AID` | `0` | 即 AlterID，范围为 0 至 65535 |
| `UID` | `ad806587-2d26-5636-98b6-ab85cc8521f7` | 用户ID，用于身份验证，为 UUID 格式 |
| `WSPATH` | `/` | WS 协议路径 |

## 接入 CF

以下两种方式均可以将应用接入 CF，从而在一定程度上提升速度。

 1. 为应用绑定域名，并将该域名接入 CF
 2. 通过 CF Workers 反向代理
