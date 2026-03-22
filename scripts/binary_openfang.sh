#!/bin/ash

case $1 in

  amd64)
    export VARIANT=x86_64-unknown-linux-gnu
    ;;

  arm64)
    export VARIANT=aarch64-unknown-linux-gnu
    ;;

  *)
    export VARIANT=i686-unknown-linux-gnu
    ;;
esac

mv ./openfang-${VARIANT}/openfang ./openfang
