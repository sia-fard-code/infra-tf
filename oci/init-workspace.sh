#!/bin/bash
set -euxo pipefail
if [ $# -ne 3 ]; then
  echo "usage: ${0} <aws-access-key> <aws-secret-key> <env>"
  exit 1
fi

aws_access_key="AKIA4TU3CRCVKZBTMBFQ"
aws_secret_key="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"


terraform_s3_bucket_name="com.masimo.msn.tf.non-prod"
key="com.masimo.safetynet.terraform"
region="us-west-1"

export TF_VAR_s3_backend_bucket_name="com.masimo.msn.tf.non-prod"
export TF_VAR_terraform_state_lock_table_name="com.masimo.safetynet.terraform"
export region="us-west-2"


init_backend() {
  terraform init -backend-config="access_key=${aws_access_key}" \
                 -backend-config="secret_key=${aws_secret_key}" \
                 -backend-config="bucket=${terraform_s3_bucket_name}" \
                 -backend-config="key=${key}" \
                 -backend-config="region=${region}"


  terraform workspace list
}

aws_access_key=$1
aws_secret_key=$2
env=$3

export TF_VAR_s3_backend_bucket_name="com.masimo.msn.tf.non-prod"
export TF_VAR_terraform_state_lock_table_name="com.masimo.safetynet.terraform"
export TF_VAR_region="us-west-2"

init_backend
