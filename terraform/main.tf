terraform {
  required_providers {
    openai = {
      source = "skyscrapr/openai"
    }
  }
}

data "hcp_vault_secrets_app" "openai" {
  app_name = "openai"
}

provider "openai" {
  api_key = data.hcp_vault_secrets_app.openai.secrets["api_key"]
}

resource "openai_file" "training_file" {
  filepath = "sport2_prepared_train.jsonl"
}

resource "openai_file" "validation_file" {
  filepath = "sport2_prepared_valid.jsonl"
}

resource "openai_finetuning_job" "example" {
  training_file                  = openai_file.training_file.id
  validation_file                = openai_file.validation_file.id
  model                          = "ada"
  wait                           = true
}

output fine_tuned_model {
  value = openai_finetuning_job.example.fine_tuned_model
}