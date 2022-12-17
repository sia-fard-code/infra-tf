#!/bin/bash
set -euxo pipefail
if [ $# < 4 ]; then
  echo "usage: ${0} <aws-access-key> <aws-secret-key> <env-type> <deploy-type> <tf-workspace>"
  exit 1
fi
init_backend() {
  rm -fr $1/.terraform
  terraform -chdir=$1 init -backend-config="region=us-west-2" -backend-config="access_key=${aws_access_key}" -backend-config="secret_key=${aws_secret_key}"  -backend-config="workspace_key_prefix=aws" -backend-config="bucket=com.masimo.msn.tf.${env_type}" -backend-config="dynamodb_table=com.masimo.msn.tf.${env_type}" -backend-config="key=$1.tfstate" -upgrade
  terraform -chdir=$1 workspace list
  if [[ ${tf_workspace} != "" ]]; then
        terraform -chdir=$1 workspace select ${tf_workspace}
  fi
}

aws_access_key=$1
aws_secret_key=$2
env_type=$3
deploy_type=$4
tf_workspace=${5:-""}

if [[ $4 == "all" ]]; then
  init_backend "common"
  init_backend "blue"
  init_backend "green"
else
  init_backend $4
fi
