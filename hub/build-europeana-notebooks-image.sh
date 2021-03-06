#!/bin/bash
set -e

NOTEBOOK_IMAGE_NAME="${JR2D_IMAGE_NAME:-europena-newspapers}"
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
	--no-run \
	--image-name "${NOTEBOOK_IMAGE_NAME}" \
	--user-id "${JR2D_USER_ID:-1000}" \
	--user-name "${JR2D_USERNAME:-jovyan}" \
	--ref  "${JR2D_REF:-main}" \
	"${JR2D_REPO:-https://github.com/clarin-eric/europeana-newspapers-notebooks}"; then
	echo 'Failed to build the image'
	docker stop "${CONTAINER_ID}"
	exit 1
fi

docker exec "${CONTAINER_ID}" docker save "${NOTEBOOK_IMAGE_NAME}:latest" | docker load

docker stop "${CONTAINER_ID}"
