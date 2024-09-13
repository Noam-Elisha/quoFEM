FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]

COPY ["./bootstrap.sh", "./build_backend_apps.sh", "./run_examples.sh", "/quoFEM/"]

WORKDIR /quoFEM

RUN source bootstrap.sh

RUN source build_backend_apps.sh

RUN source run_examples.sh