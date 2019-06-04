# zbox-docker-wasm

Docker image for building WebAssembly binding of [ZboxFS].

## Update with upstream ZboxFS

After cloning this repo, use below commands to update upstream ZboxFS.

```sh
git submodule update --remote
```

## How to build this image

Make sure you've already updated to the latest upstream as above. Then use below
command to build the image.

```sh
./build.sh
```

## How to use this image

To use this image to build WebAssembly binding for ZboxFS, first get the latest
code from https://github.com/zboxfs/zbox-browser

```sh
git clone https://github.com/zboxfs/zbox-browser.git
```

And then in the cloned folder use below command to build.

```sh
npm run build-wasm
```

For more details, please visit https://github.com/zboxfs/zbox-browser.

[ZboxFS]: https://github.com/zboxfs/zbox
