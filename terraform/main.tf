terraform {
  required_providers {
    openai = {
      source = "skyscrapr/openai"
    }
  }
}

provider "openai" {
  # api_key = data.hcp_vault_secrets_secret.openai.secrets["api_key"]
}

resource "openai_file" "training_file" {
  filepath = "recipe_training.jsonl"
}

# resource "openai_file" "validation_file" {
#   filepath = "recipe_validation.jsonl"
# }

resource "openai_finetuning_job" "example" {
	training_file                  = openai_file.training_file.id
	# validation_file                = openai_file.validation_file.id
	model                          = "gpt-4.1-nano-2025-04-14"
	wait = true
}

output fine_tuned_model {
  value = openai_finetuning_job.example.fine_tuned_model
}