# Voixa [Amazon Alexa Demo]


## Table of Content

- [Introduction](#Introduction)
- [Team Members](#Team_Members)
- [Architecture](#Architecture)
- [Future Works](#Future_Works)
- [Deployment](#Deployment)


## [Introduction](id:Introduction)


**ps: If there is any questions or suggestions, please contact *[david.wang@finishy.cn](mailto:david.wang@finishy.cn)*。**

Voixa is a sample project using Amazon Alexa. In this project, we want to use Alexa and Echo to read the news that users are really interested in from the tons of news each day. Serverless architecture is used in this project to crawl data from the specified websites by users. Users can also specify keyword that they are interested in and Echo can read news related to the specified keywords.

This demo is for experimental purpose only. If you want to deploy your own application in cloud, please refer to the official website of AWS for more details.

## [Team Members](id:Team_Members)

**Big Five Wolves Team**
1. ***@Bob Zhang***
2. ***@Nick Jiang***
3. ***@Haipeng Qi***
4. ***@Andrew Ren***
5. ***@David Wang***


## [Architecture](id:Architecture)

The data collection architecture is as follows：

![Data Collection Architecture](./Data_Collect.jpeg)

The news reading by Echo is implemented as follows：

![News Reading Architecture](./Alexa_Skill.jpeg)


## [Future Works](id:Future_Works)

- One button deployment using AWS CloudFormation
- Add support to more websites and keywords
- Polish Frontend UI


## [Deployment](id:Deployment)

Please refer to the reference architecture for deployment and pay attention to the permission setting.
