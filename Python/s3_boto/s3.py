# pip install boto3

import boto3
import os

S3_BUCKET = "example"

'''
s3=boto3.client('s3', 'us-east-2',
                        aws_access_key_id="my_access_key",
                  aws_secret_access_key="my_secret_key")'''
                  
s3 = boto3.client('s3', 'us-east-2')

''' 
# list of objects in the bucket
result = s3.list_objects_v2(Bucket=S3_BUCKET, Delimiter='/*')
for r in result["Contents"]:
  print(r["Key"])
 
# download file to local directory from s3 bucket
s3.download_file(S3_BUCKET, 's3filename.txt', 'localfilename.txt')'''

# upload file from local directory to s3 bucket
with open('warning.txt', "rb") as f:
  s3.upload_fileobj(f, S3_BUCKET, 'security_warning.txt')
