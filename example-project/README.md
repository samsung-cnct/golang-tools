# Example Golang Project

###### Mikel Nelson (3/2016)
Example golang project to start with.

### Purpose
This is presented to be a source of a framework that can be used to populate a new golang project repo.  As such, it is not runnable as is.   You must copy this into your repo and rename items appropriately.

### Summary
The goal is to have this "*go get-able*" so it is usable by other golang projects.

### Build
This is setup to use a golang docker container to do all golang "go" commands.  The current directory is mounted into the container, but at a location that facilitates "*go get*". 

### Dependency Management
The hope is to use whatever the current best practice dependency manager is.  Howeever, at the time of this update (1/2017) managing the dependencies in /vendor by hand and checking them in to source control was determined to be the most reliable.  

DEPRECATED BELOW...but may be relavent again:
It has been determined to use [glide](https://github.com/Masterminds/glide) as the package management tools.  A special docker golang build image has been created (see [samsung-cnct/golang-tools/goglide-container](https://github.com/samsung-cnct/golang-tools/tree/master/goglide-container) ).

### main/cmd Management
The golang *main* and *cmd* pkgs are build using the [cobra](https://github.com/spf13/cobra) pkg.  Additions to *cmd* may be made by hand, or with the *cobra* template generator CLI.



#### Directory Setup

**IMPORTANT** 

When doing development, the git repository HAS to be set up as follows:

````
$(GOPATH)/src/github.com/samsung-cnct/<your project>
````
How to:

````
$ export GOPATH=<whatever base path you want>
$ cd $(GOPATH)
$ mkdir -p src/github.com/samsung-cnct
$ cd src/github.com/samsung-cnct
$ git clone <your fork of samsung-cnct/<your project>>
````
golang build results:

````
$(GOPATH)
         /bin
         /pkg
         /doc
         /src <see above>
         /src/github.com/samsung-cnct/<your project>/vendor <managed by glide or whatever dependency manager is in vogue>
````

#### Build

Prerequisites: docker running on your machine. (os-x docker, docker-machine, boot2docker, etc)

Build execution:

````
<user> +--> Makefile
       |       |
       or      |
       |       v
       +--> build.sh --- --kube ----+
               |                    |
               |                    |
               v                    v
             make.golang  _containerize/Makefile
             
````

* `make.golang` - The actual golang builder.
* `_containerize/Makefile` - Builds the docker image.
* `build.sh` - Sets up the environment and starts the golang container.  Builds can be run directly from this script.  `--kube` arg directs arguments to the `_containerized/Makefile`
* `Makefile` - Facade to allow running `build.sh` via a `make` command instead (when using defaults of `build.sh`) (NOTE: This only works with `make.golang`, not with `_containerize/Makefile`).  E.g.  `make test` == `./build.sh -- test`.

###### build.sh

````
> Runs a golang build docker container and runs Makefile
> 
> Usage:
> ./build.sh [flags] -- [Makefile Args]
>
> Flags:
> -f, --file :: golang make file name (make.golang)
> -h, -?, --help :: print usage
> -i, --int :: start an interactive shell
> -k, --kube :: route Makefile args to container build
> -m, --machine :: VM machine name, overrides DOCKER_MACHINE_NAME (gexample-build)
> -t, -test :: Test Docker Detection
> -v, --version :: print script verion
> -vv, --verbose :: more debug

> Env Vars:
> DOCKER_MACHINE_DRIVER :: (virtualbox) [optional]
> DOCKER_MACHINE_NAME :: (gexample-build) or set via argument [optional]
> 
````
##### make.golang

Targets:

* `test`
* `doc`
* `build-app` - builds linux version into `_containerize` directory
* `build-darwin` - builds os-x verion into `$GOPATH/bin` directory
* `view-all-coverage` - creates the test coverage files:
	* `./coverage-all.out`
	* `./coverage-all.html` 

Dependency Management (if /vendor dir is not checked-in):

* `dep`         - currently not implemented
* `dep-update`         - currently not implemented
* `dep-update-quick`         - currently not implemented

Minor Targets

* `vet`
* `lint`

#### Local golang Packages

`main.go`

* `./cmd` (CLI managed by corbra)
* `./apkg` 

### Initial Development Setup
* Create the dev area and clone the repo (outlined above)
* Fill the vendor directory with the needed dependencies: `make dep`(ONLY IF VENDOR IS NOT CHECKED-IN)
* Validate it is all setup correctly: `make test`
* go Documents: `make doc`
* Create os-x runnable app: `make build-darwin`
* Create app for docker image: `make build-app`
* Create and push docker image: `build.sh --kube -- all push`

## Development Rules
(example information to create)
Rules here: [DEVELOPMENT](DEVELOPMENT.md)

## Running
(example information to create)
Information for running the app here: [COMMANDS](COMMANDS.md) 





