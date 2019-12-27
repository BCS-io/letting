![Bcs.io](../docs/images/terraform_banner.svg)

## Terraform

[Terraform][1] is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

This code uses [Hetzner Cloud Provider][2] to interact with [Hetzner Cloud][3]

```
terraform
│
└───modules/hetzner
      │  data.tf
      │  main.tf
      │  outputs.tf
      │  variables.tf
      │
    project
      │
      └───.terraform
          │  terraform generated files
          └───terraform.tfstate.d/development
          │     terraform generated per workspace files
          │  hetzner_api.tf
          │  terraform.tfvars*
          │  terraform.tfvars.example
          │  variables.tf

* - required but missing
```

Terraform configuration manages a single server on Hetzner but it could work with any cloud, or any number of cloud, providers. It does this with only a few lines of configuration code.

For a single server configuration there should be no code change and only `terraform.tfvars` needs to have values set. The format can be seen in `terraform.tfvars.example`.

I haven't found how to structure Terraform properly - there is no best practice here! However, it's a few lines of code that save me a lot of time. Although part of a monorepo this was a convenience and with more experience it could be versioned and placed in it's own Repo.

### Associated scripts:
- bin/terraform - wrapper around terraform CLI
- bin/run - calls `bin/terraform` and updates the hosts file with ip address changes


[1]: https://www.terraform.io/intro/index.html
[2]: https://www.terraform.io/docs/providers/hcloud/index.html
[3]: https://www.hetzner.de/cloud
