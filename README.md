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

## TTL and Garbage Collection
SeaweedFS supports setting a Time-To-Live (TTL) for files, which determines how but it depends on volumes and scope of the TTL.
The TTL can be set when uploading files to SeaweedFS. Once the TTL expires, the files are marked for deletion and will be removed during the garbage collection process.
But as long as a volume keeps being written to, the garbage collection process will not delete files from that volume, even if their TTL has expired.
Tweaking the TTL value, volume size and the max number of volumes can help to achieve the desired balance between storage efficiency and data retention.
For example, setting a smaller volume size and a higher max number of volumes can lead to more frequent garbage collection cycles, which can help to free up space more quickly.
However, this can also lead to increased overhead and fragmentation, so it's important to find the right balance based on your specific use case and workload.

Here is an example on how these parameters can be set in the `values.yaml` file:

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
    master:
      volumeSizeLimitMB: 1000 # Set each volume size limit to 1000 MB

    volume:
      dataDirs:
        - name: data # The name of the default data volume
          type: "hostPath"
          maxVolumes: 300 # Maximum number of volumes to create
```