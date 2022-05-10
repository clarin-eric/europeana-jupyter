#!/bin/bash

IMAGE=jupyter/tensorflow-notebook
PORT=8889

docker run --rm \
--name jupyter \
-p 8889:8888 \
-v "$(pwd):/home/jovyan/work" \
--workdir '/home/jovyan/work' \
"${IMAGE}"
