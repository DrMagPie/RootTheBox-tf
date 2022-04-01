#! /bin/bash

cd /opt/RootTheBox
aws s3 cp *.db s3://${BUCKET}/bkp/
aws s3 cp --recursive files s3://${BUCKET}/bkp/files
