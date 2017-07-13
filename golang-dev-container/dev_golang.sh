#!/bin/sh
# Simplify common Golang develompent tasks, using a prepared container.
# This should alleviate some of the frustration with setting up some utilities
# in a desktop environment.


print_help () {
cat <<EOF
Simple development task environment for Golang in Docker.

Usage:
    docker -v "\${GOPATH}/src/\$project_path:/go/src/\$project_path" run [image] <command> <args>

Typically \$project_path will be your own project, e.g. github.com/user/goproject.

Commands are:

- shell     Opens a shell prompt within the container
- go        Execute the built-in go (`go version`) 
- check     Performs linting, vet, imports checks and simple code analysis.
- test      Executes all go tests

EOF
}


mounted_go_volumes () {
    mount | awk '{if ($3 ~ "^/go/") { print $3 }}'
}

mounted_go_package_ids () {
    mounted_go_volumes | sed 's@/go/src/@@'
}

fetch_all_package_dependencies () {
    mounted_go_package_ids | while read pkg; do
        echo "Fetching dependencies of ${pkg}..." >&2
        go get -v ${pkg}/...
    done
}


find_paths_with_go_code () {
    # Find all directories within a given path that contain go code files
    for p; do
        find ${p} -type f -name '*.go' -print0 | xargs -0 dirname | sort -u
    done
}


check_given_gopaths () {
    cd ${GOPATH}
    sed "s@^`pwd`@./@" | while read pth; do
        set -ex
        echo "Performing checks on ${pth}" >&2
        gofmt -w -s ${pth}
        goimports -w ${pth}
        golint ${pth}
        gosimple ${pth}
        set +ex
    done
}

test_given_gopaths () {
    cd ${GOPATH}
    sed "s@^`pwd`@./@" | while read pth; do
        set -ex
        go test -v ${pth}
        set +ex
    done
}



check_all_mounted_go_packages () {
    fetch_all_package_dependencies
    mounted_go_volumes | while read pkg; do
        find_paths_with_go_code ${pkg} | while read pth; do
            echo $pth | check_given_gopaths
        done
    done
}

test_all_mounted_go_packages () {
    fetch_all_package_dependencies
    mounted_go_volumes | while read pkg; do
        find_paths_with_go_code ${pkg} | while read pth; do
            echo $pth | test_given_gopaths
        done
    done
}

case "${1:-none}" in
    go) exec "$@" ;; # A proper go command
    get_deps) fetch_all_package_dependencies ;;
    check) check_all_mounted_go_packages ;;
    test) test_all_mounted_go_packages ;;
    shell) exec /bin/bash ;;
    help) print_help ;;
    *) echo "No command match. [$1]" >&2 ;;
esac