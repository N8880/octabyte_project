
# OctaByte DevOps Assessment Project

This project is part of a DevOps technical assessment provided by **Octa Byte AI Pvt Ltd**. The goal is to demonstrate infrastructure provisioning using Terraform, CI/CD automation using GitHub Actions, containerization, deployment to AWS EC2, and pushing Docker images to GitHub Container Registry (GHCR).

---

## 🚀 Project Overview

- **Cloud Provider**: AWS (EC2, VPC, Subnets, IGW, Security Groups)
- **CI/CD**: GitHub Actions
- **Infrastructure as Code**: Terraform
- **Containerization**: Docker
- **Image Registry**: GitHub Container Registry (GHCR)
- **App Type**: Simple Flask Application

---

## 📁 Project Structure

```
octabyte_project/
├── .github/workflows/docker-publish.yml   # CI/CD GitHub Action Workflow
├── docker-app/                            # Flask Application Source
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
├── main.tf                                # Terraform main configuration
├── variables.tf                           # Input variables
├── outputs.tf                             # Terraform outputs
├── terraform.tfvars                       # Variable values
├── terraform.tfstate                      # Terraform state file
├── README.md                              # Project documentation
```

---

## ⚙️ Terraform Setup

**Provision EC2 Instance and VPC**

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Preview the plan:
   ```bash
   terraform plan
   ```

3. Apply the infrastructure:
   ```bash
   terraform apply
   ```

Output includes:
- EC2 Public IP
- VPC ID
- Subnet IDs

---

## 🐳 Docker Setup (Local Build)

1. Navigate to `docker-app`:
   ```bash
   cd docker-app
   ```

2. Build Docker image locally:
   ```bash
   docker build -t octabyte_project .
   ```

3. Run container locally:
   ```bash
   docker run -d -p 80:80 octabyte_project
   ```

---

## 🔄 CI/CD with GitHub Actions

### `.github/workflows/docker-publish.yml`

This workflow:
- Triggers on every push to `main`
- Builds Docker image from `docker-app/`
- Pushes image to GHCR with tag `:latest`
- Signs the image using `cosign`

### Manual Trigger

To force a rebuild:
```bash
echo "vX" > docker-app/version.txt
git add docker-app/version.txt
git commit -m "Trigger rebuild vX"
git push origin main
```

---

## 📦 GHCR Image

You can pull the image using:

```bash
podman login ghcr.io -u <username> --password-stdin
podman pull ghcr.io/n8880/octabyte_project:latest
```

Replace `<username>` with your GitHub username and use a [Personal Access Token (PAT)](https://github.com/settings/tokens) as password.

---

## 🚀 Deploy on EC2

SSH into EC2:
```bash
ssh -i ~/.ssh/<your-key>.pem ec2-user@<public-ip>
```

Then pull and run container:

```bash
podman pull ghcr.io/n8880/octabyte_project:latest
podman run -d -p 80:80 ghcr.io/n8880/octabyte_project:latest
```

Access the Flask app via:
```
http://<EC2 Public IP>
```

---

## ✅ Final Deliverables

- [x] Terraform Provisioned Infra
- [x] EC2 + VPC + Public Subnets
- [x] Flask App in Docker
- [x] CI/CD GitHub Action to GHCR
- [x] Deployed image on EC2 using `podman`
- [x] Updated `README.md`

---

## 👤 Author

**Niranjan U**  
GitHub: [@N8880](https://github.com/N8880)

---

## 📝 License

This project is created for educational and assessment purposes only.
