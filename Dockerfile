FROM ubuntu:24.04

# Install system dependencies, including udev
RUN apt-get update && \
    apt-get install -y \
    udev \
    libusb-1.0-0-dev \
    python3-pip \
    wget \
    build-essential \
    cmake \
    git && \
    rm -rf /var/lib/apt/lists/*

# Install luxonis SDK
RUN apt-get update \
    && wget -q0- https://docs.luxonis.com/install_dependencies.sh | bash \
    && rm -rf /var/lib/apt/lists/*

# Install python dependencies
RUN pip install --ignore-installed \
    depthai \
    depthai-sdk \
    opencv-python \
    --break-system-packages

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

COPY start_script.sh /start_script.sh
RUN chmod +x /start_script.sh
CMD [ "/start_script.sh" ]