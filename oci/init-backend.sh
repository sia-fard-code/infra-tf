#!/bin/bash
set -euxo pipefail
if [ $# -ne 2 ]; then
  echo "usage: ${0} <aws-access-key> <aws-secret-key>"
  exit 1
fi

init_backend() {
  terraform init
  terraform apply -var aws-access-key="${aws_access_key}" -var aws-secret-key=${aws_secret_key}
}

aws_access_key=$1
aws_secret_key=$2
export TF_VAR_s3_backend_bucket_name="com.masimo.msn.tf.non-prod"
export TF_VAR_terraform_state_lock_table_name="com.masimo.safetynet.terraform"
export TF_VAR_region="us-west-1"
init_backend
