FROM ubuntu:24.04
# set directory for the drjit wheel
ENV WHEELHOUSE=/usr/local/wheelhouse
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

# clone drjit v1.0.5
RUN git clone --recursive --branch v1.0.5 https://github.com/mitsuba-renderer/drjit.git

# Replace -march=ivybridge with -march=native for linux arm64 builds
RUN find . -path "*/cmake-defaults/CMakeLists.txt" \
    -exec sed -i 's/-march=ivybridge/-march=native/g' {} \;

# build wheel for drjit
RUN python3 -m pip wheel /usr/local/drjit -w $WHEELHOUSE    
# swap pyproject.toml template with placeholder for drjit wheel
COPY /mitsuba3/pyproject.toml /usr/local/mitsuba3/pyproject.toml
# infer the wheel filename and substitute in the TOML
RUN WHEEL_FILE=$(ls $WHEELHOUSE/drjit-*.whl | head -n 1) && \
    sed -i "s|__DRJIT_WHEEL_PATH__|$WHEEL_FILE|g" /usr/local/mitsuba3/pyproject.toml
      
# build Mitsuba
RUN cd mitsuba3 && \
    mkdir build && \
    cd build && \
    cmake -GNinja .. && \
    ninja

# create venv using uv
RUN uv venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN uv pip install /usr/local/mitsuba3

CMD ["/bin/bash"]
