#! /usr/bin/env python3

import json
import csv
import gzip
import urllib.parse
import os
import logging
import boto3
from datetime import date

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')
s3_resource = boto3.resource('s3')
get_s3_bucket = os.getenv("S3_INVENTORY_BUCKET")

today = date.today()
t_date = today.strftime("%d-%m-%Y")


def get_manifest_files() -> list:
    manifest_file_list = list()
    for manifest_file in s3_client.list_objects(Bucket=get_s3_bucket)['Contents']:
        if 'json' in manifest_file['Key']:
            manifest_file_list.append(manifest_file['Key'])
    return manifest_file_list


def list_keys(query: str, s3_bucket: str, manifest_key: str):
    manifest = json.load(s3_resource.Object(s3_bucket, manifest_key).get()['Body'])
    for obj in manifest['files']:
        gzip_obj = s3_resource.Object(bucket_name=s3_bucket, key=obj['key'])
        buffer = gzip.open(gzip_obj.get()["Body"], mode='rt')
        reader = csv.reader(buffer)
        if query in reader:
            yield from reader


def upload_file_s3(source_s3_path: str, destination_s3_path: str, content_type: str) -> None:
    logger.info("uploading file")
    s3_resource.Bucket(get_s3_bucket).upload_file(source_s3_path,
                                                  destination_s3_path, ExtraArgs={'ContentType': content_type})
    logger.info("uploading file complete")


def lambda_handler(event, context):
    manifest_file_list = get_manifest_files()
    for filename in manifest_file_list:
        s3_path = "s3://" + get_s3_bucket + "/" + filename
        url = urllib.parse.urlparse(s3_path)
        # query everything and report
        with open(os.path.join('/tmp/', 'complete.csv'), 'a') as file:
            writer = csv.writer(file, delimiter='\t', lineterminator='\n', )
            query = ''
            for bucket, key, *rest in list_keys(query, url.hostname, url.path.lstrip('/')):
                row = [bucket, key, *rest]
                writer.writerow(row)
        # query everything for only non encrypted objects and report
        with open(os.path.join('/tmp/', 'encrypted.csv'), 'a') as file:
            writer = csv.writer(file, delimiter='\t', lineterminator='\n', )
            query = 'NOT-SSE'
            for bucket, key, *rest in list_keys(query, url.hostname, url.path.lstrip('/')):
                row = [bucket, key, *rest]
                writer.writerow(row)

    upload_file_s3("/tmp/complete.csv", "report/complete-inventory-report-" + t_date + ".csv", "text/csv")
    upload_file_s3("/tmp/encrypted.csv", "report/encrypted-inventory-report-" + t_date + ".csv", "text/csv")
