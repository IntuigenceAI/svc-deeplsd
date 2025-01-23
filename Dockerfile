FROM pytorch/pytorch:2.4.1-cuda11.8-cudnn9-runtime


COPY . /svc-deeplsd
WORKDIR /svc-deeplsd
# 1) Set DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# 2) Provide a default timezone if tzdata is involved
ENV TZ=Etc/UTC

# 3) Install packages in one RUN step
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libopencv-dev \
    tzdata \
    git \
    && rm -rf /var/lib/apt/lists/*
RUN git clone --recursive https://github.com/iago-suarez/pytlsd.git
RUN cd pytlsd; pip install -r requirements.txt; pip install .; cd ..
RUN pip install scikit-build
RUN pip install -r requirements.txt  # Install the requirements
RUN pip install -e .  # Install DeepLSD
