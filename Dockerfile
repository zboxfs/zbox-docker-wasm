FROM zboxfs/base

RUN apt-get update -y && apt-get install -y \
    python \
    git-core

# install emscripten
ENV EMCC_SDK_VERSION sdk-1.38.23-64bit
WORKDIR /
RUN git clone https://github.com/emscripten-core/emsdk.git
RUN cd emsdk && ./emsdk install $EMCC_SDK_VERSION && ./emsdk activate $EMCC_SDK_VERSION

# set environment variable and change llvm root directory to indicate
# emscripten use our llvm as wasm backend
ENV EMCC_WASM_BACKEND=1
RUN echo "LLVM_ROOT='/usr/lib/llvm-8/bin'" >> /root/.emscripten

# apply libsodium patch for building wasm target
WORKDIR ${LIBSODIUM_HOME}
COPY libsodium-wasm.patch .
RUN patch -p1 < libsodium-wasm.patch

# build libsodium using emscripten
RUN bash -c "source /emsdk/emsdk_env.sh && ./dist-build/emscripten.sh --standard"

# environment variables for static linking with libsodium
ENV SODIUM_LIB_DIR=${LIBSODIUM_HOME}/libsodium-js/lib
ENV SODIUM_STATIC=true

# define lz4 library environment variables
ENV LIBLZ4_VERSION 1.9.2
ENV LIBLZ4_FILE lz4-${LIBLZ4_VERSION}.tar.gz
ENV LIBLZ4_HOME /opt/lz4-${LIBLZ4_VERSION}

# download lz4 source code
WORKDIR /opt
RUN wget -q https://github.com/lz4/lz4/archive/v${LIBLZ4_VERSION}.tar.gz -O ${LIBLZ4_FILE} \
    && tar zxf ${LIBLZ4_FILE} \
    && rm ${LIBLZ4_FILE}

# build liblz4 static library using emscripten
WORKDIR ${LIBLZ4_HOME}
RUN bash -c "source /emsdk/emsdk_env.sh && emmake make BUILD_SHARED=no lib-release"

# environment variables for static linking with liblz4
ENV LZ4_LIB_DIR=${LIBLZ4_HOME}/lib

# use node.js from emsdk
ENV PATH="/emsdk/node/8.9.1_64bit/bin:${PATH}"

# install wasm building tools
RUN rustup target add wasm32-unknown-unknown \
    && cargo install wasm-nm \
    && curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

WORKDIR /root/zbox
