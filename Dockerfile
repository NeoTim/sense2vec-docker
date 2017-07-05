FROM philcryer/min-wheezy

RUN apt-get -y update && apt-get -y install git python3-dev python3-pip vim build-essential

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.3.14-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENV PATH /opt/conda/bin:$PATH

RUN conda install -c conda-forge openblas


#RUN pip install pip -U
RUN git clone https://github.com/explosion/sense2vec.git && \
    cd sense2vec && \
    pip install -r requirements.txt && \
    pip install -e .

RUN sputnik --name sense2vec --repository-url http://index.spacy.io install reddit_vectors

RUN apt-get remove --purge -y $BUILD_PACKAGES $(apt-mark showauto) && rm -rf /var/lib/apt/lists/*
WORKDIR /sense2vec





