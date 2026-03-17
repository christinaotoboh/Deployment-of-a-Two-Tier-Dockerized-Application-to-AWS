#!/bin/bash
DB_CONTAINER="mysql"
S3_BUCKET="https://us-east-1.console.aws.amazon.com/s3/buckets?region=us-east-1"

#Create timestamp for unique file names
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_ZIP="mysql-backup-${DATE}.sql.gz" 

# Temporary local path to store the backup before upload
TEMP_DIR="/tmp"
FULL_BACKUP_PATH="$TEMP_DIR/$BACKUP_ZIP"

echo "Starting MySQL database backup for $MYSQL_DATABASE in container $DB_CONTAINER..."


# Execute mysqldump inside the Docker container and pipe to gzip on the host
docker exec "$DB_CONTAINER" sh -c "exec mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE" | gzip > "$FULL_BACKUP_PATH"

if [[ $? == 0 ]]; then
    echo "Database dump created successfully: $FULL_BACKUP_PATH"
else
    echo "Error creating database dump. Exiting."
    exit 1
fi


# Use the AWS CLI to copy the file to S3
/usr/bin/aws s3 cp "$FULL_BACKUP_PATH" s3://"$S3_BUCKET"/"$BACKUP_ZIP"

if [[ $? == 0 ]]; then
    echo "Successfully uploaded to S3."
    # Optional: Remove the local backup file after successful upload
    rm "$FULL_BACKUP_PATH"
    echo "Removed local backup file."
fi

echo "Backup process completed."