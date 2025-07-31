# Simple SRE Demo

> Note: This repository is a personal demo, it is not meant to be followed for Production level software as it is based on  Github's and AWS' free tiers which have many limitations. Any user who makes use of it is responsible for double-checking the code, security, etc.

This repository allows deploying the Organization's main AWS infrastructure for a kubernetes based simple development team, namely EKS and its required IAM and networking components.

## Environment description

Since this demo uses free tiers for Github and AWS there are several limitations. Thus, this demo simulates a simple software development team which has only one development stage (i.e. `dev`).

## Github Organization structure

To deploy the infrastructure simply update and push the `aws_infra_config_vars.tfvars` file. The Github Actions pipeline will be triggered with a custom runner (see the repository [Github Actions custom runner](https://github.com/simple-sre-demo/github_actions_custom_runner)) that enables to perform Terraform commands which in turn will plan and apply the changes automatically.
