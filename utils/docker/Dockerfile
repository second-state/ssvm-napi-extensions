FROM secondstate/ssvm:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG TENSORFLOW_TARBALL=libtensorflow-cpu-linux-x86_64-2.3.0.tar.gz
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
