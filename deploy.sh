#!/bin/bash

echo '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::rob-skrob-demo/*"
        }
    ]
}' > /tmp/bucket_policy.json

SITE_BUCKET_NAME=rob-skrob-demo
SITE_REGION=us-east-1

aws s3api create-bucket --bucket $SITE_BUCKET_NAME --region $SITE_REGION \
  && aws s3api put-bucket-policy --bucket $SITE_BUCKET_NAME --policy file:///tmp/bucket_policy.json \
  && aws s3 sync ./src s3://$SITE_BUCKET_NAME/ \
  && aws s3 website s3://$SITE_BUCKET_NAME/ --index-document index.html 


echo http://$SITE_BUCKET_NAME.s3-website-$SITE_REGION.amazonaws.com/
