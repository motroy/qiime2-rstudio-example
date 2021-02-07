## Use a tag instead of "latest" for reproducibility
FROM rocker/rstudio:4.0.3

## Declares build arguments
ARG NB_USER
ARG NB_UID

## Copies your repo files into the Docker Container
USER root
RUN apt update && apt -y install gcc zlib1g-dev libxml2-dev libcurl4-openssl-dev libssl-dev libglpk-dev
RUN apt -y upgrade libstdc++6
COPY . ${HOME}
## Enable this to copy files from the binder subdirectory
## to the home, overriding any existing files.
## Useful to create a setup on binder that is different from a
## clone of your repository
## COPY binder ${HOME}
#RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
## Run an install.R script, if it exists.
RUN if [ -f install.R ]; then R --quiet -f install.R; fi
