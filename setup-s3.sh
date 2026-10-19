
#!/usr/bin/env bash
set -e

# Use the Region from this session, or fall back to your configured Region
REGION="${AWS_REGION:-$(aws configure get region)}"

# Get your AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export COURSE_BUCKET="online-store-assets-${ACCOUNT_ID}"

# Create the S3 bucket
if [ "$REGION" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "$COURSE_BUCKET" --region "$REGION"
else
    aws s3api create-bucket --bucket "$COURSE_BUCKET" \
        --region "$REGION" \
        --create-bucket-configuration LocationConstraint="$REGION"
fi

echo "Your course bucket: $COURSE_BUCKET (Region: $REGION)"
