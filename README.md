# Ingress Default Backend

The Ingress Default Backend is a tool that is used for the [`nginx-ingress-controller`](https://github.com/kubernetes/ingress-nginx). It serves a static HTML page which is shown for all incoming requests to nginx that are not controlled by an Ingress object.

## How to build it?

:warning: Please don't forget to update the `$VERSION` variable in the `Makefile` before creating a new release:

```bash
$ make release
```

This will create a new Docker image with the tag you specified in the `Makefile`, push it to our image registry, and clean up afterwards.

## Example manifests

As the default backend is usually used in the context of the [`nginx-ingress-controller`](https://github.com/kubernetes/ingress-nginx), there weren't prepared any example manifests.
Please take a look at the [`values.yaml`](https://github.com/kubernetes/charts/blob/master/stable/nginx-ingress/values.yaml) file of the official [`nginx-ingress`](https://github.com/kubernetes/charts/tree/master/stable/nginx-ingress) Helm chart to understand how to include it.
