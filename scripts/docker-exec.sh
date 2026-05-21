#!/bin/sh

cd ~/Workspaces/various/keyboards/zmk
docker run -it --rm \
  --workdir /workspaces/zmk \
  -v "$(pwd):/workspaces/zmk" \
  -v "zmk-config:/workspaces/zmk-config" \
  zmk-dev /bin/bash
