data terraform_remote_state "main" {
  backend = "gcs"
  config = {
    bucket = "terraform-state-optimum-bonbon-257411"
  }
}

provider "kubernetes" {
  load_config_file = false

  host = "https://${data.terraform_remote_state.main.outputs.public_endpoint}"
}
