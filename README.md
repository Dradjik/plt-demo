# OpenTofu Demo Project with Scaleway

Dummy project for testing OpenTofu (`tofu`) against the Scaleway provider, with an
S3-compatible Scaleway backend. Two independent stacks share one `modules/` directory.

## Layout

```
.
├── modules/
│   ├── plt-demo/          # bucket + VM + instance IP + private network
│   └── plt-demo-drift/    # free resources only, built as drift targets
├── plt-demo/              # basic stack       → Scaleway project "plt-demo"
└── plt-demo-drift/        # drift-test stack  → Scaleway project "plt-demo-drift"
```

Scaleway projects are created **manually in the console**, one per stack, named after the
stack folder. You pass the project's ID as `scaleway_project_id`; the provider uses it as
the stack's default project and every resource is pinned to it, so nothing lands in your
default project. No organization ID is needed anywhere.

| Stack | Scaleway project | State bucket | State key | Cost |
|---|---|---|---|---|
| `plt-demo/` | `plt-demo` | `plt-demo-tf` | `plt-demo/terraform.tfstate` | billed (VM + flexible IP) — reference only, not meant to be applied |
| `plt-demo-drift/` | `plt-demo-drift` | `plt-demo-drift-tf` | `plt-demo-drift/terraform.tfstate` | free |

## Prerequisites

1. Install OpenTofu: https://opentofu.org/docs/intro/install/
2. Scaleway credentials — these two, and nothing else:
   ```bash
   export TF_VAR_scaleway_access_key="your-access-key"
   export TF_VAR_scaleway_secret_key="your-secret-key"
   ```
3. The stack's state bucket must exist in Scaleway Object Storage (`fr-par`) before
   `tofu init` — `plt-demo-tf` for `plt-demo/`, `plt-demo-drift-tf` for `plt-demo-drift/`.
4. Create the project for the stack in the Scaleway console — name it after the stack
   folder (`plt-demo` / `plt-demo-drift`) by convention — and put its ID in
   `terraform.tfvars` as `scaleway_project_id`.

## Usage

Run everything from inside a stack folder.

```bash
cd plt-demo-drift
cp terraform.tfvars.example terraform.tfvars   # set scaleway_project_id

tofu init
tofu plan
tofu apply
tofu destroy
```

### Credentials

Two different SDKs are in play, and by default they read different env vars:

| | Reads by default |
|---|---|
| `provider "scaleway"` | `SCW_ACCESS_KEY`, `SCW_SECRET_KEY` |
| `backend "s3"` (AWS SDK) | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` |

To avoid exporting both pairs, each stack passes the *same* two variables to both:

```hcl
backend "s3" {
  access_key = var.scaleway_access_key
  secret_key = var.scaleway_secret_key
}

provider "scaleway" {
  access_key = var.scaleway_access_key
  secret_key = var.scaleway_secret_key
}
```

Variables inside a `backend` block require **OpenTofu >= 1.8** (early variable
evaluation) — hence `required_version = ">= 1.8"`. Terraform cannot parse these stacks.

Two consequences worth knowing:

- The credential variables are **not** marked `sensitive`. OpenTofu refuses to initialize
  a backend whose config references sensitive values (`Backend config contains sensitive
  values`), so the marking has to be dropped for this to work at all.
- Because of that, the credentials are written to `.terraform/terraform.tfstate` and into
  any saved plan file. Both are gitignored — but don't hand a `tfplan` file to anyone.

## Drift testing

`plt-demo-drift` holds only free resources, all chosen because they are easy to mutate by
hand: VPC, private network, security group, placement group, object bucket, registry
namespace.

```bash
cd plt-demo-drift
tofu apply
# change something in the Scaleway console — e.g. open port 8080 on drift-security-group
tofu plan -detailed-exitcode   # 0 = no drift, 2 = drift, 1 = error
tofu apply                     # reconcile
```

Per-resource drift targets are commented in
[modules/plt-demo-drift/main.tf](modules/plt-demo-drift/main.tf).

## Notes

- All resources are tagged `Environment`, `ManagedBy=tofu`, `Project=<stack>`.
- Bucket names are globally unique across Scaleway, so they are **always** generated as
  `<stack>-<random-pet>` and cannot be overridden. The registry namespace name is also
  globally unique — leave it empty in `terraform.tfvars` to get the same treatment.
