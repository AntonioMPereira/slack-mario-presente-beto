#!/usr/bin/env bash
set -euo pipefail

export AWS_PROFILE="${AWS_PROFILE:-pessoal}"

echo "==> terraform init"
terraform init

echo "==> terraform apply"
terraform apply -auto-approve

BUCKET=$(terraform output -raw bucket_name)
echo "==> syncing site/ to s3://$BUCKET"
aws s3 sync site/ "s3://$BUCKET" --profile "$AWS_PROFILE" --delete

URL=$(terraform output -raw website_url)
echo ""
echo "========================================="
echo "  Site live at: $URL"
echo "========================================="
