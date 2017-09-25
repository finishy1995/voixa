#!/bin/bash

#=============================================================================#
#   Voixa project bash script                                                 #
#   System Required:  Mac or Linux                                            #
#   Description: Install/Uninstall Voixa project into your aws account        #
#   Author: David Wang <david.wang@finishy.cn>                                #
#   Source: @finishy1995 <https://github.com/finishy1995>                     #
#=============================================================================#

# Current folder
cur_dir=`pwd`

# Source
source_file="voixa-0.8.1"
source_url="https://github.com/finishy1995/voixa/archive/v0.8.1.tar.gz"

# Whether root or not
is_root=false
[[ $EUID -eq 0 ]] && is_root=true

# Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

#=============================================================================#

# Print our infomation
print_info() {
    clear
    echo "###############################################################"
    echo "# Voixa                                                       #"
    echo "# System Required:  Mac or Linux                              #"
    if [[ $1 -eq "install" ]];then
    echo "# Description: Install Voixa project into your aws account    #"
    elif [[ $1 -eq "uninstall" ]];then
    echo "# Description: Uninstall Voixa project from your aws account  #"
    fi
    echo "# Author: Team Big-Five-Wolves                                #"
    echo "# Source: @finishy1995 <https://github.com/finishy1995>       #"
    echo "###############################################################"
    echo
}

# Download files and verify it
download() {
    local filename=${1}
    local cur_dir=`pwd`

    if [ -s ${filename} ]; then
        echo -e "[${green}Info${plain}] ${filename} [found]"
    else
        echo -e "[${green}Info${plain}] ${filename} not found, download now ..."
        wget --no-check-certificate -cq -t3 -T3 -O ${1} ${2}
        if [ $? -eq 0 ]; then
            echo -e "[${green}Info${plain}] ${filename} download completed."
        else
            echo -e "[${red}Error${plain}] Failed to download ${filename}, please download it to ${cur_dir} directory manually and try again."
            exit 1
        fi
    fi
}

# Handle S3 source bucket
aws_s3_source_bucket_handle() {
    # Create a new bucket
    bucket_create_flag=`aws s3api create-bucket --bucket ${1} --profile ${aws_profile} --region ${aws_region} --create-bucket-configuration LocationConstraint=${aws_region}`

    if [ "$bucket_create_flag" = "" ];then
        echo -e "[${red}Error${plain}] Failed to create bucket ${1}, please try another legal bucket name."

        rm -rf "${source_file}"
        rm -rf "${source_file}.tar.gz"
        exit 1
    fi

    # Upload source files
    cd "$cur_dir/$source_file/lambda"
    for i in `ls | grep ".zip"`
    do
        s3_file_upload=`aws s3 cp ${i} s3://${1}/lambda/ --profile ${aws_profile}`

        if [ "$s3_file_upload" = "" ];then
            echo -e "[${red}Error${plain}] Failed to upload files to bucket ${1}, please try again later."

            cd "$cur_dir"
            rm -rf "${source_file}"
            rm -rf "${source_file}.tar.gz"
            exit 1
        fi
    done
    cd ..
    s3_file_upload=`aws s3 cp aws-template-with-cognito s3://${1}/template/ --profile ${aws_profile}`
    if [ "$s3_file_upload" = "" ];then
        echo -e "[${red}Error${plain}] Failed to upload files to bucket ${1}, please try again later."

        cd "$cur_dir"
        rm -rf "${source_file}"
        rm -rf "${source_file}.tar.gz"
        exit 1
    fi
}

# Pre-installation download and setting
pre_install() {
    cd $cur_dir

    # Make sure that aws-cli <https://github.com/aws/aws-cli> has already been
    # installed, or we have shell root permission to install it automaticly
    echo -e "[${green}Info${plain}] Validating your aws-cli ..."
    result=`aws configure list`

    if [ "$result" = "" ] && [[ "$is_root" = "false" ]];then
        echo -e "[${red}Error${plain}] This script must be run as root, or needed aws-cli!"
        echo -e "You can go to <${green}https://github.com/aws/aws-cli${plain}> and install the latest version."
        exit 1
    elif [ "$result" = "" ];then
        echo -e "[${yellow}Warning${plain}] This script need to install aws-cli by 'pip'. If you have not installed 'pip', please do not try to install aws-cli."
        echo -e "Please enter your decision [Y, N]:"
        read -p "(Default decision: N):" aws_cli_install_dec
        [ -z "$aws_cli_install_dec" ] && aws_cli_install_dec="N"

        if [ "$aws_cli_install_dec" = "N" ] || [ "$aws_cli_install_dec" = "n" ] || [ "$aws_cli_install_dec" = "NO" ] || [ "$aws_cli_install_dec" = "No" ] || [ "$aws_cli_install_dec" = "no" ];then
            echo -e "You can go to <${green}https://github.com/aws/aws-cli${plain}> and install the latest version."
            exit 1
        elif [ "$aws_cli_install_dec" = "Y" ] || [ "$aws_cli_install_dec" = "y" ] || [ "$aws_cli_install_dec" = "YES" ] || [ "$aws_cli_install_dec" = "Yes" ] || [ "$aws_cli_install_dec" = "yes" ];then
            pip install awscli
        else
            exit 1
        fi
    else
        echo -e "[${green}Info${plain}] Validated successful."
    fi
    echo

    # Download the latest voixa package
    echo -e "[${green}Info${plain}] Download source package."
    download "${source_file}.tar.gz" "${source_url}"
    echo

    # Tar package and zip the lambda files
    tar zxf ${source_file}.tar.gz
    cd "${source_file}""/lambda"
    for i in `ls | grep ".py"`
    do
        echo $i
        zip "$i"".zip" "$i"
    done
    echo

    # AWS config, include profile and region setting
    echo -e "[${green}Info${plain}] AWS configuration setting ..."

    echo "Please choose your AWS configure profile name [aws_profile_name]:"
    read -p "(Default decision: default):" aws_profile
    [ -z "$aws_profile" ] && aws_profile="default"

    echo "Please choose your AWS configure region id [aws_region_id]:"
    read -p "(Default decision: us-east-1):" aws_region
    [ -z "$aws_region" ] && aws_region="us-east-1"

    echo -e "[${green}Info${plain}] AWS configuration setted."
    echo
}

# Environment-installation AWS CloudFormation stack create and other config
env_install() {
    cd $cur_dir

    # AWS CloudFormation install voixa environment
    cd $source_file

    echo -e "[${green}Info${plain}] AWS CloudFormation stack configuration ..."

    echo "Please enter your AWS CloudFormation stack name [stack_name]:"
    read -p "(Default decision: voixa):" aws_stack
    [ -z "$aws_stack" ] && aws_stack="voixa"

    current_time=`date +%Y%m%d`
    random_number=`echo $RANDOM`

    echo "Please enter your Amazon S3 bucket name for Voixa code, existing or not [aws_s3_bucket_name]:"
    read -p "(Default decision: voixa-project-source-{time}-{random_number}):" aws_s3_source_bucket
    [ -z "$aws_s3_source_bucket" ] && aws_s3_source_bucket="voixa-project-source-""$current_time""-""$random_number"
    aws_s3_source_bucket_handle $aws_s3_source_bucket

    echo "Please enter your Amazon S3 bucket name for Voixa full text files, must be not existing [aws_s3_bucket_name]:"
    read -p "(Default decision: voixa-project-full-txt-{time}-{random_number}):" aws_s3_full_txt_bucket
    [ -z "$aws_s3_full_txt_bucket" ] && aws_s3_full_txt_bucket="voixa-project-full-txt-""$current_time""-""$random_number"

    echo "Please enter your Amazon S3 bucket name for Voixa short text files, must be not existing [aws_s3_bucket_name]:"
    read -p "(Default decision: voixa-project-short-txt-{time}-{random_number}):" aws_s3_short_txt_bucket
    [ -z "$aws_s3_short_txt_bucket" ] && aws_s3_short_txt_bucket="voixa-project-short-txt-""$current_time""-""$random_number"

    echo "Please enter your Amazon S3 bucket name for Voixa static web files, must be not existing [aws_s3_bucket_name]:"
    read -p "(Default decision: voixa-project-static-web-{time}-{random_number}):" aws_s3_static_web_bucket
    [ -z "$aws_s3_static_web_bucket" ] && aws_s3_static_web_bucket="voixa-project-static-web-""$current_time""-""$random_number"

    echo -e "[${green}Info${plain}] AWS CloudFormation stack creating ... (It may take about 4 minutes)"

cf_response=`aws cloudformation create-stack --stack-name ${aws_stack} --template-url https://s3-${aws_region}.amazonaws.com/${aws_s3_source_bucket}/template/aws-template-with-cognito --profile ${aws_profile} --region ${aws_region} --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=FullNewsStoredBucketName,ParameterValue=${aws_s3_full_txt_bucket} ParameterKey=ShortNewsStoredBucketName,ParameterValue=${aws_s3_short_txt_bucket} ParameterKey=StaticWebBucketName,ParameterValue=${aws_s3_static_web_bucket} ParameterKey=SourceBucketName,ParameterValue=${aws_s3_source_bucket}`

    if [ "$cf_response" = "" ];then
        echo -e "[${red}Error${plain}] Failed to create stack, please try again later."

        cd "$cur_dir"
        rm -rf "${source_file}"
        rm -rf "${source_file}.tar.gz"
        exit 1
    fi

    sleep 240s
    # TODO: Add function to track stack when creating
    echo -e "[${green}Info${plain}] AWS CloudFormation stack created."
    echo

    # Set Lambda Trigger
    echo -e "[${green}Info${plain}] AWS Lambda trigger setting ..."

    lambda_text_summarization=`aws lambda get-function --function-name voixa-text-summarization --profile ${aws_profile} --region ${aws_region} --query Configuration.FunctionArn --output text`
    echo "{\"LambdaFunctionConfigurations\": [{\"LambdaFunctionArn\": \"${lambda_text_summarization}\",\"Events\": [\"s3:ObjectCreated:Put\"]}]}" > notification.json
    aws s3api put-bucket-notification-configuration --bucket ${aws_s3_full_txt_bucket} --notification-configuration file://notification.json --profile ${aws_profile}

    echo -e "[${green}Info${plain}] AWS Lambda trigger setted."
    echo

    # Upload Static web files
    echo -e "[${green}Info${plain}] Static web files uploading ..."
    cd "$cur_dir/$source_file/website"

    # Get cognito pool id
    for i in `aws cognito-identity list-identity-pools --max-results 10 --profile ${aws_profile} --output text --query IdentityPools --region ${aws_region}`
    do
        pool_name=`echo ${i} | cut -f 2`
        if [ "$pool_name" = "voixa_identity_pool" ];then
            aws_cognito_pool_id=`echo ${i} | cut -f 1`
            break
        fi
    done

    echo "const REGION = '${aws_region}';const POOL_ID = '${aws_cognito_pool_id}';" > ./js/config.js

    aws s3 cp ./ s3://${aws_s3_static_web_bucket}/ --recursive
}

out_install() {
    cd "$cur_dir"

    rm -rf "${source_file}"
    rm -rf "${source_file}.tar.gz"

    rm install.sh
}

# Install Voixa
install_voixa() {
    print_info "install"
    pre_install
    env_install
    out_install
}

#=============================================================================#

# Initialization step
action=$1
[ -z $1 ] && action=install
case "$action" in
    install|uninstall)
        ${action}_voixa
        ;;
    *)
        echo "Arguments error! [${action}] is not in our actions."
        echo "Usage: `basename $0` [install|uninstall]"
        ;;
esac
