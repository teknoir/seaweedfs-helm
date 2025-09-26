# SeaweedFS Helm Chart

This chart deploys SeaweedFS to a Kubernetes cluster.

> The implementation of the Helm chart is right now the bare minimum to get it to work.

## Usage in Teknoir platform
Use the HelmChart to deploy the SeaweedFS to a Device.

```yaml
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: seaweedfs
  namespace: default
spec:
  repo: https://teknoir.github.io/seaweedfs-helm
  chart: seaweedfs
  targetNamespace: default
  valuesContent: |-
    # Example for minimal configuration
    
```

## Adding the repository

```bash
helm repo add teknoir-seaweedfs https://teknoir.github.io/seaweedfs-helm/
```

## Installing the chart

```bash
helm install seaweedfs teknoir-seaweedfs/seaweedfs -f values.yaml
```
