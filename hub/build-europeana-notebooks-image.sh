#!/bin/bash
set -e

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
(cd "${SCRIPT_DIR}/europeana-notebooks-image" && \
	docker build -t repo2docker-builder:latest .)

CONTAINER_ID=$(docker run -d --privileged --rm --name repo2docker-builder repo2docker-builder:latest)
if ! [ "${CONTAINER_ID}" ]; then
	echo "Image not started?"
	exit 1
fi

echo 'Waiting for image to run...'; sleep 5
while ! docker inspect "${CONTAINER_ID}"|grep '"Status": "running"'; do
	echo 'Waiting...'
	sleep 2
done

if ! docker exec "${CONTAINER_ID}" jupyter-repo2docker \
	--no-run --image-name europena-newspapers --user-id 1000 --user-name jovyan \
	'https://github.com/clarin-eric/europeana-newspapers-notebooks'; then
	echo 'Failed to build the image'
	docker stop "${CONTAINER_ID}"
	exit 1
fi
docker stop "${CONTAINER_ID}"
