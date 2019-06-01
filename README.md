# zbox-docker-wasm

Docker image for building WebAssembly binding of [ZboxFS].

## Update with upstream ZboxFS

After cloning this repo, use below commands to update upstream ZboxFS.

```sh
cd zbox-docker-wasm/zbox
git pull
```

## How to build this image

Make sure you've already updated to the latest upstream as above. Then use below
command to build the image.

```sh
cd zbox-docker-wasm
./build.sh
```

## How to use this image

To use this image to build WebAssembly binding for ZboxFS, first get the latest
code from https://github.com/zboxfs/zbox-browser

```sh
git clone https://github.com/zboxfs/zbox-browser.git
```

And then go into the cloned folder and use below command to build the binding.

```sh
./build.sh
```

For more details, please visit https://github.com/zboxfs/zbox-browser.

[ZboxFS]: https://github.com/zboxfs/zbox
