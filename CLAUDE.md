# plt-demo

Demo/throwaway repo for testing OpenTofu against Scaleway. Nothing here is production.

## Ignore env files

- **Never read, open, `cat`, grep, or edit any file ending in `.env`** — `.env`,
  `plt-demo-drift.env`, `foo.env`, at any depth. They hold Scaleway credentials.
  Also covers `.env.*` variants (`.env.local`, `.env.prod`).
- Same for `*.tfvars` and any `creds*.sh` — treat them as secret and out of scope.
- Never print credential values (`TF_VAR_scaleway_access_key`,
  `TF_VAR_scaleway_secret_key`, `scaleway_project_id`) in output, plans, or commits.
- If a task seems to need something from an env file, ask for the value instead of reading it.

## Terraform/OpenTofu commands: keep it short

This is a demo — answer with the command, not an essay.

- Give the bare command, one line. No preamble, no walkthrough of what `init`/`plan`/`apply` do.
- Skip warnings about cost, state locking, or "make sure you review the plan" unless something is actually destructive.
- Explain only when asked, or when a command would delete real resources.

Good: `cd plt-demo-drift && tofu plan -detailed-exitcode`
Not: three paragraphs on exit-code semantics.

Never echo `TF_VAR_scaleway_access_key` / `TF_VAR_scaleway_secret_key` values in a command
you print — reference the variable, never the literal.

## Credentials

- `TF_VAR_scaleway_access_key` / `TF_VAR_scaleway_secret_key` are the **only** credentials
  the user exports. Never tell them to also export `SCW_*` or `AWS_*`.
- Both the `scaleway` provider and the `s3` backend read those same two variables, so
  there is nothing to duplicate. This needs OpenTofu >= 1.8 (early variable evaluation in
  backend blocks); `required_version` is pinned accordingly and Terraform won't work.
- **`scaleway_access_key` / `scaleway_secret_key` must NOT be marked `sensitive`.**
  OpenTofu hard-errors with `Backend config contains sensitive values` at init. If you
  "helpfully" add `sensitive = true`, both stacks stop initializing.
- Consequence: creds land in `.terraform/terraform.tfstate` and in saved plan files. Both
  are gitignored — keep it that way, and never `cat` a plan file into output.
- Run `tofu` from inside a stack folder. There is no wrapper script.

## Layout

Two independent stacks, one shared `modules/`. The binary is `tofu`, not `terraform`.

```
modules/plt-demo/         # bucket + VM + instance IP + private network
modules/plt-demo-drift/   # free resources only, built as drift targets
plt-demo/                 # basic stack      → Scaleway project "plt-demo"
plt-demo-drift/           # drift-test stack → Scaleway project "plt-demo-drift"
```

- **Always `cd` into a stack folder first.** There is no root-level Terraform config.
- **Scaleway projects are created manually in the console**, never by tofu. Don't add a
  `resource "scaleway_account_project"` or a data-source lookup.
- The project is identified **only** by `var.scaleway_project_id`, set in
  `terraform.tfvars`. There is deliberately no `organization_id` and no project-name
  lookup anywhere — don't reintroduce either.
- The provider sets `project_id`, and every resource in the modules also sets
  `project_id` explicitly. Keep both.
- Backend: bucket `plt-demo-tf`, region `fr-par`, key `<stack>/terraform.tfstate`.

## Conventions

- New resources go in the matching module, wired through variables — don't add resources
  to a stack's `main.tf`. The stack layer is for the project, the backend, and unique names.
- Add outputs to both the module's `outputs.tf` and the stack's `outputs.tf` if they
  should surface.
- `plt-demo` is reference only and is never applied — it keeps the billed VM/IP on purpose.
- `plt-demo-drift` must stay free. Don't add billed resources (VMs, flexible IPs, RDB,
  public gateways, load balancers) to it.
- Don't commit `terraform.tfvars`, state files, or `.terraform/`.
