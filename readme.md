# Voixa  [Amazon Alexa Demo]


## Contents

- [Introduction](#Introduction)
- [Contributors](#Contributors)
- [Architecture](#Architecture)
- [Version Information](#Version_Information)
    - [v0.8](#v0.8)
    - [v0.9](#v0.9)
- [Future Works](#Future_Works)
- [Deployment](#Deployment)


## [Introduction](id:Introduction)


**ps: If there is any questions or suggestions, please contact *[david.wang@finishy.cn](mailto:david.wang@finishy.cn)*.**

Voixa is a sample project using Amazon Alexa. In this project, we want to use Alexa and Echo to read the news that users are really interested in from the tons of news each day. Serverless architecture is used in this project to crawl data from the specified websites by users. Users can also specify keyword that they are interested in and Echo can read news related to the specified keywords.

This demo is for experimental purpose only. If you want to deploy your own application in cloud, please refer to the official website of AWS for more details. [中文版本](https://github.com/finishy1995/voixa/blob/master/readme-cn.md)

## [Contributors](id:Contributors)

**Big Five Wolves Team**
1. ***@Bob Zhang***
2. ***@Nick Jiang***
3. ***@Haipeng Qi***
4. ***@Andrew Ren***
5. ***@David Wang***

**@Jason Xue**


## [Architecture](id:Architecture)

The data collection architecture is as follows：

![Data Collection Architecture](./Data_Collect.jpeg)

The news reading by Echo is implemented as follows：

![News Reading Architecture](./Alexa_Skill.jpeg)


## [Version Information](id:Version_Information)

### [v0.8](id:v0.8)

Version for package test. There are many bugs or missing in the following versions, so use them with aution.

- v0.8.1
    - Demo origin code
    - Demo architecture
    - Beta AWS CloudFormation
- v0.8.2
    - Fix some bugs
    - Directed available AWS CloudFormation
    - Beta install.sh
- v0.8.3
    - Fix static web bugs
    - Add static web files auto upload
    - Cognito auto deploy and configuration

### [v0.9](id:v0.9)

Version for internal test. The following versions meet the minimum requirements and not guarantee all OS and conditions.

- v0.9.1
    - One step deployment
    - Fix policy bug in AWS CloudFormation
    - Rewrite Readme.md files
    
- v0.9.2
    - Fix S3 "," bug
    - Limit aws regions in [us-east-1, eu-west-1]
    - Fix S3 create bucket API bug


## [Future Works](id:Future_Works)

- [x] One step deployment using AWS CloudFormation
- [x] Readme for deployment details
- [x] Add Cognito to improve security
- [x] Add Demo architecture
- [x] Readme for both English & Chinese
- [ ] Add support for more OS and conditions
- [ ] Add support to more websites and keywords
- [ ] Polish Frontend UI and more functions
- [ ] App for Android & IOS


## [Deployment](id:Deployment)

**ps: The following steps are testing in Mac with aws-cli. If there is any issues in other OS or conditions, please let us know. Thank you!**

### Prerequisites

You must have AWS Global account with AdministratorAccess. (Actually, the deployment needn't such a big access)

### Installation aws-cli

If you have already installed aws-cli, this step can be skipped.

```sh
sudo pip install awscli
```

For more details，please refer to [aws-cli](https://github.com/aws/aws-cli)

### Configured aws-cli

If you have already configured aws-cli, this step can be skipped.

```sh
aws configure --profile ${your_profile_name}
```

Have a problem? please refer to [aws-cli](https://github.com/aws/aws-cli)

### Deployment Voixa

```sh
wget --no-check-certificate https://raw.githubusercontent.com/finishy1995/voixa/master/install.sh && chmod u+x install.sh && ./install.sh
```

### Configured Alexa

You can configured the Alexa Skill in [Amazon Developer](https://developer.amazon.com/). The reference configuration is as follows.

**Skill Information**

![Skill Information](./img/Skill_Information.jpeg)

**Interaction Model**

![Interaction Model](./img/Interaction_Model.jpeg)

- Intent Schema
```Json
{
    "intents": [
        {
            "intent": "AMAZON.ResumeIntent"
        },
        {
            "intent": "AMAZON.PauseIntent"
        },
        {
            "slots": [
                {
                    "name": "blog",
                    "type": "LIST_OF_BLOG"
                }
            ],
            "intent": "MyBlogIsIntent"
        },
        {
            "intent": "WhatsMyBlogIntent"
        },
        {
            "intent": "AMAZON.HelpIntent"
        }
    ]
}
```
- Sample Utterances
```
MyBlogIsIntent my favorite blog is {blog}
WhatsMyBlogIntent what's my favorite blog
WhatsMyBlogIntent what is my favorite blog
WhatsMyBlogIntent what's my blog
WhatsMyBlogIntent what is my blog
WhatsMyBlogIntent my blog
WhatsMyBlogIntent my favorite blog
WhatsMyBlogIntent get my blog
WhatsMyBlogIntent get my favorite blog
WhatsMyBlogIntent give me my favorite blog
WhatsMyBlogIntent give me my blog
WhatsMyBlogIntent what my blog is
WhatsMyBlogIntent what my favorite blog is
WhatsMyBlogIntent yes
WhatsMyBlogIntent yup
WhatsMyBlogIntent sure
WhatsMyBlogIntent yes pleaseBlog
```

**Configuration**

![Configuration](./img/Configuration.jpeg)

Lambda Arn can be found in AWS CloudFormation outputs.

**Test**

![Test](./img/Test.jpeg)

"Service Simulator" should not be filled in.

**Publishing Information**

![Publishing Information](./img/Publishing_Information1.jpeg)
![Publishing Information](./img/Publishing_Information2.jpeg)

**Privacy & Compliance**

![Privacy & Compliance](./img/Privacy_Compliance.jpeg)

### Specify keywords

Open the web page url which can be found in AWS CloudFormation outputs and specify keywords which you would like Alexa to read.

### Alexa Simulator

You can test this Alexa Skill in your own Echo/Echo dot or using [echosim](https://echosim.io/welcome)
