FROM ubuntu:xenial

RUN apt-get update -y && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:git-core/ppa -y && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -yq sudo curl file wget make pkg-config libssl-dev git python && \
    apt-get remove -y gcc g++ cpp && \
    apt-get autoremove -y

# install emscripten
ENV EMCC_SDK_VERSION sdk-1.39.5-64bit
WORKDIR /
RUN git clone https://github.com/emscripten-core/emsdk.git
RUN cd emsdk && ./emsdk install $EMCC_SDK_VERSION

# use node.js from emsdk
ENV PATH="/emsdk/node/12.9.1_64bit/bin:${PATH}"

# define libsodium library environment variables
ENV LIBSODIUM libsodium-1.0.17
ENV LIBSODIUM_FILE ${LIBSODIUM}.tar.gz
ENV LIBSODIUM_HOME /opt/${LIBSODIUM}

# download libsodium and its signature
RUN mkdir ${LIBSODIUM_HOME}
WORKDIR /opt
RUN wget -q https://download.libsodium.org/libsodium/releases/${LIBSODIUM_FILE} && \
    wget -q https://download.libsodium.org/libsodium/releases/${LIBSODIUM_FILE}.sig

# import libsodium's author's public key
# saved from https://download.libsodium.org/doc/installation/
COPY libsodium.gpg.key .
RUN gpg --import libsodium.gpg.key && \
    gpg --verify ${LIBSODIUM_FILE}.sig

RUN tar zxf ${LIBSODIUM_FILE} && rm ${LIBSODIUM_FILE}

# apply libsodium patch for building wasm target
WORKDIR ${LIBSODIUM_HOME}
COPY libsodium-wasm.patch .
RUN patch -p1 < libsodium-wasm.patch

# build libsodium using emscripten
RUN bash -c "/emsdk/emsdk activate $EMCC_SDK_VERSION && source /emsdk/emsdk_env.sh && ./dist-build/emscripten.sh --standard"

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
RUN bash -c "/emsdk/emsdk activate $EMCC_SDK_VERSION && source /emsdk/emsdk_env.sh && emmake make BUILD_SHARED=no lib-release"

# environment variables for static linking with liblz4
ENV LZ4_LIB_DIR=${LIBLZ4_HOME}/lib

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH /root/.cargo/bin:$PATH
RUN rustup default stable

RUN update-alternatives --install /usr/bin/cc cc /emsdk/upstream/bin/clang 100 && \
    update-alternatives --install /usr/bin/c++ c++ /emsdk/upstream/bin/clang++ 100

# install wasm building tools
RUN rustup target add wasm32-unknown-unknown \
    && cargo install wasm-nm \
    && curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

WORKDIR /root/zbox
