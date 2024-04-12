# Start from the TensorFlow 2.1.2 GPU image that also includes Jupyter
FROM tensorflow/tensorflow:2.1.2-gpu-jupyter
ENV DEBIAN_FRONTEND=noninteractive
ENV tz=America/New_York

# Use bash shell for RUN commands
SHELL ["/bin/bash", "-c"]
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub 401

# Update the package list, install R base, and clean up
RUN apt-get update && apt-get install -y \
        software-properties-common \
        build-essential \
        libcurl4-gnutls-dev \
        libxml2-dev \
        gdebi-core \
        bedtools \
        samtools \
        bamtools \
        libbamtools-dev \
        perl \
        r-base r-tidyverse r-cowplot r-irkernel jupyter \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir \
    pysam \
    pybedtools

# Install R packages
RUN R -e "install.packages(c('RColorBrewer', 'rtracklayer'), dependencies=TRUE, repos='http://cran.rstudio.com/')"


# Expose Jupyter port
EXPOSE 8888

# Set the default command to launch Jupyter Notebook
CMD ["jupyter", "notebook", "--notebook-dir=/tf", "--ip=0.0.0.0", "--no-browser", "--allow-root"]