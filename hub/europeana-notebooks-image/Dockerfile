FROM docker:20.10.16-dind
RUN apk add --no-cache \
		python3 \
		python3-dev \
		gcc \
		libc-dev \
		py3-pip \
		git \
	&& python3 -m pip install\
		jupyter-repo2docker
