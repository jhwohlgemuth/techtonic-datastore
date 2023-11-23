#! /bin/bash
set -e

main() {
    requires curl fuse-overlayfs
    #
    # Install Apptainer
    #
    local VERSION=${1:-"1.2.4"}
    local FILENAME="apptainer_${VERSION}_amd64.deb"
    curl -LOJ "https://github.com/apptainer/apptainer/releases/download/v${VERSION}/${FILENAME}"
    apt-get update
    apt-get install -y "./${FILENAME}"
    rm "./${FILENAME}"
}
main "$@"