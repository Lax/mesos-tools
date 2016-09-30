#!/bin/bash
# Usage:
#   docker run -i -t --rm -v `pwd`:/build -w /build --entrypoint /build/build_vamp.sh centos:7

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
    docker run -i -t --rm -v `pwd`:/build -w /build --entrypoint /build/build_vamp.sh centos:7 build

    mv vamp/vamp.jar ./

    exit
fi

if [ $# -eq 1 -a "$1" = "build" ]
then
    cd $(dirname $0)

    yum install -q -y git
    git clone https://github.com/magneticio/vamp.git
    cd vamp

    curl -s https://bintray.com/sbt/rpm/rpm -o /etc/yum.repos.d/sbt.repo
    yum install -q -y sbt

    sbt test assembly

    cp $(find bootstrap/target/scala-* -name 'vamp-assembly-*.jar' | sort | tail -1) vamp.jar
fi
