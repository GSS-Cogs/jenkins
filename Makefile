PROJECT_ID := "optimum-bonbon-257411"
INSTANCE_REGION := europe-west2
INSTANCE_ZONE := "$(INSTANCE_REGION)-a"
TERRAFORM_SA_KEY := ".tf_secret.json"
TF_STATE_BUCKET := terraform-state-$(PROJECT_ID)
.PHONY: all

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


set-defaults: set-project set-region set-zone enable-apis create-terraform-sa

set-project: ## Set the project for the current session
	gcloud config set project $(PROJECT_ID)
	gcloud projects describe $(PROJECT_ID)

set-region: ## Set region for current session - default europe-west2
	gcloud config set compute/region $(INSTANCE_REGION)

set-zone: ## Set zone for current session - default europe-west2-a
	gcloud config set compute/zone $(INSTANCE_ZONE)

link-billing: ## TO DO - Set billing for project
	# todo

enable-apis: ## Enable APIs - compute and container
	gcloud services enable compute.googleapis.com \
                       container.googleapis.com \
                       --project $(PROJECT_ID) --quiet

unset-project: ## Unset project for current session
	gcloud config unset project

delete-project: ## Delete project, prompts user for confirmation
	gcloud projects delete $(PROJECT_ID)

create-terraform-sa: ## Create a new service account to be used with terraform - add viewer and storage roles
	gcloud iam service-accounts create terraform \
                            --project $(PROJECT_ID) \
                            --display-name "Terraform admin account" || true

	gcloud projects add-iam-policy-binding $(PROJECT_ID) \
							--member serviceAccount:terraform@$(PROJECT_ID).iam.gserviceaccount.com \
  							--role roles/viewer

	gcloud projects add-iam-policy-binding $(PROJECT_ID) \
							--member serviceAccount:terraform@$(PROJECT_ID).iam.gserviceaccount.com \
							--role roles/storage.admin

create-terraform-sa-key: ## Create and get service account key. Keep this file safe and DO NOT SHARE IT. You only need to do this once.
	gcloud iam service-accounts keys create $(TERRAFORM_SA_KEY) --iam-account "terraform@$(PROJECT_ID).iam.gserviceaccount.com"

activate-terraform-sa: ## Activate terraform service account.
	gcloud auth activate-service-account --key-file $(TERRAFORM_SA_KEY)

create-bucket: ## List current buckets and create storage bucket if it doesn't exist in the project
	@if ! gsutil ls | grep -w gs://$(TF_STATE_BUCKET) ; then \
		gsutil mb -p $(PROJECT_ID) -l $(INSTANCE_REGION) gs://$(TF_STATE_BUCKET); \
		gsutil versioning set on gs://$(TF_STATE_BUCKET); \
	else \
		echo "The bucket gs://$(TF_STATE_BUCKET) already exists"; \
	fi
