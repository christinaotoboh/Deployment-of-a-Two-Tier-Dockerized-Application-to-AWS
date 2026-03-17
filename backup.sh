#!/bin/bash

BACKUP_SOURCE="/some/path/on/your/host/all-databases.sql"
BACKUP_DEST="$HOME/backups" # S3 bucket link
DATE=$(date +%Y%m%d_%H%M%S)

# Validate source
if [ ! -d "$BACKUP_SOURCE" ]; then
    print_error "Source directory not found: $BACKUP_SOURCE"
    exit 1
fi


BACKUP_PATH="$BACKUP_DEST/$BACKUP_NAME"

 docker exec some-mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql # Replace the path with the S3bucket link

 echo " backup successful to the ${BACKUP_PATH}"