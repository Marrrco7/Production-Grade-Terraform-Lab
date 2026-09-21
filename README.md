# Production-Grade Terraform Lab

A hands-on Terraform project provisioning real Azure infrastructure across two isolated environments — dev and staging — using reusable modules, remote state, and fully automated CI/CD pipelines.

Built to cover every core Terraform concept a real engineering team uses day-to-day.

---

## What's Inside

- **Networking module** — Virtual Network, multiple subnets driven by `for_each`, and a Network Security Group with security rules generated via `dynamic` blocks
- **Key Vault module** — secrets management with `prevent_destroy` to guard against accidental deletion
- **Three environments** — dev, staging, and prod, each with isolated state and independent pipelines
- **CI/CD** — GitHub Actions with OIDC authentication (no stored secrets) and a reusable workflow shared across environments

---

## Concepts Covered

| Concept | Where |
|---|---|
| Providers, resources, init / plan / apply | Throughout |
| Remote state with Azure Blob Storage | `backend "azurerm"` in each env |
| State locking (blob lease) | Automatic on every operation |
| `terraform import` | Used during env restructuring |
| `moved {}` block | Rename resources without destroy |
| Variables, outputs, locals | Every module |
| `terraform.tfvars` (gitignored) | Per-environment secret values |
| Modules with explicit variable passing | `modules/networking`, `modules/keyvault` |
| `for_each` with `map(object)` | Multiple subnets from a variable map |
| `dynamic` blocks | NSG security rules driven from a list |
| `lifecycle` rules (`prevent_destroy`, `ignore_changes`) | Key Vault and VNet |
| Multi-environment structure with isolated state | `envs/dev`, `envs/staging`, `envs/prod` |
| Reusable GitHub Actions workflow | Single workflow, called per environment |
| OIDC authentication | Federated credentials, no stored secrets |

---

## Project Structure

```
.
├── modules/
│   ├── networking/       # VNet, subnets (for_each), NSG (dynamic rules)
│   └── keyvault/         # Key Vault with prevent_destroy
├── envs/
│   ├── dev/              # Auto-deploys on push to main
│   ├── staging/          # Promoted manually via workflow_dispatch
│   └── prod/             # Promoted manually via workflow_dispatch
└── .github/
    └── workflows/
        ├── terraform-reusable.yml
        ├── terraform-dev.yml
        ├── terraform-staging.yml
        └── terraform-prod.yml
```

---

## What a Production Setup Would Also Have

This lab covers the core. A real team would typically add:

- **`data` sources** — read existing infrastructure instead of hardcoding IDs
- **Variable validation blocks** — reject bad inputs before plan runs
- **Drift detection** — scheduled pipeline that plans and alerts on unexpected changes
- **Module versioning** — private registry with semver, environments pinned to specific versions
- **Policy-as-code** — Sentinel or OPA to enforce guardrails (e.g. no public IPs, mandatory tags)
