#!/bin/bash
# Usage:
#   docker run -i -t --rm -v $(pwd):/build -w /build --entrypoint /build/build_vamp_ui.sh node:6

function Usage () {
    echo "Usage:"
    echo "  $0 run"
}

if [ $# -eq 0 ]
then
    Usage
    exit
fi

if [ $# -eq 1 -a "$1" = "run" ]
then
    docker run -i -t --rm -v $(pwd):/build -w /build --entrypoint /build/build_vamp_ui.sh node:6 build

    mv vamp-ui/ui.tar.bz2 ./

    exit
fi

if [ $# -eq 1 -a "$1" = "build" ]
then
    cd $(dirname $0)

    git clone https://github.com/magneticio/vamp-ui.git
    cd vamp-ui

    npm install -g bower "gulpjs/gulp#4.0"

    npm install && bower install --allow-root && ./setEnvironment.sh && gulp build

    mv dist ui && tar -cvjSf ui.tar.bz2 ui
fi
