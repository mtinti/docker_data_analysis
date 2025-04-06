# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ARG DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install system dependencies including Python 3.10
RUN apt-get update && apt-get install -y \
    apt-utils \
    sudo \
    libunwind-dev \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*  \      
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
    lsb-release \
    libharfbuzz-dev \
    libfribidi-dev \
    libmagickwand-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 
      
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 
    
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10 \
    && python3.10 -m venv /opt/venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# All commands below will use the virtual environment
# Activate the virtual environment for all subsequent RUN commands
SHELL ["/bin/bash", "-c"]

# Install packages into the virtual environment explicitly
RUN source /opt/venv/bin/activate && \
    pip install --no-cache-dir \
    git+https://github.com/openvax/gtfparse.git \    
    jupyterlab \
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
    deeptools \
    Wand \
    dbscan \
    umap-learn \
    papermill \
    dash \
    streamlit \
    gradio \
    panel \
    pygments \
    watchfiles \
    holoviews \
    hvplot \
    geoviews \
    xarray \
    cartopy \
    holoviews \
    colorcet \
    datashader \
    gffutils \
    dash_bootstrap_components \
    'scanpy[leiden]'

RUN source /opt/venv/bin/activate && \
    python -m ipykernel install --name py310 --display-name "Python 3.10 (venv)"

# Install R 4 from CRAN repository instead of default Ubuntu packages
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    && echo "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" | sudo tee -a /etc/apt/sources.list.d/cran.list \
    && apt-get update \
    && apt-get install -y r-base r-base-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 
    
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/cpp11/cpp11_0.1.0.tar.gz', repos=NULL, type='source')" 
RUN R -e "install.packages(c('devtools', 'IRkernel', 'doParallel'), Ncpus=4, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages(c('tidyverse', 'BiocManager', 'missForest'), Ncpus=4, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('scales', 'pvclust', 'Seurat'), Ncpus=4, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages(c('SoupX', 'mclust', 'NbClust', 'tibble'), Ncpus=4, repos='http://cran.rstudio.com/')" 
	
RUN R -e "BiocManager::install(c('limma', 'edgeR', 'sva', 'HybridMTest', 'cqn', 'DESeq2'), Ncpus=4 )" 
RUN R -e "BiocManager::install(c('SingleCellExperiment'), Ncpus=4 )"  
RUN R -e "BiocManager::install(c('BiocIO'), Ncpus=4 )"   
RUN R -e "BiocManager::install(c('Rhdf5lib'), Ncpus=4 )" 
RUN R -e "BiocManager::install(c('LoomExperiment'), Ncpus=4 )" 
RUN R -e "BiocManager::install(c('scater', 'scuttle'), Ncpus=4 )" 
RUN R -e "BiocManager::install(c('DropletUtils'), Ncpus=4 )" 
RUN R -e "BiocManager::install(c('zellkonverter'), Ncpus=4 )"
    
RUN source /opt/venv/bin/activate && \
    pip install --no-cache-dir \
    rpy2 && \
    R -e "IRkernel::installspec()" 

RUN source /opt/venv/bin/activate && \
    pip install --no-cache-dir \
    git+https://github.com/mtinti/ProjectUtility.git \
    git+https://github.com/mtinti/OligoSeeker.git \
    git+https://github.com/mtinti/BarcodeSeqKit.git \
    git+https://github.com/AnswerDotAI/fastcore.git \
    git+https://github.com/AnswerDotAI/fasttransform.git \
    nbdev

RUN source /opt/venv/bin/activate && \
    nbdev_install_quarto


RUN source /opt/venv/bin/activate && \
    jupyter lab build --minimize=False && \
    npm cache clean --force && \
    rm -rf /tmp/npm-* /tmp/v8-*


# Expose the port JupyterLab will run on
EXPOSE 8888

# Set up the entrypoint to activate the virtual environment and start Jupyter
CMD source /opt/venv/bin/activate && jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token="" --NotebookApp.password=""
