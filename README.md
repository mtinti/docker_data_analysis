# Bioinformatics Docker Environment: User Guide


<!-- WARNING: THIS FILE WAS AUTOGENERATED! DO NOT EDIT! -->

This guide covers how to build, pull, run, and use the Bioinformatics
Docker environment with Python 3.10, R 4.6, and JupyterLab.

### [web version](https://mtinti.github.io/docker_data_analysis/)

## Contents

- [Prerequisites](#prerequisites)
- [Building the Image](#building-the-image)
- [Pulling the Image](#pulling-the-image)
- [Running JupyterLab](#running-jupyterlab)
- [Working with the Environment](#working-with-the-environment)
- [Advanced Usage](#advanced-usage)

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your
  machine
- Internet connection for pulling dependencies
- (Optional) Docker Hub account for pushing/pulling the image

## Building the Image

### Option 1: Build from Dockerfile

1.  Clone the repository containing the Dockerfile:

    ``` bash
    git clone https://github.com/mtinti/biojupyter.git
    cd biojupyter
    ```

2.  Build the Docker image:

    ``` bash
    docker build -t biojupyter .
    ```

    This process may take 15-30 minutes depending on your internet speed
    and machine capabilities.

## Pulling the Image

If the image is already available on Docker Hub:

``` bash
# Pull the latest version
docker pull mtinti/biojupyter:latest
```

## Running JupyterLab

### Basic Usage

Start JupyterLab server:

``` bash
docker run -p {8888 or you favorite port}:8888 -v $(pwd):/app --rm mtinti/biojupyter
```

This command: - Maps port 8888 of the container to port 8888 on your
host - Mounts your current directory to `/app` in the container -
Automatically removes the container when stopped (`--rm`) \> Note: The
environment is configured with no password or token for simplicity.

Running with git credential:

``` bash
docker run -p 8888:8888 -v $(pwd):/app -v ~/.gitconfig:/etc/gitconfig -v /path/to/.ssh/id_rsa:/root/.ssh/id_rsa --rm mtinti/biojupyter:latest
#
git remote set-url origin git@github.com:path/to_repo.git
```

### Access JupyterLab

Once running, access JupyterLab by opening a web browser and navigating
to:

    http://localhost:8888

### Testing rpy2 Functionality

If you clone the repository and start the container from inside the repo
directory:

``` bash
git clone https://github.com/mtinti/biojupyter.git
cd biojupyter
docker run -p 8888:8888 -v $(pwd):/app --rm biojupyter
```

- You can open and run the included nbs/00_test.ipynb notebook to verify
  that rpy2 is working correctly.
- This notebook demonstrates calling R functions from Python and passing
  data between the two languages.

### With Custom Port

If port 8888 is already in use on your machine:

``` bash
docker run -p 9999:8888 -v $(pwd):/app --rm biojupyter
```

Then access JupyterLab at `http://localhost:9999`

## Working with the Environment

### Available Kernels

This environment provides two Jupyter kernels: - **Python 3.10 (venv)**:
Python kernel with all the bioinformatics packages installed - **R**: R
4.6 kernel with Bioconductor packages

### Accessing Files

Files in your current directory (where you run the `docker run` command)
are accessible within JupyterLab under the `/app` directory.

## Advanced Usage

### Interactive Shell Access

To access a bash shell within the container:

``` bash
docker run -it --rm --entrypoint /bin/bash biojupyter
```

### Activate Python Environment Inside Container

When accessing the shell, activate the Python virtual environment:

``` bash
source /opt/venv/bin/activate
```

### One liner

``` bash
docker run -it --rm -v $(pwd):/app --entrypoint /bin/bash biojupyter -c "source /opt/venv/bin/activate && exec bash"
```
