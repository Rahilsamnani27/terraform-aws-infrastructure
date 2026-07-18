.PHONY: init plan apply destroy fmt validate

init:
	terraform init

fmt:
	terraform fmt -recursive

validate: fmt
	terraform validate

plan: validate
	terraform plan -out=tfplan

apply:
	terraform apply tfplan

destroy:
	terraform destroy
