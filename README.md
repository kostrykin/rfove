[![Build docker image and push to Docker Hub](https://github.com/kostrykin/rfove/actions/workflows/build_docker_image.yml/badge.svg)](https://github.com/kostrykin/rfove/actions/workflows/build_docker_image.yml)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/kostrykin/rfove?label=DockerHub%3A)

# rfove

Build image:
```bash
docker build --no-cache --tag kostrykin/rfove .
```

Run RFOVE:
```bash
docker run --rm -ti -v /tmp/io:/io kostrykin/rfove /rfove 250 0.1 0.2 201 /io/input.png /io/seg.tiff
```
