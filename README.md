# zbox-docker-nodejs

Docker image for building Node.js binding of [ZboxFS](https://github.com/zboxfs/zbox).

## Update with upstream ZboxFS

```sh
cd zbox-nodejs
git pull
```

## How to build this image

Make sure you've already updated to the latest upstream as above. Then use below
command to build the image.

```sh
docker build --rm -t zboxfs/nodejs .
```

## How to use this image

To use this image to build Node.js binding for ZboxFS, first get the latest
code from https://github.com/zboxfs/zbox-nodejs.

```sh
git clone https://github.com/zboxfs/zbox-nodejs.git
```

And then go into the cloned folder and use below command to build the binding.

```sh
cd zbox-nodejs
docker run --rm -v $PWD:/root/zbox zboxfs/nodejs npm run build
```

Now the Node.js binding library `native/index.node` is built.
