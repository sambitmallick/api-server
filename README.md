# Python API Server with Minikube Deployment via Terraform

This project implements a Python-based API server that proxies data from [dummyjson.com](https://dummyjson.com) and deploys it on a local Minikube Kubernetes cluster using Terraform.

---

## Features

* `GET /api/products`: Paginated product list with `id`, `title`, and `description`.
* `GET /api/product/<id>`: Fetch a single product by ID with error handling.
* `GET /api/health`: Health check endpoint reflecting uptime status.
* Token-based authentication with `dummyjson.com`.
* Kubernetes deployment using Terraform (Secrets, ConfigMap, Deployment, Service).

---

## Project Structure

```
.
├── server/
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
└── terraform/
    ├── main.tf
    ├── variables.tf
    ├── terraform.tfvars
    ├── configmap.tf
    ├── secrets.tf
    ├── deployment.tf
    └── service.tf
```

---

## Step I: Build Docker Image

1. Point Docker to Minikube:

   ```sh
   eval $(minikube docker-env)
   ```

2. Build the Docker image:

   ```sh
   docker build -t api-webserver:latest ./server
   ```

---

## Step II: Environment Variables

Required environment variables (to be loaded via K8s):

* `DUMMY_USERNAME`
* `DUMMY_PASSWORD`
* `MAX_UPTIME_MINS`

These values are injected using:

* Kubernetes Secret (`test`)
* Kubernetes ConfigMap (`test`)

---

## Step III: Deploy with Terraform

1. Navigate to the Terraform directory:

   ```sh
   cd terraform
   ```

2. Initialize and apply the Terraform configuration:

   ```sh
   terraform init
   terraform apply -var-file="terraform.tfvars"
   ```

3. Access the service:

   ```sh
   minikube service test --url
   ```

---

## API Reference

| Endpoint                        | Description            |
| ------------------------------- | ---------------------- |
| `/api/products?limit=10&skip=5` | Get paginated products |
| `/api/product/<id>`             | Get product by ID      |
| `/api/health`                   | Check service health   |

---

## Tools Used

* Python 3.11 + Flask + Requests
* Docker
* Kubernetes (Minikube)
* Terraform
* dummyjson.com API

---

## Notes

* The application uses uptime to determine health status.
* K8s uses readiness and liveness probes to monitor the container.
* All secrets and configurations must be managed via Kubernetes objects.

---

## References

* [Minikube Local Image Guide](https://stackoverflow.com/a/42564211)
* [dummyjson.com API Docs](https://dummyjson.com/docs)
* [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest)

---

## License

This project is for educational purposes only.
