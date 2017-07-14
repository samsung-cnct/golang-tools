# Utility methods to simplify work with Go projects inside Docker.

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

list_available_makefiles () {
    mounted_go_volumes | while read pth; do
        find ${pth} -type f -iname Makefile -o -iname 'makefile.*' -o -name 'make.*' -o -name '*.mak'
    done 
}

looks_like_a_makefile () {
    # return 1 when it's NOT an accepted makefile name
    head -n 1 | egrep -q -e '[Mm]ake(file)?(\.[^/]*)?$' -e '.*\.mak$'
}


find_paths_with_go_code () {
    # Find all directories within a given path that contain go code files
    # NOTE: this attempts to replicate the logic of `glide novendor`
    # https://github.com/Masterminds/glide/blob/master/action/no_vendor.go
    while read p; do
        find ${p} -type f -name '*.go' -print0 | xargs -0 dirname | sort -u 
    done | grep -v -e 'vendor/' -e '/\.' -e '/_'  # exclude paths Go should ignore
}

go_path_check () {
    gofmt -w -s ${@}
    goimports -w ${@}
    golint ${@}
    gosimple ${@}
    go vet ${@}
}

go_path_test () {
    go test -v ${@}
}

loop_all_mounted_go_paths () {
    cd $GOPATH
    fetch_all_package_dependencies
    mounted_go_volumes | find_paths_with_go_code | sed "s@^`pwd`@./@" | while read pth; do
        set -ex
        for arg; do
            case "${arg}" in 
                test) go_path_test "$pth" ;;
                check) go_path_check "$pth" ;;
            esac
        done
        set +ex
    done
    cd $OLDPWD
}

switch_project_path () {
    # Executes within first mounted Go source path
    # Goal: make it easy to drop into the container and work in the project's space.
    # Common case will be to leverage Makefiles within projects.
    mounted_go_volumes | head -n 1 | while read pth; do
        cd ${pth};
        exec "${@}"
        test 0 -eq $? && return 0
    done

}

