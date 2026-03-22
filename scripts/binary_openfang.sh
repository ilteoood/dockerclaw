#!/bin/ash

case $1 in

  amd64)
    export VARIANT=x86_64-unknown-linux-musl
    ;;

  arm64)
    export VARIANT=aarch64-unknown-linux-musl
    ;;

  *)
    export VARIANT=i686-unknown-linux-musl
    ;;
esac

mv ./openfang-${VARIANT}/openfang ./openfang
