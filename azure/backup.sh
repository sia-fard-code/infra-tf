#!/bin/sh
set -e
set -u
set -x

## Login with managed identity
az login -i

# Azure vars
APP_ENVIRONMENT='prod'
KEY_VAULT='kv-msn-common-global'
SECRET_KEY="mongo-${APP_ENVIRONMENT}"
STORAGE_ACCOUNT='stmsncommonglobal'
STORAGE_CONTAINER='mongodump'

# MongoDB vars
MONGO_USER=''
MONGO_PASS=$(az keyvault secret show --vault-name $KEY_VAULT --name $SECRET_KEY | jq -r .value)
MONGO_HOST=''
MONGO_PORT='27017'

# Backup vars
BACKUP_DIR='/tmp/mongodump'
BACKUP_FILE="${APP_ENVIRONMENT}-$(date -u +%Y%m%dT%H%M%S).tar.gz"

# Run backup
mkdir -p $BACKUP_DIR
mongodump -h $MONGO_HOST:$MONGO_PORT -u $MONGO_USER -p $MONGO_PASS --out=$BACKUP_DIR --oplog --quiet --authenticationDatabase=admin 

# Create archive
cd $BACKUP_DIR
tar -czf $BACKUP_FILE ./*

## Upload blob
az storage blob upload --auth-mode login --account-name $STORAGE_ACCOUNT --container-name $STORAGE_CONTAINER --file $BACKUP_FILE --name $BACKUP_FILE

# Cleanup
rm -rf $BACKUP_DIR
