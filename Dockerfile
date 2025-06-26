# Use amd64 Ubuntu 18.04 base to ensure compatibility with SNPE binaries
FROM --platform=linux/amd64 ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies (including those needed by matplotlib and scipy)
RUN apt-get update && apt-get install -y \
    python3.6 python3.6-dev python3-pip \
    wget unzip git build-essential cmake gfortran \
    libprotobuf-dev protobuf-compiler \
    libfreetype6-dev libpng-dev pkg-config \
    libopenblas-dev liblapack-dev zip libc++-9-dev \
    libpython3.6 libpython3.6-dev libstdc++6 libgcc1 libc6 \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.6 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1

# Install Python packages in order
RUN python -m pip install --upgrade pip && \
    pip install numpy==1.16.5 && \
    pip install --no-build-isolation scipy==1.5.4 && \
    pip install \
      sphinx==2.2.1 \
      matplotlib==3.0.3 \
      scikit-image==0.15.0 \
      protobuf==3.6.0 \
      pyyaml==5.1 \
      mako && \
    rm -rf /root/.cache/pip

# Copy SNPE and NDK into the container
COPY snpe-1.68.0.3932 /opt/snpe
COPY android-ndk-r21e /opt/ndk

# Set environment variables
ENV SNPE_ROOT=/opt/snpe
ENV ANDROID_NDK_ROOT=/opt/ndk
ENV PATH=$ANDROID_NDK_ROOT:$PATH
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/opt/snpe/lib/x86_64-linux-clang:$LD_LIBRARY_PATH

# Set working directory and shell
WORKDIR /opt/snpe
CMD ["/bin/bash"]