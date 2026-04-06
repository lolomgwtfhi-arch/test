FROM nvidia/cuda:12.2.0-cudnn11-devel-ubuntu22.04
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ggerganov/llama.cpp /opt/llama.cpp
WORKDIR /opt/llama.cpp
RUN mkdir build && cd build && cmake .. -DUSE_CUBLAS=ON -DUSE_CUDA=ON && make

RUN mkdir -p /models

EXPOSE 11434


WORKDIR /opt/llama.cpp/build


CMD ["./main", "-m", "/models/qwen3-coder-30b-q4.gguf", "-t", "16", "-ngl", "20", "-c", "4096", "--server"]