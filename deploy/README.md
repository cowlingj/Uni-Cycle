# Deploying the System

The system is deployed using terraform.

It can be deployed locally using the `dev` configurations or to production using the `prod` configurations.

## Dev

### Requirements

- Docker
- Kubernetes in Docker

### Configuration

The default users and strings in the CMS can be configured using a file placed in `./secrets/backend/keystone-cms.yaml`.

Sample `./secrets/backend/keystone-cms.yaml`:
```yaml
users:
  - username: jac,
    password: jac12345,
    isAdmin: true
string_values:
  - key: key-name
    value: value-name
```

### Results

A successful deployment should listen on `http://localhost:30080` and `https://localhost:30443` on the host machine.
Visiting `http://localhost:30080` will show an index of how to access variaous sources

## Prod

### Requirements

- AWS

### Configuration

The same configuration applies as with `dev`.
Additionally, terraform state for production deployments is stored remotely in s3 which needs to be configured on `terraform init`.
AWS environment variables will beed to be set in order to allow the AWs provider to work. (see [here](https://www.terraform.io/docs/providers/aws/index.html) for terraform + AWS specific environment variable config).

## Results

A successful deployment will be available at terraforms url output value (`terraform output url`).
The cluster can be accessed by authorised users using the generated kubeconfig (`terraform output kubeconfig`),
environment variables for AWS authentication must be set to access the cluster.
