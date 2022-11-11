FROM ubuntu:jammy as build

# #####################################################
# # Binutils
# #####################################################

ARG SRC_DIR=/tmp/binutils
ARG BUILD_DIR=/tmp/build-binutils

ARG TARGET
ARG PREFIX

RUN echo $TARGET to $PREFIX

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libipt-dev \
        libgmp-dev \
        file \
        flex \
        bison \
        make \
        expat \
        texinfo \
        m4



COPY . $SRC_DIR
WORKDIR $SRC_DIR

RUN mkdir -p $BUILD_DIR && \
    cd $BUILD_DIR && \
    $SRC_DIR/configure \
        --target=$TARGET \
        --prefix=$PREFIX \
        --disable-nls \
        --disable-werror \
        --disable-gprofng \
    && \
    make -j$(nproc) && \
    make install



FROM ubuntu:latest
COPY --from=build $PREFIX $PREFIX
ENV PATH="$PREFIX/bin:$PATH"