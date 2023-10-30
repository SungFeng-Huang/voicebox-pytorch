FROM nvcr.io/nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

# RUN apt update && \
#     apt install -y git vim tmux htop python3-dev python3-pip wget curl libgl1-mesa-glx rsync unzip build-essential python3-dev libopenblas-dev libopenexr-dev

# 避免在安裝過程中被問到時區設定等問題
ENV DEBIAN_FRONTEND=noninteractive

# 更新套件列表並安裝基本工具
RUN apt-get update && \
    apt-get install -y \
    wget \
    git \
    curl \
    build-essential \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# 設置 zsh 為預設 shell
SHELL ["/bin/zsh", "-c"]

# 安裝 Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安裝 Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /miniconda && \
    rm miniconda.sh

# 將 miniconda 的 bin 目錄加入 PATH
ENV PATH="/miniconda/bin:${PATH}"

# 創建一個新的 conda 環境並安裝 Python 3.10
RUN conda create -n voicebox python=3.10

# 啟動新創建的 conda 環境
# 在 conda 環境中安裝 PyTorch
# SHELL ["conda", "run", "-n", "myenv", "/bin/zsh", "-c"]
RUN . /miniconda/etc/profile.d/conda.sh && \
    conda activate voicebox && \
    echo ". /miniconda/etc/profile.d/conda.sh" >> /root/.zshrc

RUN pip install --no-cache-dir --upgrade pip && \
    pip install torch torchvision torchaudio && \
    echo "conda activate voicebox" >> /root/.zshrc

# 確保當容器啟動時使用 zsh
CMD ["/bin/zsh"]
