# jenkins
Jenkins on GKE for COGS pipeline.

We are currently working with one (development) environment. Once we establish an enviroment setup, these scripts will need to be adapted.

### First time setup

Assumptions:
- The GCP project already exists and you have access to it.
- Billing has been setup.

#### Requirements

- [Install Cloud SDK](https://cloud.google.com/sdk/docs/quickstart) - used to manage Google Cloud resources and applications, e.g. using gcloud or gsutil.

    Follow the instructions to log in, select a project (you may need to ask the team about this), a default account and region (europe-west2-a).
- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

#### Set up defaults
Clone this repository and run the default setup:
 ```shell script
git clone git@github.com:GSS-Cogs/jenkins.git
cd jenkins
make set-defaults
```

##### Terraform Service Account
We need to authorise the terraform service account to access GCP by obtaining a key. You only need to do this **once**.
```shell script
make create-terraform-sa-key
```
It will create a ```.tf_secret.json``` file which you must guard with your life and selfishly keep from everyone.
**Do not share it**. No, not even in private repositories.

If you already have a file then you just need to activate the service account
```shell script
make activate-terraform-sa
``` 
If your key is in a different path, then use
```shell script
make TERRAFORM_SA_KEY="path-to-file" activate-terraform-sa
```

Then,
```shell script
export GOOGLE_APPLICATION_CREDENTIALS="[Path to json secret file]"
```
