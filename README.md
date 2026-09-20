# Production-Grade Terraform Lab

This is a hands-on Terraform project built to learn and practice infrastructure as code at a production level. It provisions real Azure infrastructure across two isolated environments — dev and staging — using reusable modules, remote state management, and fully automated CI/CD pipelines.

The goal was not just to get something running, but to build it the way a real engineering team would: clean module boundaries, no hardcoded values, state that lives in the cloud, and a pipeline that no one has to trigger manually on a normal day.

---

## What's Inside

The infrastructure is broken into reusable modules that both environments share:

- **Networking** — a Virtual Network and Subnet
- **Key Vault** — secrets management

Each environment (dev and staging) has its own configuration, its own state file, and deploys completely independently. Destroying staging won't touch dev. Changing dev won't affect staging.

---

## Project Structure

```
.
├── modules/
│   ├── networking/
│   └── keyvault/
├── envs/
│   ├── dev/
│   └── staging/
└── .github/
    └── workflows/
        ├── terraform-reusable.yml
        ├── terraform-dev.yml
        └── terraform-staging.yml
```

---

## Environments & Pipelines

Dev deploys automatically on every push to `main` and plans on every pull request. Staging is promoted manually — you trigger it from the Actions tab when you're ready.

Both pipelines share a single reusable workflow. The Terraform logic lives in one place; each environment just calls it with its own inputs.

Authentication to Azure uses OIDC — no passwords or keys stored anywhere. GitHub proves its identity to Azure cryptographically, and Azure issues a short-lived token in return.

---

## Running Locally

```bash
az login
cd envs/dev
terraform init
terraform plan
terraform apply
```

You'll need a `terraform.tfvars` file with your tenant ID, location, and environment name. That file is gitignored — it never touches the repo.

---

## Required GitHub Secrets

| Secret | What it is |
|---|---|
| `AZURE_CLIENT_ID` | The app registration that GitHub authenticates as |
| `AZURE_TENANT_ID` | Your Azure directory |
| `AZURE_SUBSCRIPTION_ID` | The subscription to deploy into |
