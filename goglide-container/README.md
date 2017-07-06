# goglide-container

## Purpose
Creates a container with golang and adds the [glide package manager](https://github.com/Masterminds/glide).
Also sets the container uid:gid.


## Versions
(Update Makefile and Dockerfile when versions need to change)

* golang 1.8.3 - set in Dockerfile FROM base image
* glide 0.12.3 - set in Dockerfile GLIDE_VERSION
* gosu 1.10 - set in Dockerfile GOSU_VERSION
* goglide (container) 1.8.3 - set in Makefile $VERSION

## Build
* docker-machine (or some form of docker) running.
* export DOCKER_REPO=<your target docker repo> e.g. quay.io/example
* make 
	* all - builds container image and stores in the local docker cache
	* clean - removes container image from local docker cache
	* push - push container image to `$DOCKER_REPO/goglide:x.y.z`
	
## Container Usage
This container runs an `entrypoint.sh` script to set the container uid:gid to match the current filesystem uid:gid.

* With no env args, the container queries the current `./` uid:gid and adds a new user to the container.  Then switches to run as that user (via `gosu`).
* Environment var `LOCAL_USER_ID` - uid [defaults to uid on `./`]
* Environment var `LOCAL_USER` - user name [defaults to `user`]
* Environment var `LOCAL_GRP_ID` - gid [defaults to gid on `./`]

### Reason for uid:gid
Running docker-machine on os-x using virtualbox, the VM started in virtualbox by docker-machine assigns different uid:gid values to host mounted filesystems.  This causes issues with anything that validates the file ownership against the running user (e.g. SSH, Mercurial, etc).  This fixes that issue by finding out what uid:gid VB assigned to the mounted filesystem, then adds a new user to the docker container and switches to that new user.

````
os-x local filesystem:  uid: MyLogin(501) gid: staff(20)
docker-machines VB VM:  uid: user(1000) gid: staff(50)
docker container: uid: MyLogin(1000) gid: staff(50)
````
Note: it seems that only the uid:gid matter, and sometimes the username, but not the group name.

### How to Use This Container

See https://hub.docker.com/_/golang/ for the basics of how it works. Then the following examples for the additions in this container.

#### Example Usage

Start and interactive golang container using the current directory.
````
docker run --rm --name golang-build-container -v $PWD:/go -it quay.io/samsung_cnct/goglide:1.8.3 bash
````

Set to the current username, default the uid:gid to fs values and running a Makefile.

````
docker run \
        --rm \
        --name golang-build-container \
        -v ${go_dir}:/go \
        -w /go${build_dir} \
        -e VERSION=${BUILD_VERSION} \
        -e LOCAL_USER=$USER \
        quay.io/samsung_cnct/goglide:1.8.3 \
        make --file ${MAKEFILE_NAME} ${MAKE_ARGS};"
````
Set to the current username, gid, and uid and running a Makefile.

````
docker run \
        --rm \
        --name golang-build-container \
        -v ${go_dir}:/go \
        -w /go${build_dir} \
        -e VERSION=${BUILD_VERSION} \
        -e LOCAL_USER=$USER \
        -e LOCAL_USER_ID=1000 \
        -e LOCAL_GRP_ID=50 \
        quay.io/samsung_cnct/goglide:1.8.3 \
        make --file ${MAKEFILE_NAME} ${MAKE_ARGS};"
````
	
