# Go Development Utility Container

This container provides a simplified interface to:

- Exercise a project's testing code
- Perform linting, formatting, and limited static analysis on the codebase.

## Usage

Recommend incorporating this into a Makefile, like so:

```Makefile

PROJECT_DIR:=$(PWD)
PACKAGE_DIR:=github.com/username/project_path  # you'll want to change this
UTIL_CONTAINER:=samsung-cnct/golang_dev:latest

check: 
    docker run \
        -v "$(PROJECT_DIR):/go/src/$(PACKAGE_DIR)" \
        --rm -it $(UTIL_CONTAINER) check

test: 
    docker run \
        -v "$(PROJECT_DIR):/go/src/$(PACKAGE_DIR)" \
        --rm -it $(UTIL_CONTAINER) test

```

The general form should be:

```shell
docker run -v "project_code:/go/src/source_code_url" -it "samsung-cnct/golang_dev:latest" <command>
```


The container supports the following commands:

- `check` Executes `gofmt`, `goimports`, `golint` and `gosimple` on all mounted Go paths.
- `test` Executes `go test` on all mounted Go paths.
- `get_deps` attempts to resolve and download all dependences in the codebase. 
    - (This is used by `test` and `check`.)
- `go` Executes with the containers bundled `go` with arguments as provided; 
    - i.e. this would be the same as executed within `bash`.
- `shell` Executes `bash` within the container.


