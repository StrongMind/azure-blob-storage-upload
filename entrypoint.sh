#!/bin/sh

set -e

## get args
container_name=$1
source_dir=$2
connection_string=$3
sas_token=$4
account_name=$5
extra_args=$6
sync=$7

if [ -z "$source_dir" ]; then
  echo "source directory is not set. Quitting."
  exit 1
fi

if [ -z "$container_name" ]; then
  echo "storage account container name is not set. Quitting."
  exit 1
fi

CONNECTION_METHOD=""

if ! [ -z "$connection_string" ]; then
  CONNECTION_METHOD="--connection-string $connection_string"
elif ! [ -z "$sas_token" ]; then
  if ! [ -z "$account_name" ]; then
    CONNECTION_METHOD="--sas-token $sas_token --account-name $account_name"
  else
    echo "account_name is required if using a sas_token. account_name is not set. Quitting."
    exit 1
  fi
else
  echo "either connection_string or sas_token are required and neither is set. Quitting."
  exit 1
fi

EXTRA_ARGS=""
if ! [ -z "$extra_args" ]; then
  EXTRA_ARGS=${extra_args}
fi

VERB="upload-batch"
CONTAINER_NAME_FLAG="--destination"
if [ -z "$sync" ]; then
  VERB="sync"
  CONTAINER_NAME_FLAG="--container"
fi

az storage blob ${VERB} ${CONNECTION_METHOD} --source ${source_dir} ${CONTAINER_NAME_FLAG} ${container_name} ${EXTRA_ARGS}
