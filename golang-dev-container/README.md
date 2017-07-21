# Go Development Utility Container

This `golang-dev-container` is a QA tool, intended to simplify:

- Exercise a project's testing code
- Perform linting, formatting, and limited static analysis on the codebase.

It should provide a simple, consistent mechanism that can be leveraged with 
minimal tooling installed in its host environment, e.g. CI or desktop usecases.

#### Problem

Newcomers to the golang development community, and Samsung CNCT in particular,
need an easy means of assuring quality code early in a project's lifecycle.

#### Goals

- Provide standard Go development tooling in consistent fashion.
- Provide simple ways to exercise project's testing codebase (i.e. `_test.go`)
- Provide a viable path to extending the built-in capabilities with more advanced 
    workflows, particularly using Makefiles within the container.

This container does not aim to:

- Prepare builds of packages, distributions, or docker images of your project.
- Dictate how you manage dependencies, or automate any associated tasks.

## Usage

Recommend incorporating this into a Makefile, like so:

```Makefile

PROJECT_DIR:=$(PWD)
PACKAGE_DIR:=github.com/username/project_path  # you'll want to change this
UTIL_CONTAINER:=samsung-cnct/golang_dev:latest

check: # Runs `go vet`, `go fmt`, etc
    docker run \
        -v "$(PROJECT_DIR):/go/src/$(PACKAGE_DIR)" \
        --rm -it $(UTIL_CONTAINER) check

test: # Exercises the '*_test.go' code in the mounted codebase
    docker run \
        -v "$(PROJECT_DIR):/go/src/$(PACKAGE_DIR)" \
        --rm -it $(UTIL_CONTAINER) test


# Suppose you need to leverage your own Makefile, named `Makefile.inside`
# This may be useful if you use Glide to handle vendored packages, etc
inside_test:
    docker run \
        -v "$(PROJECT_DIR):/go/src/$(PACKAGE_DIR)" \
        --rm -it $(UTIL_CONTAINER) make -f Makefile.inside test


```

The general form should be:

```shell
docker run -v "project_code:/go/src/source_code_url" -it "samsung-cnct/golang_dev:latest" <command>
```


The container provides the following commands:

- `check` Executes `gofmt`, `goimports`, `golint` and `gosimple` on all mounted Go paths.
- `test` Executes `go test` on all mounted Go paths.
- `get_deps` attempts to resolve and download all dependences in the codebase. 
    - (This is used by `test` and `check`.)
- `go` Executes with the containers bundled `go` with arguments as provided; 
    - i.e. this would be the same as executed within `bash`.
- `shell` Executes `bash` within the container.

Additional commands using the built-in tools are available; any execution of the
container that does not leverage one of the commands above will be mapped to
the internal shell, operating in the mounted Go directory.

