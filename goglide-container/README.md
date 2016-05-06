# goglide-container

## Purpose
Creates a container with golang and adds the glide package manager.


## Versions
(Update Makefile and Dockerfile when versions need to change)

* golang 1.6 - set in Dockerfile FROM base image
* glide 0.10.2 - set in Dockerfile GLIDE_VERSION
* goglide (container) 0.0.2 - set in Makefile $VERSION

## Build
* docker-machine (or some form of docker) running.
* export DOCKER_REPO=<your target docker repo> e.g. quay.io/example
* make 
	* all - builds container image and stores in the local docker cache
	* clean - removes container image from local docker cache
	* push - push container image to $DOCKER_REPO/goglide:x.y.z
	
