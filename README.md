# ubi-sonarqube
[![Docker Repository on Quay](https://quay.io/repository/davivcgarcia/ubi-sonarqube/status "Docker Repository on Quay")](https://quay.io/repository/davivcgarcia/ubi-sonarqube)

Unofficial image for SonarQube based on Red Hat Universal Base Image

## Why another image?

This image was build using the [Red Hat Universal Base Image (UBI) 8](https://developers.redhat.com/products/rhel/ubi/), which provides a stable foundation to workloads running on mission-critical environments, specially on **Red Hat OpenShift Container Platform**.

## How to use?

If you running standalone containers, you can use `podman` or `docker` with:

```bash
podman run -d -p 9000:9000 quay.io/davivcgarcia/ubi-sonarqube
```

If you running containers on OpenShift (or Kubernetes using Ingress instead of Router API), and have dynamic provisioning enabled, you can use `kubectl` or `oc` to deploy it redirectly from this repo:

```bash
oc apply -f https://raw.githubusercontent.com/davivcgarcia/ubi-sonarqube/master/resources/openshift.yaml
```

If you don't have dynamic provisioning for PersistentVolumes enabled and a default storage class, please checkout the resource template and make the required modifications before the deployment.

## How to configure?

If you are running it on OpenShift/Kubernetes, you will notice that the resource template is configured to use container volumes at `/opt/sonarqube/conf`, `/opt/sonarqube/data`, `/opt/sonarqube/logs` and `/opt/sonarqube/extensions`, mapped to `PersistentVolumes`.

By the default it uses `H2` as database, but the prefered way is to setup a PostgreSQL database and use it instead. To configure it, use the environment variables `SONARQUBE_JDBC_USERNAME`, `SONARQUBE_JDBC_PASSWORD` and `SONARQUBE_JDBC_URL`.

## Any support?

This is a community project, not backed nor supported by Red Hat.
