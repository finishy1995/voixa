# Voixa [Amazon Alexa Demo]


## 目录

- [简介](#简介)
- [特别感谢](#特别感谢)
- [项目架构](#项目架构)
- [版本信息](#版本信息)
- [更新计划](#更新计划)
- [项目部署](#项目部署)


## [简介](id:简介)


**特别提醒: 本如果有任何疑问和建议，请联系邮箱：*[david.wang@finishy.cn](mailto:david.wang@finishy.cn)*。**

Voixa是一个Amazon Alexa的示例项目。在本示例项目中，考虑到资讯爆炸的情况，我们想要利用Alexa自动播报真正感兴趣的话题。利用Serverless无服务器架构，实现了订阅指定网站的指定关键词（例：网站 AWS，关键词 大数据），利用Alexa自动播报相关资讯的简讯。

本演示仅用于试验和参考用途，如果您想在云端开发自己的应用，请登录AWS官网查看详细信息。


## [特别感谢](id:特别感谢)

**Big Five Wolves**
1. ***@Bob Zhang***
2. ***@Nick Jiang***
3. ***@Haipeng Qi***
4. ***@Andrew Ren***
5. ***@David Wang***


## [项目架构](id:项目架构)

采用如下架构搭建数据采集架构：

![数据采集架构](./Data_Collect.jpeg)

采用如下架构实现Alexa播报新闻：

![新闻播报架构](./Alexa_Skill.jpeg)


## [版本信息](id:版本信息)

### [v0.8](id:v0.8)

包测试版本，这些版本功能有残缺或者存在一定的Bug，慎用。

- v0.8.1
    - Demo 源代码
    - Demo 架构
    - 基本 AWS CloudFormation
- v0.8.2
    - 修复已知 Bug
    - 完善 AWS CloudFormation
    - 基本安装脚本
- v0.8.3
    - 修复前端 Bug
    - 静态页面上传
    - Cognito 自动配置

### [v0.9](id:v0.9)

内部测试版本，这些版本功能基本满足最低搭建要求，部分操作系统和条件可能会存在 Bug。

- v0.9.1
    - 安装脚本自动化
    - 修复 AWS CloudFormation 权限不足的 Bug
    - 重写 Readme
    

## [更新计划](id:更新计划)

[x] 编写启动脚本，结合 AWS CloudFormation 自动部署
[x] Readme 详细部署步骤
[x] 加入 Cognito 提高安全性
[x] 添加项目架构图
[ ] 英文Readme
[ ] 支持更多的操作系统运行脚本
[ ] 添加更多的网站和内容组合
[ ] 完善前端UI
[ ] 网页改为App，支持 Android & IOS


## [项目部署](id:项目部署)

**提醒:** 以下步骤在具备 aws-cli 和 Mac 系统下测试通过，其他情况下如有问题，请提交问题，谢谢！

### 前提条件

您需要具有 AWS 全球区账号，并具备 Admin 权限 （事实上并不需要这么大的权限，后续会降低权限要求）。

### 安装 aws-cli

如果您已经安装好了 aws-cli，可以跳过此步骤

```sh
sudo pip install awscli
```

更多的安装方法，请参考 [aws-cli链接](https://github.com/aws/aws-cli)

### 配置 aws-cli

如果您已经安装好了 aws-cli，可以跳过此步骤

```sh
aws configure --profile ${your_profile_name}
```

配置遇到了问题？请参考 [aws-cli链接](https://github.com/aws/aws-cli)

### 安装 Voixa

```sh
wget --no-check-certificate https://raw.githubusercontent.com/finishy1995/voixa/master/install.sh && chmod u+x install.sh && ./install.sh
```


遇到了任何问题，请直接提交，谢谢！

