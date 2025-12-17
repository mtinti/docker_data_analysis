# Use Debian 12 (Bookworm) slim as the base image
FROM debian:12-slim

# Set environment variables to avoid interactive prompts
ARG DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install everything in a single RUN to reduce layer size
RUN apt-get update && \
	apt-get install -y --reinstall ca-certificates  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*   

RUN apt-get update && \
	apt-get install -y \
	apt-utils \
	software-properties-common \
	curl \
	wget \
	gnupg \
	lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 
	
RUN apt-get update && \
	apt-get install -y \	
    r-base \
    r-base-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*     

RUN apt-get update && \
	apt-get install -y \	
    nodejs \
    gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*     


RUN apt-get update && \
	apt-get install -y \
        sudo \
        libunwind-dev \
        git \
        samtools \
        bcftools \
        libbz2-dev \
        liblzma-dev \
        libncurses5-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        build-essential \
        gfortran \
        libreadline-dev \
        libx11-dev \
        libxt-dev \
        libpng-dev \
        libjpeg-dev \
        libcairo2-dev \
        xvfb \
        libharfbuzz-dev \
        libfribidi-dev \
        libmagickwand-dev && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* 

RUN apt-get update && \
	apt-get install -y \
	python3-venv  && \   
	python3 -m venv /opt/venv && \
    # Make sure pip is up to date
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip

# Set shell for activating virtual environment properly
SHELL ["/bin/bash", "-c"]

# Install Python packages
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
        colorcet \
        datashader \
        gffutils \
        dash_bootstrap_components \
        'scanpy[leiden]' \
        nbdev \
        git+https://github.com/mtinti/ProjectUtility.git \
        git+https://github.com/mtinti/OligoSeeker.git \
        git+https://github.com/mtinti/BarcodeSeqKit.git \
        git+https://github.com/AnswerDotAI/fastcore.git \
        git+https://github.com/AnswerDotAI/fasttransform.git && \
    # Install kernel for Jupyter
    python -m ipykernel install --name py3 --display-name "Python 3 (venv)" && \
    # Install quarto
    nbdev_install_quarto
    

RUN source /opt/venv/bin/activate && \
	R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/cpp11/cpp11_0.1.0.tar.gz', repos=NULL, type='source')" 

RUN source /opt/venv/bin/activate && \	
	R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/Matrix/Matrix_1.6-4.tar.gz', repos = NULL, type='source')"

RUN source /opt/venv/bin/activate && \
    R -e "install.packages(c('BiocManager','devtools'), Ncpus=4, repos='http://cran.rstudio.com/')"

RUN source /opt/venv/bin/activate && \
    R -e "install.packages(c('Seurat','SoupX'), Ncpus=4, repos='http://cran.rstudio.com/')"

RUN source /opt/venv/bin/activate && \
    R -e "install.packages(c('IRkernel', 'doParallel', 'tidyverse', 'missForest', 'scales', 'pvclust', 'mclust', 'NbClust', 'tibble'), Ncpus=4, repos='http://cran.rstudio.com/')" 

RUN source /opt/venv/bin/activate && \   
    R -e "BiocManager::install(c('limma', 'edgeR', 'sva', 'HybridMTest', 'cqn', 'DESeq2', 'SingleCellExperiment', 'BiocIO', 'Rhdf5lib', 'LoomExperiment', 'scater', 'scuttle', 'DropletUtils', 'zellkonverter'), Ncpus=4)" 

RUN source /opt/venv/bin/activate && \   
    R -e "IRkernel::installspec()"

RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# Build Jupyter Lab in a separate layer (this step generates a lot of temporary files)
RUN source /opt/venv/bin/activate && \
    jupyter lab build --minimize=False && \
    npm cache clean --force && \
    rm -rf /tmp/npm-* /tmp/v8-* ~/.cache/pip


RUN source /opt/venv/bin/activate && \
	apt-get update && \
	apt-get install -y \
    python3-dev \
    python3-distutils && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* 

# Install Python packages in a single layer (maintaining the original order)
RUN source /opt/venv/bin/activate && \
    pip install --no-cache-dir \
    rpy2 \
    deeptools \
    pyGenomeTracks  \
    pyCirclize  \
    svist4get 

 RUN source /opt/venv/bin/activate && \
    pip install --no-cache-dir \
    snakemake  

# Install Miniforge
RUN wget -q https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p /opt/miniforge3 && \
    rm /tmp/miniforge.sh && \
    /opt/miniforge3/bin/conda init bash && \
    /opt/miniforge3/bin/conda config --set auto_activate_base false && \
    /opt/miniforge3/bin/conda clean -afy

# Add conda to PATH for all users
ENV PATH="/opt/miniforge3/bin:$PATH"


# Expose the ports JupyterLab will run on
EXPOSE 8888 8944 8945 8946 8947

# Set up the entrypoint to activate the virtual environment and start Jupyter
CMD source /opt/venv/bin/activate && jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token="" --NotebookApp.password=""