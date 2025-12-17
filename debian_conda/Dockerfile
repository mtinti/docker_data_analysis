FROM mtinti/biojupyter_debian:latest

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

ENV PATH="/opt/miniforge3/bin:$PATH"

# Keep the original entrypoint
CMD source /opt/venv/bin/activate && jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token="" --NotebookApp.password=""