# syntax=docker/dockerfile:1

FROM demartis/matlab-runtime:R2022a
MAINTAINER Leonid Kostrykin <leonid.kostrykin@bioquant.uni-heidelberg.de>

ADD rfove/bin /rfove-dist
RUN chmod +x /rfove-dist/runRFOVE_cli
RUN ln -s /rfove-dist/runRFOVE_cli /rfove
