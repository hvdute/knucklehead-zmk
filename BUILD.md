1. clone zmk main: `git clone zmk....`
2. build zmk-dev image from latest zmk:
```bash
cd zmk
docker build -t zmk-dev -f .devcontainer/Dockerfile .devcontainer
```

3. create a volume to hold our zmk-config repo:
```bash
cd ~/Workspaces/various/keyboards/knucklehead-zmk
docker volume create --driver local -o o=bind -o type=none \
        -o device="$(pwd)" zmk-config
```

4. run dev container from build images with our zmk configs:
```bash
cd ~/Workspaces/various/keyboards/zmk
docker run -it --rm \
  --workdir /workspaces/zmk \
  -v "$(pwd):/workspaces/zmk" \
  -v "zmk-config:/workspaces/zmk-config" \
  zmk-dev /bin/bash
```

5. inside devcontainer, update west modules with manifest from our zmk-config repo:
```bash
west config manifest.path ../zmk-config
west config manifest.file config/west.yml

west update
```

# 6. build firmware:
```
# Note: Added -DSNIPPET="studio-rpc-usb-uart" to enable ZMK Studio over USB
cd /workspaces/zmk
for side in left right; do
  SNIPPET_ARG=""
  if [ "$side" = "left" ]; then
    SNIPPET_ARG="-DSNIPPET=studio-rpc-usb-uart"
  fi
  west build -p -s app -b nice_nano//zmk -d "build/$side" -- \
    -DSHIELD="corne_$side" \
    -DZMK_CONFIG="/workspaces/zmk-config/config" \
    $SNIPPET_ARG
done

# copy firmware files to root dir for convenient
mkdir -p corne-build-outputs/
cp build/left/zephyr/zmk.uf2 corne-build-outputs/corne_zmk_left.uf2
cp build/right/zephyr/zmk.uf2 corne-build-outputs/corne_zmk_right.uf2

```

7. flashing:
on host machine, inside that zmk repo, firmwares should be in these paths:
- `build/left/zephyr/zmk.uf2`
- `build/right/zephyr/zmk.uf2`
