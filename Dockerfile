# Start from the TensorFlow 2.1.2 GPU image that also includes Jupyter
# FROM tensorflow/tensorflow:2.1.2-gpu-jupyter
FROM tensorflow/tensorflow:2.16.1-gpu-jupyter
ENV DEBIAN_FRONTEND=noninteractive
ENV tz=America/New_York

# Update the package list, install R base, and clean up
RUN apt-get update \
	&& apt-get dist-upgrade -y \
	&& apt-get install -y \
        software-properties-common \
        build-essential \
        libxml2-dev \
        gdebi-core \
        bedtools \
        samtools \
        bamtools \
        libbamtools-dev \
        perl \
        r-base r-base-dev r-cran-tidyverse r-recommended \
	libssl-dev libxml2-dev libcairo2-dev libgit2-dev \
	jupyter \
	libxml2-dev libcurl4-gnutls-dev libssl-dev libv8-dev \
	imagemagick libxml-simple-perl libxml-sax-expat-perl \
	libconfig-json-perl  libhtml-treebuilder-libxml-perl libhtml-template-perl \
	libhtml-parser-perl zlib1g-dev libxslt-dev \
	libcairo2-dev libxt-dev \
	python3 python3-dev python3-pip \
	bedtools \
	wget \
	git \
	libopenblas-dev \
	libcurl4 \
	libmagick++-dev \
	libmpfr-dev \
	libgmp3-dev \
	libudunits2-dev libharfbuzz-dev libfribidi-dev \
	libglpk-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --upgrade pip && \
    pip install --no-cache-dir --ignore-installed \
    scikit-learn \
    scikeras \
    pyfaidx \
    pyBigWig \
    jupyterlab \
    scipy \
    matplotlib \
    seaborn \
    umap-learn \
    logomaker \
    pysam \
    pandas \
    tqdm \
    plotnine \
    pyGenomeTracks \
    mpl-scatter-density \
    deeptools \
    statsmodels \
    CrossMap \
    matplotlib-venn \
    biopython \
    panel \
    bokeh \
    biotite \
    upsetplot \
    tobias \
    scanpy \
    pympl \
    imageio \
    wordcloud \
    distfit \
    lckr-jupyterlab-variableinspector \
    jupyter-resource-usage \
    jupyterlab-spreadsheet-editor \
    jupyterlab_execute_time \
    openai \
    bioframe

# Install R packages
RUN R -e "install.packages('rlang', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('devtools', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('BiocManager', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('tidyverse', 'cowplot', 'RColorBrewer', 'XML'), dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "BiocManager::install('rtracklayer')"

# Expose Jupyter port
EXPOSE 8888

# Install DeepC
WORKDIR /tf
RUN git clone https://github.com/abdenlab/deepC.git

# Set the default command to launch Jupyter Notebook
CMD ["jupyter", "notebook", "--notebook-dir=/tf", "--ip=0.0.0.0", "--no-browser", "--allow-root"]