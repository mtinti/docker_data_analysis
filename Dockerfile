# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ARG DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install system dependencies including Python 3.10, samtools, bcftools
RUN apt-get update && apt-get install -y \
    apt-utils \
    sudo \
    libunwind-dev \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y \
    python3.10 \
    python3.10-dev \
    python3.10-distutils \
    python3.10-venv \
    gcc \
    git \
    samtools \
    bcftools \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    curl \
    wget \
    gnupg \
    build-essential \
    gfortran \
    libreadline-dev \
    libx11-dev \
    libxt-dev \
    libpng-dev \
    libjpeg-dev \
    libcairo2-dev \
    xvfb \
    lsb-release



# Install pip for Python 3.10 (system-wide)
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Create a Python virtual environment
RUN python3.10 -m venv /opt/venv

# All commands below will use the virtual environment
# Activate the virtual environment for all subsequent RUN commands
SHELL ["/bin/bash", "-c"]

# Install packages into the virtual environment explicitly
RUN source /opt/venv/bin/activate && \
    pip install --no-cache-dir \
    git+https://github.com/AnswerDotAI/fastcore.git \
    jupyterlab \
    nbdev \
    matplotlib \
    scikit-learn \
    biopython \
    ipykernel \
    missingno \
    pandas \
    pyCirclize \
    pysam \
    seaborn \
    UpSetPlot \
    vcfpy \
    scipy \
    PyYAML \
    polars \
    plotly \
    'plotly[express]' \
    psutil \
    svist4get \
    pyGenomeTracks \
    deeptools

# Install Quarto using the virtual environment
RUN source /opt/venv/bin/activate && \
    nbdev_install_quarto

# Register the virtual environment as a Jupyter kernel
RUN source /opt/venv/bin/activate && \
    python -m ipykernel install --name py310 --display-name "Python 3.10 (venv)"


# Install R 4 from CRAN repository instead of default Ubuntu packages
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    && echo "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" | sudo tee -a /etc/apt/sources.list.d/cran.list \
    && apt-get update \
    && apt-get install -y r-base r-base-dev 

# Install system dependencies including Python 3.10, samtools, bcftools
RUN apt-get update && apt-get install -y \
    libharfbuzz-dev \
    libfribidi-dev

# Install R kernel for Jupyter with Bioconductor packages
# Using try() to handle potential package installation issues
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/cpp11/cpp11_0.1.0.tar.gz', repos=NULL, type='source')" 
RUN R -e "try(install.packages(c('IRkernel'), repos='http://cran.rstudio.com/'))" 
RUN R -e "try(install.packages(c('tidyverse', 'BiocManager', 'missForest', 'scales'), repos='http://cran.rstudio.com/'))" 
RUN R -e "try(BiocManager::install(c('limma', 'edgeR', 'sva', 'HybridMTest', 'cqn')))" 
RUN R -e "try(IRkernel::installspec())" 


# Install packages into the virtual environment explicitly
RUN source /opt/venv/bin/activate && \
    pip install --no-cache-dir \
    rpy2
    
RUN source /opt/venv/bin/activate && \
    pip install --no-cache-dir \    
    git+https://github.com/AnswerDotAI/fasttransform.git 

RUN apt-get update && apt-get install -y \
    libmagickwand-dev
    
RUN source /opt/venv/bin/activate && \
    pip install --no-cache-dir \
    Wand

RUN R -e "try(install.packages(c('doParallel'), repos='http://cran.rstudio.com/'))" 

RUN source /opt/venv/bin/activate && \
    pip install --no-cache-dir \
    git+https://github.com/mtinti/ProjectUtility.git
    
# Expose the port JupyterLab will run on
EXPOSE 8888

# Set up the entrypoint to activate the virtual environment and start Jupyter
CMD source /opt/venv/bin/activate && jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token="" --NotebookApp.password=""

# docker build -t biojupyter .
# start jupyter lab
# docker run -p 8888:8888 -v $(pwd):/app --rm biojupyter
# run a shell
# docker run -it --rm --entrypoint /bin/bash biojupyter