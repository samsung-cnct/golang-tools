#!/bin/sh
# Simplify common Golang develompent tasks, using a prepared container.
# This should alleviate some of the frustration with setting up some utilities
# in a desktop environment.

. /scripts/dev_golang_lib.sh

print_help () {
cat <<EOF
Simple development task environment for Golang in Docker.

Usage:
    docker -v "\${GOPATH}/src/\$project_path:/go/src/\$project_path" run [image] <command> <args>

Typically \$project_path will be your own project, e.g. github.com/user/goproject.

Commands are:

- shell     Opens a shell prompt within the container in ${GOPATH}
- go        Execute the built-in go (`go version`) [see note below]
- check     Performs linting, vet, imports checks and simple code analysis.
- test      Executes all go tests
- full      Executes linting, vet, and tests... (combined check + test above)

Note: 

Unrecognized commands are interpreted as regular bash shell command lines, but
will be executed within the first mounted GO project path. This includes all
commands starting with "go".

EOF
}




case "${1:-none}" in
    
    scan) 
        # Diagnostic: lists interesting project paths.
        # Intent: help users ensure that the utility is finding expected codebase.
        mounted_go_volumes
        list_available_makefiles 
    ;;

    novendor)
        # Diagnostic: list paths in the project that would be tested.
        mounted_go_volumes | find_paths_with_go_code
    ;;

    
    get_deps) fetch_all_package_dependencies ;;
    
    check) loop_all_mounted_go_paths check ;;
    test) loop_all_mounted_go_paths test ;;
    full) loop_all_mounted_go_paths check test;;
    shell) exec /bin/bash ;;
    help) print_help ;;
    
    *) # execute as command given, e.g. to support Makefiles sensibly.
        switch_project_path "${@}"
    ;;
esac