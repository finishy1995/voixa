#!/usr/bin/python
# -*- coding: utf8 -*-

import boto3
import time
import re
Import os

# S3 bucket name for full news
WEBSITE_BUCKET = os.getenv('WEBSITE_BUCKET')
# S3 bucket name for text summarization
RESULT_BUCKET = os.getenv('RESULT_BUCKET')
# DynamoDB table name for news mapping
NEWS_TABLE = 'news'
# Hard code for Demo (Need to get different sites from DynamoDB)
SITE = 'AWS-News'
# Hard code for Demo (Depends on the text summarization algorithm)
NUM_OF_SENTENCES = 3

# Split a paragraph into sentences
def splitParagraphIntoSentences(paragraph):
    ''' break a paragraph into sentences
        and return a list '''
    import re
    # to split by multile characters

    #   regular expressions are easiest (and fastest)
    sentenceEnders = re.compile('[.!?]')
    sentenceList = sentenceEnders.split(paragraph)
    return sentenceList


# Text summarization module
def text_summarization(full_txt, num_of_sentences):
    short_txt = ""
    sentences = splitParagraphIntoSentences(full_txt)
    i = 0
    for sen in sentences:
        if i < num_of_sentences:
            short_txt += sen
            short_txt += "."
            i += 1
    return short_txt


# Entry point
def lambda_handler(event, context):
    # Step 1: get the key of the S3 object
    # Step 2: get the value of the S3 object (Q: How? Read from S3 directly?), which is the long text
    # Step 3: transform the long text to short text
    # Step 4: store the short text to a new S3 object
    # Step 5: store the short_txt_loc back to the corresponding news in DynamoDB
    #         (Q: how could I know the news ID?)
    
    s3 = boto3.resource('s3')
    ddb = boto3.client('dynamodb')
    
    
    # Step 1:
    s3_object_key = event['Records'][0]['s3']['object']['key']

    
    # Step 2:
    local_file = '/tmp/full.txt' 
    s3.Bucket(WEBSITE_BUCKET).download_file(s3_object_key, local_file)
    
    
    file = open(local_file, 'r')
    full_txt = file.read()
    file.close()
    
    
    # Step 3:
    short_txt = text_summarization(full_txt, NUM_OF_SENTENCES)
    
    
    # Step 4:
    s3.Bucket(RESULT_BUCKET).put_object(Key=s3_object_key, Body=short_txt)

    # Step 5:
    response = ddb.put_item(
        TableName=NEWS_TABLE,
        Item = {
            "news_id" : {
                'S': s3_object_key[9:].strip(".txt")
            },
            "full_txt_loc" : {
                'S': s3_object_key
            },
            "short_txt_loc" : {
                'S': s3_object_key
            },
            "site_id": {
                'S': "AWS-News"
            }    
        }
    )
    
