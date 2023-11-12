# syntax=docker/dockerfile:1

FROM demartis/matlab-runtime:R2022a
MAINTAINER Leonid Kostrykin <leonid.kostrykin@bioquant.uni-heidelberg.de>

ADD rfove/bin/* /rfove
