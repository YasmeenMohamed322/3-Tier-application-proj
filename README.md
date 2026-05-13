# 3-Tier Web Application Deployment on AWS

## Project Overview

This project demonstrates the deployment of a scalable and highly available **3-Tier Web Application Architecture** on AWS using **Terraform** for Infrastructure as Code (IaC) and **Ansible** for configuration management and automation.

The infrastructure follows the standard 3-tier architecture:

* **Presentation Layer (Frontend)**
* **Application Layer (Backend)**
* **Database Layer (PostgreSQL RDS)**

The deployment includes networking, load balancing, auto scaling, security groups, bastion host access, and automated provisioning.

---

# Architecture
![Full Architecture]("Terraform & Ansible proj infra.png")

## 1. Presentation Layer

* Frontend application servers
* Public-facing Application Load Balancer (ALB)
* Auto Scaling Group
* Hosted inside public subnets

## 2. Application Layer

* Backend application servers
* Internal Application Load Balancer
* Auto Scaling Group
* Hosted inside private subnets

## 3. Database Layer

* Amazon RDS PostgreSQL
* Private subnets only
* Accessible only from backend instances

---

# Features

* Infrastructure as Code using Terraform
* Configuration Management using Ansible
* High Availability across multiple Availability Zones
* Public and Private subnet separation
* NAT Gateway for private subnet internet access
* Bastion Host for secure SSH access
* Auto Scaling Groups for frontend and backend
* Application Load Balancers
* Security Group isolation between tiers
* PostgreSQL RDS deployment
* Reusable Terraform modules

---

# Technologies Used

## Cloud Platform

* AWS

## Infrastructure as Code

* Terraform

## Configuration Management

* Ansible

## Compute

* EC2
* Auto Scaling Groups

## Networking

* VPC
* Public & Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables

## Load Balancing

* Application Load Balancer (ALB)

## Database

* Amazon RDS PostgreSQL

## Security

* Security Groups
* Bastion Host
* SSH Key Pair

---

# Project Structure

```bash
project/
│
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── alb/
│   ├── rds/
│   └── bastion/
│
├── ansible/
│   ├── group_vars
│   ├── inventory.aws_ec2.yml
│   ├── playbook.yaml
│   └── roles/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
```

---

# Infrastructure Components

## Networking Layer

* Custom VPC
* 2 Public Subnets
* 2 Private Subnets
* Internet Gateway
* NAT Gateways
* Public & Private Route Tables

## Compute Layer

### Frontend

* EC2 Auto Scaling Group
* Public ALB

### Backend

* EC2 Auto Scaling Group
* Internal ALB

## Database Layer

* PostgreSQL RDS
* Private subnet deployment

## Management Layer

* Bastion Host for secure SSH access
* Ansible automation server

---

# Security Architecture

| Component    | Access              |
| ------------ | ------------------- |
| Frontend ALB | Internet            |
| Frontend EC2 | Frontend ALB        |
| Backend EC2  | Frontend Tier       |
| Database     | Backend Tier        |
| Bastion Host | SSH from trusted IP |

---

# Terraform Modules

## VPC Module

Responsible for:

* VPC creation
* Subnets
* Route tables
* NAT Gateway
* Internet Gateway
* Security Groups

## EC2 Module

Responsible for:

* Launch Templates
* Auto Scaling Groups
* EC2 instances

## ALB Module

Responsible for:

* Load Balancers
* Target Groups
* Listeners
* Health Checks

## RDS Module

Responsible for:

* PostgreSQL deployment
* DB subnet groups
* Database security

## Bastion Module

Responsible for:

* Bastion host deployment
* Secure SSH access

---

# Deployment Steps

## Note: Set Hashicorp Vault server with access_key and secret_key secrets in secret/aws path.

## 1. Initialize Terraform

```bash
terraform init
```

## 2. Validate Configuration

```bash
terraform validate
```

## 3. Review Execution Plan

```bash
terraform plan
```

## 4. Deploy Infrastructure

```bash
terraform apply
```

---

# Ansible Configuration

After infrastructure deployment:

## Configure Servers

```bash
ansible-playbook -i inventory.aws_ec2.yml playbook.yml
```

Ansible is used to:

* Install required packages
* Configure frontend/backend services
* Automate server setup
* Deploy applications

---

# High Availability

The architecture ensures high availability by:

* Deploying resources across multiple AZs
* Using Auto Scaling Groups
* Using Load Balancers
* Isolating tiers in separate subnets

---

# Learning Outcomes

Through this project, the following concepts were implemented and practiced:

* AWS Cloud Infrastructure
* Infrastructure as Code
* DevOps Automation
* Terraform Modules
* Networking & Security
* High Availability Design
* Linux Administration
* Configuration Management using Ansible

---

# Contributors
- Aiysha Abdelwahid
- Romaysaa Samy
- Tasneem Adel
- Yasmeen Mohamed


