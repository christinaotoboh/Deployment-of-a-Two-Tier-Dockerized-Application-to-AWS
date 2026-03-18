#!/bin/bash
set -e        # stop if anything fails
set -a        # start exporting variables
source .env   # load variables from .env
set +a        # stop exporting
DB_CONTAINER="ubuntu-db-1"
MYSQL_USER=${MYSQL_USER}
MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_PASSWORD=${MYSQL_PASSWORD}

#
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="mysql-backup-${TIMESTAMP}.sql.gz" 
TEMP_DIR="/tmp"
FULL_BACKUP_PATH="$TEMP_DIR/$BACKUP_FILE"

docker exec "$DB_CONTAINER" sh -c \
 "exec mysqldump \
 --single-transaction --set-gtid-purged=OFF --set-gtid-purged=OFF \
 -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE" | gzip > "$FULL_BACKUP_PATH"

