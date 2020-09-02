#!/bin/sh
set -e

echo "preparing..."
export PROJECT_NAME=optimum-bonbon-257411
export GCLOUD_PROJECT=$(gcloud config get-value project)
export USER_ACCOUNT=$(gcloud config get-value account)

export INSTANCE_REGION=europe-west2
export INSTANCE_ZONE=europe-west2-a
export CLUSTER_NAME=jenkins
export TF_STATE_BUCKET="$PROJECT_NAME-tfstate"

echo "Setting '$PROJECT_NAME' as default project..."
gcloud config set project "$PROJECT_NAME" --no-user-output-enabled

echo "Setting '$USER_ACCOUNT' as account..."
gcloud config set account "$USER_ACCOUNT" --no-user-output-enabled

echo "Setting region..."
gcloud config set compute/region "$INSTANCE_ZONE" --no-user-output-enabled

echo "Setting zone..."
gcloud config set compute/zone "$INSTANCE_ZONE" --no-user-output-enabled

echo "Enabling required APIs..."
gcloud services enable compute.googleapis.com \
                       container.googleapis.com \
                       --project "$GCLOUD_PROJECT" --quiet


echo "Creating Terraform state bucket..."
gsutil mb -p "$PROJECT_NAME" gs://"$TF_STATE_BUCKET" || true
