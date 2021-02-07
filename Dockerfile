## Use a tag instead of "latest" for reproducibility
FROM rocker/binder:4.0.3
ARG NB_USER=rstudio
ENV HOME /home/${NB_USER}
# Copy repo into ${HOME}, make user own $HOME
USER root
RUN apt update && apt -y install gcc zlib1g-dev libxml2-dev libcurl4-openssl-dev libssl-dev libglpk-dev
RUN apt -y upgrade libstdc++6
RUN pip install --no-cache-dir nbgitpuller
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}
USER ${NB_USER}

## run any install.R script we find
RUN if [ -f install.R ]; then R --quiet -f install.R; fi
