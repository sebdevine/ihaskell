# IHaskell Docker
IHaskell docker image

 - IHaskell [project page](https://github.com/gibiansky/IHaskell)
 - Using Continuum analytics' [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
 
 ## Launch
  `docker run -it -p8888:8888 -v YOUR_NOTEBOOK_FOLDER:/home/foobar/notebooks -t ihaskell:latest`
 
 Replace `YOUR_NOTEBOOK_FOLDER` by a real folder on the host.
 
 
 ## Build
 
 ### Manually
 `docker build -t sdevine/ihaskell:latest .`
 
 ### Auto builds
 Please check [dockerhub](https://cloud.docker.com/repository/docker/sdevine/ihaskell/builds)
 
