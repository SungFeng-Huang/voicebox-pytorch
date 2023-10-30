FROM nvcr.io/nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

# ENV PATH /opt/conda/bin:$PATH

# RUN apt update && \
#     apt install -y git vim tmux htop python3-dev python3-pip wget curl libgl1-mesa-glx rsync unzip build-essential python3-dev libopenblas-dev libopenexr-dev

# # Miniconda
# RUN wget --quiet http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /root/miniconda.sh && \
#     /bin/bash /root/miniconda.sh -b -p /opt/conda && \
#     rm /root/miniconda.sh && \
#     ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
#     echo ". /opt/conda/etc/profile.d/conda.sh" >> /root/.bashrc && \
#     echo "conda activate base" >> /root/.bashrc
# ENV PATH=/miniconda/bin:$PATH

# RUN conda install python=3.10

# ### torch install
# RUN pip3 install --no-cache-dir --upgrade pip
# RUN pip3 install torch torchvision torchaudio

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
RUN conda create -n myenv python=3.10 && \
    . /miniconda/etc/profile.d/conda.sh

# 啟動新創建的 conda 環境
# SHELL ["conda", "run", "-n", "myenv", "/bin/zsh", "-c"]
RUN . /miniconda/etc/profile.d/conda.sh && conda activate myenv

# 在 conda 環境中安裝 PyTorch
RUN conda install pytorch torchvision torchaudio -c pytorch

# # 確保當容器啟動時使用 zsh
# CMD ["/bin/zsh"]
