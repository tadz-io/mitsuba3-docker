FROM vastai/base-image:cuda-12.8.1-auto

# set default C++ compilers
ENV CC=clang-17
ENV CXX=clang++-17

WORKDIR /usr/local/

# install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        clang-17 \
        libc++-17-dev \
        libc++abi-17-dev \
        cmake \
        ninja-build \
        libpng-dev \
        libjpeg-dev \
        libpython3-dev \
        python3-setuptools \
        python3-pip \
        python3-wheel \
        curl

# install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# clone Mitsuba repository replace -b stable with --branch v3.6.4
RUN git clone --branch v3.6.4 --recursive https://github.com/mitsuba-renderer/mitsuba3 && \
    cd mitsuba3 && \
    git submodule update --init --recursive

# copy bash script to update mitsuba variants in mitsuba.conf
COPY set_variants.sh .
RUN chmod +x set_variants.sh
   
# build Mitsuba
RUN cd mitsuba3 && \
    mkdir build && \
    cd build && \
    cmake -GNinja .. && \
    ../../set_variants.sh mitsuba.conf "scalar_rgb" "scalar_spectral" "cuda_spectral" "llvm_ad_spectral" && \
    ninja

# create venv using uv
RUN uv venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN uv pip install /usr/local/mitsuba3

CMD ["/bin/bash"]
