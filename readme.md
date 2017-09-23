# Voixa [Amazon Alexa Demo]


## 目录

- [简介](#简介)
- [特别感谢](#特别感谢)
- [项目架构](#项目架构)
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


## [更新计划](id:更新计划)

- 编写脚本，结合 AWS CloudFormation 自动部署
- 添加更多的网站和内容组合
- 完善前端UI


## [项目部署](id:项目部署)

参考架构图进行部署，注意权限设置。
