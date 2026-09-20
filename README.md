# Production-Grade Terraform Lab

A hands-on Terraform learning project covering all core concepts — from fundamentals to CI/CD automation — using Azure as the cloud provider.

---

## What This Project Covers

| Phase | Topic |
|---|---|
| 1 | HCL syntax, providers, resources, init/plan/apply/destroy |
| 2 | Remote state with Azure Blob Storage, state locking, drift detection |
| 3 | Variables, outputs, tfvars, the moved block |
| 4 | Modules, implicit dependencies, module composition |
| 5 | Multi-environment structure, state isolation, terraform import |
| 6 | CI/CD with GitHub Actions, OIDC authentication, reusable workflows |

---

## Project Structure

```
.
├── modules/                        # Shared, reusable modules
│   ├── networking/                 # Virtual Network + Subnet
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── keyvault/                   # Azure Key Vault
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── envs/                           # Environment-specific configuration
│   ├── dev/
│   │   ├── main.tf                 # Calls shared modules, configures backend
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars        # Not committed — contains sensitive values
│   └── staging/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars        # Not committed — contains sensitive values
│
└── .github/
    └── workflows/
        ├── terraform-reusable.yml  # Shared pipeline logic (init, plan, apply)
        ├── terraform-dev.yml       # Triggers on push/PR to main → deploys dev
        └── terraform-staging.yml   # Manual trigger only → deploys staging
```

---

## Infrastructure

Each environment provisions:

- **Resource Group** — logical container for all resources
- **Virtual Network** — isolated private network (`10.0.0.0/16`)
- **Subnet** — subdivision of the VNet (`10.0.1.0/24`)
- **Key Vault** — secrets management

State for each environment is stored in a dedicated file in Azure Blob Storage:

```
tfstate/
├── dev.terraform.tfstate
└── staging.terraform.tfstate
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- An Azure subscription
- A GitHub account

---

## Local Setup

**1. Authenticate with Azure:**
```bash
az login
```

**2. Create a `terraform.tfvars` file in the environment folder:**
```hcl
tenant_id   = "<your-tenant-id>"
location    = "northeurope"
environment = "dev"
```

Get your tenant ID with:
```bash
az account show --query tenantId -o tsv
```

**3. Initialise and apply:**
```bash
cd envs/dev
terraform init
terraform plan
terraform apply
```

**4. Tear down:**
```bash
terraform destroy
```

---

## CI/CD Pipeline

### How it works

| Event | Pipeline | Action |
|---|---|---|
| Push to `main` | `terraform-dev.yml` | plan + apply dev |
| Pull request to `main` | `terraform-dev.yml` | plan only |
| Manual trigger (Dev) | `terraform-dev.yml` | plan + apply dev |
| Manual trigger (Staging) | `terraform-staging.yml` | plan + apply staging |

### Authentication

The pipeline authenticates to Azure via **OIDC** — no passwords or keys stored in GitHub. GitHub proves its identity cryptographically and Azure accepts it via a pre-configured federated identity credential.

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `AZURE_CLIENT_ID` | App registration client ID |
| `AZURE_TENANT_ID` | Azure AD tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Target Azure subscription ID |

### Setting up OIDC (one-time)

```bash
# Create app registration
az ad app create --display-name "terraform-lab-github"

# Create service principal
az ad sp create --id <app-id>

# Grant Contributor access to subscription
az role assignment create \
  --assignee <app-id> \
  --role Contributor \
  --scope /subscriptions/<subscription-id>

# Add federated credentials for each environment
az ad app federated-credential create \
  --id <object-id> \
  --parameters '{
    "name": "github-actions-env-dev",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:<owner>/<repo>:environment:dev",
    "audiences": ["api://AzureADTokenExchange"]
  }'
```

---

## Key Concepts

**Remote state** — `terraform.tfstate` lives in Azure Blob Storage, not on your laptop. Enables team collaboration and state locking.

**State isolation** — each environment has its own state file. Destroying staging cannot affect dev.

**Modules** — reusable, self-contained units of infrastructure. The same networking and Key Vault modules serve both dev and staging.

**Reusable workflow** — `terraform-reusable.yml` contains the shared pipeline logic. Each environment workflow calls it with different inputs — no duplication.

**OIDC authentication** — the pipeline authenticates to Azure without stored credentials. GitHub and Azure establish trust via federated identity.
