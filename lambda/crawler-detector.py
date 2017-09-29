#!/usr/bin/python
# -*- coding: utf8 -*-

import urllib2
import re
import os
import time
import boto3

# S3 bucket name for full news 
WEBSITE_BUCKET = os.getenv('WEBSITE_BUCKET')
# DynamoDB table name for news mapping
TABLE_NAME = 'news'
# Hard code for Demo (Need to get from lambda event)
SITE = 'AWS-News'

# Get page information
def news_crawler(url):
    h1_exp = r"<h1[\s\S]*?<\/h1>"
    topic_exp = r"name=[\s\S]*?\">"
    
    req = urllib2.Request(url)
    response = urllib2.urlopen(req)
    page_contents = response.read()
    page_contents = re.search(r"<main[\s\S]*?<\/main>", page_contents, re.I).group(0)
    
    h1 = re.search(h1_exp, page_contents, re.I).group(0)
    topic = re.search(topic_exp, h1, re.I).group(0)
    topic = topic[6:-2]
    
    text_box_exp = r"=\"aws-text-box[\s\S]*?<\/div>"
    text_exp = r"p>[\s\S]*?<\/p>"
    
    text_box = re.findall(text_box_exp, page_contents, re.I)
    contain = topic.replace('_', ' ') + '.'
    for tr in text_box:
        text = re.findall(text_exp, tr)
        for tri in text:
            p_text = re.sub(r"<[\s\S]*?>", '', tri)
            p_text = p_text.replace("&nbsp;", " ")
            contain = contain + "\n" + p_text[2:]
    
    news_store_to_s3(topic[0:20], contain)

# Upload full news to S3 bucket
def news_store_to_s3(topic, contain):
    filename = '/tmp/data.txt'
    file = open(filename, 'w')
    file.write(contain)
    file.close()

    now_time = time.strftime('%y-%m-%d',time.localtime(time.time()))
    s3_filename = now_time[:2] + '/' + now_time[3:5] + '/' + now_time[6:8] + '/' + topic.replace(',', '_') + '-' + SITE + '.txt'

    s3 = boto3.resource('s3')
    s3.Bucket(WEBSITE_BUCKET).upload_file(filename, s3_filename)
    
    client = boto3.client('dynamodb')
    client.put_item(
        TableName = TABLE_NAME,
        Item = {
            'news_id': {
                'S': topic.replace(',', '_') + '-' + SITE
            },
            'site_id': {
                'S': SITE
            },
            'full_txt_loc': {
                'S': s3_filename
            }
        }
    )

def lambda_handler(event, context):
    news_crawler(event['url'])
