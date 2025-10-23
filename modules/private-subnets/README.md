# VPC Private Subnets and Route Tables

This Terraform module creates **private subnets**, their **dedicated route tables**, and associates those route tables with **S3** and **DynamoDB VPC gateway endpoints** within an existing VPC.

---

## 🧩 Overview

### What it does
- Looks up an existing **VPC** by its `Name` tag  
- Creates one **private subnet per CIDR** provided in `private_subnet_cidrs`
- Creates one **route table per subnet**  
- Adds a **0.0.0.0/0** route pointing to the provided **Transit Gateway (TGW)**  
- Associates each route table with:
  - Its subnet  
  - The **S3** and **DynamoDB** VPC gateway endpoints discovered via `data.tf`

---

## 📁 Files

| File | Purpose |
|------|----------|
| `data.tf` | Looks up existing AWS resources (VPC, endpoints, region, AZs). |
| `variables.tf` | Declares all input variables (no defaults). |
| `main.tf` | Creates subnets, route tables, and endpoint associations. |
| `outputs.tf` | Exposes subnet names, CIDRs, and IDs. |

---

## ⚙️ Inputs

| Variable | Type | Description |
|-----------|------|-------------|
| `vpc_name` | `string` | Name tag of the existing VPC. |
| `private_subnet_cidrs` | `list(string)` | List of CIDRs to create (e.g. `["10.111.244.64/26", "10.111.244.128/26", "10.111.244.192/26"]`). |
| `tgw_id` | `string` | Transit Gateway ID used for the 0.0.0.0/0 route. |
| `tags` | `map(string)` | Common tags applied to all resources. |

---

## 📤 Outputs

| Output | Description |
|---------|-------------|
| `subnet_names_and_cidrs` | Map of subnet names to `{ name, cidr, id }` objects. |

Example output:
```hcl
subnet_names_and_cidrs = {
  "my-vpc-private-main-a" = {
    cidr = "10.111.244.64/26"
    id   = "subnet-0a1b2c3d"
    name = "my-vpc-private-main-a"
  }
  "my-vpc-private-main-b" = {
    cidr = "10.111.244.128/26"
    id   = "subnet-0e4f5a6b"
    name = "my-vpc-private-main-b"
  }
  ...
}
