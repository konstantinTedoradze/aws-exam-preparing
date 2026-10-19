#!/usr/bin/env bash

# Use one Region for the whole learning plan. Run these two lines in each new
# terminal session you use, changing the Region if you prefer another one.
export AWS_REGION="us-east-1"
export AWS_DEFAULT_REGION="$AWS_REGION"

# Product catalog, used from the first API module onward. The category-index
# secondary index supports the category queries in the data and performance modules.
aws dynamodb create-table \
    --table-name Products \
    --attribute-definitions AttributeName=id,AttributeType=S AttributeName=category,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --global-secondary-indexes '[{
        "IndexName": "category-index",
        "KeySchema": [{"AttributeName": "category", "KeyType": "HASH"}],
        "Projection": {"ProjectionType": "ALL"}
    }]' \
    --billing-mode PAY_PER_REQUEST

# Customer records, used by the data masking examples
aws dynamodb create-table \
    --table-name Customers \
    --attribute-definitions AttributeName=customer_id,AttributeType=S \
    --key-schema AttributeName=customer_id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

# Customer orders, used by the authorization examples
aws dynamodb create-table \
    --table-name Orders \
    --attribute-definitions AttributeName=customer_id,AttributeType=S AttributeName=order_id,AttributeType=S \
    --key-schema AttributeName=customer_id,KeyType=HASH AttributeName=order_id,KeyType=RANGE \
    --billing-mode PAY_PER_REQUEST

# Event log, used by the event-driven workflow examples
aws dynamodb create-table \
    --table-name AnalyticsEvents \
    --attribute-definitions AttributeName=event_id,AttributeType=S \
    --key-schema AttributeName=event_id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

# Per-customer analytics, used by the role assumption examples
aws dynamodb create-table \
    --table-name CustomerAnalytics \
    --attribute-definitions AttributeName=customer_id,AttributeType=S \
    --key-schema AttributeName=customer_id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

# Wait until all five tables are ready
for table in Products Customers Orders AnalyticsEvents CustomerAnalytics; do
    aws dynamodb wait table-exists --table-name $table
done