# OpenTofu Demo Project with Scaleway

This is a dummy project for testing OpenTofu (`tofu`) commands with the Scaleway provider and backend.

## Prerequisites

1. Install OpenTofu: https://opentofu.org/docs/intro/install/
2. Scaleway account with:
   - Project ID
   - Access Key and Secret Key (for authentication)
   - S3-compatible bucket for state storage (create one in Scaleway Object Storage)

## Setup

1. **Configure Scaleway credentials:**
   ```bash
   export SCW_ACCESS_KEY="your-access-key"
   export SCW_SECRET_KEY="your-secret-key"
   export SCW_DEFAULT_PROJECT_ID="your-project-id"
   ```

2. **Create the state bucket:**
   - Go to Scaleway Console → Object Storage
   - Create a bucket named `tofu-state-bucket` (or update the bucket name in `main.tf`)
   - Note: The bucket must exist before running `tofu init`

3. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

4. **Update backend configuration:**
   - Edit `main.tf` and update the `backend "s3"` block with your actual bucket name
   - The endpoint should match your Scaleway region

## Usage

```bash
# Initialize OpenTofu (downloads providers, configures backend)
tofu init

# Plan the changes
tofu plan

# Apply the changes
tofu apply

# Destroy resources
tofu destroy
```

## Resources

This project creates:
- A Scaleway Object Storage bucket (for testing)
- A Scaleway Instance IP (for testing)

Both resources are tagged with `Environment=test` and `ManagedBy=tofu` for easy identification.

## Backend Configuration

The backend uses Scaleway's S3-compatible Object Storage API. Make sure:
- The bucket exists before running `tofu init`
- You have proper IAM permissions to read/write to the bucket
- The endpoint matches your region (e.g., `s3.fr-par.scw.cloud` for fr-par)

