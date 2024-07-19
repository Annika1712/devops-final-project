# Accessing your monitoring tools
After you've successfully run terraform you can access both Prometheus and Grafana to monitor you're EKS cluster.

To find the url on which your grafana and prometheus can be reached run: 'kubectl get svc -n monitoring'
The external ip is your url and take note of the port.

The default login for grafana is 'admin' with 'prom-operator' as password.

As a last step make sure you have the EKS dashboard with ID [17119](https://grafana.com/grafana/dashboards/17119-kubernetes-eks-cluster-prometheus/) imported and starred