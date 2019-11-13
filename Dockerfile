
# Official haskell image, latest 8.x.y
FROM haskell:8

# From IHaskell/Dockerfile:
# FROM fpco/stack-build:lts-13.22

# Update the system and install dev packages 
RUN apt-get update --fix-missing 
# Needed for miniconda3
RUN apt-get install -y git wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1
# Needed for ihaskell build
RUN apt-get install -y libtinfo-dev libzmq3-dev libcairo2-dev libpango1.0-dev libmagic-dev libblas-dev liblapack-dev
# Cleanup   
RUN rm -rf /var/lib/apt/lists/*

# Add a dummy user to install packages locally
ENV NB_USER foobar
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER  ${NB_USER}
WORKDIR ${HOME}

# Install miniconda3
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ${HOME}/miniconda3.sh
RUN /bin/bash ~/miniconda3.sh -b -p ${HOME}/miniconda3
RUN rm ${HOME}/miniconda3.sh
ENV PATH ${HOME}/miniconda3/bin:$PATH

# Install jupyter etc
RUN conda install -y jupyter notebook nb_conda_kernels 
RUN conda update -y --update-all
RUN conda clean -ltipsy 

# Install ihaskell (no stack)
ENV PATH ${HOME}/.local/bin:${HOME}/.cabal/bin:${PATH}

# Initialize cabal and setp user install
RUN cabal user-config init
RUN echo "user-install: True">> ${HOME}/.cabal/config
RUN cabal update

# Add more packages here
RUN cabal install alex
RUN cabal install happy 
RUN cabal install cpphs
RUN cabal install ihaskell
RUN ihaskell install 

# Avoid : ihaskell: Ambiguous module name ‘Language.Haskell.TH’: 
#         it was found in multiple packages: ghc-lib-parser-0.20190516 template-haskell-2.14.0.0
# Latest build @ 2019-11-13, ghc-lib-parser is not found
# RUN ghc-pkg unregister --force ghc-lib-parser

# Setup notebook config and folder (volume)
RUN mkdir -p ${HOME}/notebooks
RUN jupyter notebook --generate-config

# Entry point, no security, no browser
CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--NotebookApp.port=8899", "--no-browser", "--NotebookApp.notebook_dir=~/notebooks", "--NotebookApp.token=''", "--KernelManager.autorestart=False"]
