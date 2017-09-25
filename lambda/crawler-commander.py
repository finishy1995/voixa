#!/usr/bin/python
# -*- coding: utf8 -*-

import urllib2
import re
import time
import json
import boto3

MONTH_NAME = {'Jan':'01', 'Feb':'02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'}
# Create some detectors to get the news information
LAMBDA_NAME = 'voixa-crawler-detector'

# Check if the news is the latest
def check_day_time(str):
    # Just for test, change the match code!
    day_time = str.split(' ')
    now_time = time.strftime('%m-%d',time.localtime(time.time()))

    if ((MONTH_NAME.get(day_time[0], '00') == now_time[:2]) and (int(day_time[1]) == int(now_time[3:]) - 1)):
        return True
    
    return False

# Crawler news from AWS news page
def crawler_data_from_aws_news():
    url = r"https://aws.amazon.com/new/"
    groups_exp = r"directory-item text whats-new[\s\S]*?<\/tr>"
    daytime_exp = r"<td>[\s\S]*?<\/td>"
    newsurl_exp = r"\/\/aws.amazon.com[\s\S]*?\">"

    req = urllib2.Request(url)
    response = urllib2.urlopen(req)
    page_contents = response.read()

    groups = re.findall(groups_exp, page_contents, re.I)
    news = [];
    client = boto3.client('lambda') 
    
    for i in range(0, len(groups)):
        daytime = re.search(daytime_exp, groups[i], re.I).group(0)
        daytime = daytime[4:-5]

        if (check_day_time(daytime)):
            newsurl = re.search(newsurl_exp, groups[i], re.I).group(0)
            newsurl = newsurl[2:-2]
            newsurl = "https://" + newsurl

            flag = True
            for j in range(0, len(news)):
                if (news[j] == newsurl):
                    flag = False
                    break

            if (flag):
                news.append(newsurl)
                detector = {'url': newsurl}
                detector_json = json.dumps(detector, sort_keys=True, separators=(',', ': '))
                
                client.invoke(
                    FunctionName = LAMBDA_NAME,
                    InvocationType = 'Event',
                    Payload = detector_json
                )


def lambda_handler(event, context):
    crawler_data_from_aws_news()
