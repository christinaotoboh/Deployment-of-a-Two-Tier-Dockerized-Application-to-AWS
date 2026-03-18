#!/bin/bash

echo "========================================"
echo        "Starting backup.sh script"
echo "========================================"

echo "Setting up environment variables"

set -e        # stop if anything fails
set -a        # start exporting variables
source .env   # load variables from .env
set +a        # stop exporting

DB_CONTAINER="ubuntu-db-1"
MYSQL_USER=${MYSQL_USER}                # mysql DB user
MYSQL_DATABASE=${MYSQL_DATABASE}        # mysql DB
MYSQL_PASSWORD=${MYSQL_PASSWORD}        # mysql Password
S3_BUCKET="s3://sca-devops"             # s3 bucket

# Create local Repository first to store the backup before uploading to s3
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="mysql-backup-${TIMESTAMP}.sql.gz" 
TEMP_DIR="/tmp"
FULL_BACKUP_PATH="$TEMP_DIR/$BACKUP_FILE"



# Run the docker exec to run the mysql dump
echo "================================================="
echo "Taking the mysql backup locally"
echo "================================================"

if 
docker exec "$DB_CONTAINER" sh -c \
 "exec mysqldump \
 --single-transaction --set-gtid-purged=OFF  --no-tablespaces  \
 -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE" | gzip > "$FULL_BACKUP_PATH"; then
 echo "Dump taken successfully"
else
echo "Dump not successful"
exit 1
fi

 
# Upload to s3 bucket
# I created an IAM role with an s3 bucket access, attached it to the EC2 Instance. This takes care of verification

echo "================================================"
echo                "Uploading to s3 bucket"
echo "================================================"

if aws s3 cp "$FULL_BACKUP_PATH" "$S3_BUCKET/"; then
echo "Upload to s3 was completed succesfully"

#Confirm if the backup file is in s3 bucket
    if aws s3 ls "$S3_BUCKET/$BACKUP_FILE" &>/dev/null; then
        echo "$BACKUP_FILE is in $S3_BUCKET"
    else
        echo "Upload seemed to succeed but file not found in bucket"
        exit 1
    fi    
else 
  echo "Upload FAILED"
    exit 1
fi


echo "=================================================="
echo " Upload completed"
echo "=================================================="
