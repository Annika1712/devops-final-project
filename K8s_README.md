# Orchestration with Kubernetes

## Kubernetes project infrastructure
After successfull configuration of [terraform](TERRAFORM_README.md) execute the commands:
'kubectl apply -f kubernetes'

This will create the storage class, ingress class and namespaces required for the CI/CD pipelines to properly execute.

## Orchestration with Kubernetes

The folders 'frontend','backend','mongodb', and 'redis' will be applied to kubernetes with every push to the repository.

### Installation for testing:

Important: you need Minikube or AWS EKS

In the root directory of the project execute the command:
```
cd kubernetes
```


Then you could create namespaces using the next `kubectl` command:
```
kubectl apply -f .\namespace.yml
```

Next step: deploy Redis:
```
kubectl apply -f .\redis\
```

Next step: deploy MongoDB:
```
kubectl apply -f .\mongodb\
```

Next step: deploy backend application:
```
kubectl apply -f .\backend\
```

Next step: setup value for NEXT_PUBLIC_API_URL in `.\frontend\10_config_map.yml`
Tip: run kubectl get svc --namespace=development and retrieve the external ip from backend. This is the value of NEXT_PUBLIC_API_URL

Next step: deploy frontend application:
```
kubectl apply -f .\frontend\
```

Useful commands:
```
kubectl get --namespace=development pods
kubectl get --namespace=development services
```