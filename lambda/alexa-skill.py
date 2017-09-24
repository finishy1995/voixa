#!/usr/bin/python
# -*- coding: utf8 -*-

from __future__ import print_function
import boto3
import re
import os
# Just for debug
import logging

# Hard code for Demo (Need to get alexa_id first and search user_id in DynamoDB)
USER_ID = 'test_user_uuid'
# DynamoDB table name for user subscribe information
TABLE_USER = 'user_subscribe'
# DynamoDB table name for news mapping
TABLE_NEWS = 'news'
# S3 bucket name for full news
S3_BUCKET = os.getenv('S3_BUCKET')
# S3 bucket name for text summarization
S3_SHORT_BUCKET = os.getenv('S3_SHORT_BUCKET')
# The words when we can not find the news which the user want
NEWS_NO_FOUND = 'Hahaha, according to Big Five Wolves, there is nothing new.'

# Lambda handler function
def lambda_handler(event, context):
    return download_blog_stack()

# Use user_id to get the user's subscribe (Site and keyword)
def get_site_keyword():
    client = boto3.client('dynamodb')
    
    response = client.scan(
        TableName = TABLE_USER,
        FilterExpression = "user_id = :user_id",
        ExpressionAttributeValues = {
            ":user_id": {"S": USER_ID}
        }
    )
    
    for key in response['Items'][0]['user_subscription']['M']:
        return [key, response['Items'][0]['user_subscription']['M'][key]['S']]

# Find one news match the user's subscribe
def check_keyword(keyword, text):
    m = re.search(keyword, text, re.I)
    if (not bool(m)):
        return False
        
    return True

# Main function to help alexa get the right blog and talk with the end user
def get_right_blog(contain):
    client = boto3.client('dynamodb')
    
    response = client.scan(
        TableName = TABLE_NEWS,
        FilterExpression = "site_id = :site_id",
        ExpressionAttributeValues = {
            ":site_id": {"S": contain[0]}
        }
    )
    
    s3 = boto3.client('s3')
    for i in range(0, response['Count']):
        result = s3.download_file(S3_BUCKET, response['Items'][i]['full_txt_loc']['S'], '/tmp/temp.txt')
        file = open('/tmp/temp.txt', 'r')
        text = file.read()
        
        if check_keyword(contain[1], text):
            result = s3.download_file(S3_SHORT_BUCKET, response['Items'][i]['short_txt_loc']['S'], '/tmp/short.txt')
            file = open('/tmp/short.txt', 'r')
            short_text = file.read()
            return short_text
    
    return NEWS_NO_FOUND

# Stack Response to alexa echo
def download_blog_stack():
    text = get_right_blog(get_site_keyword())
    
    card_title = "loading_new_blog"
    session_attributes = {"load": "Done"}
    should_end_session = True

    speech_output = text
    reprompt_text = "Done"
    
    return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))

# --------------- Helpers that build all of the responses ----------------------

def build_speechlet_response(title, output, reprompt_text, should_end_session):
    return {
        'outputSpeech': {
            'type': 'PlainText',
            'text': output
        },
        'card': {
            'type': 'Simple',
            'title': "SessionSpeechlet - " + title,
            'content': "SessionSpeechlet - " + output
        },
        'reprompt': {
            'outputSpeech': {
                'type': 'PlainText',
                'text': reprompt_text
            }
        },
        'shouldEndSession': should_end_session
    }


def build_response(session_attributes, speechlet_response):
    return {
        'version': '1.0',
        'sessionAttributes': session_attributes,
        'response': speechlet_response
    }
