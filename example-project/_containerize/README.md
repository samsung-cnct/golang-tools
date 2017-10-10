Build docker container version of the app, that is runnable on kubernetes.

The go app:  example-linux  needs to be copied into this directory so the Dockerfile will find it.

This example assumes the app need a kubernetes access certificate in this directory:  ca-certificates.crt
