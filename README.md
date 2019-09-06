# zbox-docker-wasm

Docker image for building WebAssembly binding of [ZboxFS].

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
./scripts/build.sh
```

For more details, please visit https://github.com/zboxfs/zbox-browser.

[ZboxFS]: https://github.com/zboxfs/zbox
