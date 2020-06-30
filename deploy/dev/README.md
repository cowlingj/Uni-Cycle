# Development Deployment

> SECRETS USED IN THIS MODULE ARE PUBLIC AND THEREFORE UNSUITABLE FOR PRODUCTION!

This module deploys an ecommerce store to a KinD cluster.
Supporting components including ingress controller, dashboard, and storage class are also deployed. 

It's possible to access the dashboard through `kubectl proxy` at the address [http://localhost:8001/api/v1/namespaces/kube-system/services/kubernetes-dashboard:http/proxy][http://localhost:8001/api/v1/namespaces/kube-system/services/kubernetes-dashboard:http/proxy].
The dashboard provides admin access to the enire cluster.
