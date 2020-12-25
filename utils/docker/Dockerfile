FROM secondstate/ssvm:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG TENSORFLOW_TARBALL=libtensorflow-cpu-linux-x86_64-2.4.0.tar.gz
ARG TENSORFLOW_LITE_TARBALL=ssvm-tensorflow-deps-lite-0.1.0-linux-x64.tar.gz
ARG SSVM_TENSORFLOW_DEPS_VERSION=0.1.0
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN apt update \
    && apt upgrade -y \
    && apt install -y \
        build-essential \
        libjpeg-dev \
        libpng-dev \
        libssl-dev \
        pkg-config

RUN wget https://storage.googleapis.com/tensorflow/libtensorflow/${TENSORFLOW_TARBALL} \
    && tar -C /usr/local -xzf ${TENSORFLOW_TARBALL} \
    && ldconfig

RUN wget https://github.com/second-state/ssvm-tensorflow-deps/releases/download/${SSVM_TENSORFLOW_DEPS_VERSION}/${TENSORFLOW_LITE_TARBALL} \
	&& tar -zxvf ${TENSORFLOW_LITE_TARBALL} \
	&& rm -f ${TENSORFLOW_LITE_TARBALL} \
	&& cp ./libtensorflowlite_c.so /usr/local/lib \
	&& rm ./*.so \
	&& rm ./*.so.* \
	&& ldconfig

RUN npm install -y -g --unsafe-perm \
        node-pre-gyp \
        ssvmup \
        wabt

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && cargo install \
        cargo-wasi \
        mtcnn \
        mobilenet_v2

RUN rm -rf /var/lib/apt/lists/* ${TENSORFLOW_TARBALL}
WORKDIR /root
