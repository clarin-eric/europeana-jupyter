# Compose project for running [JupyterHub](https://jupyter.org/hub)

For the JupyterHub image, see
[docker-jupyterhub](https://gitlab.com/CLARIN-ERIC/docker-jupyterhub).

The notebook repository for which this was developed can be found at
[europeana-newspapers-notebooks](https://github.com/clarin-eric/europeana-newspapers-notebooks),
but it should work with any Jupyter/Binder compatible repository.

## Usage

Before first use, or after an update of the image run

```sh
## Change and uncomment the following lines if you want to build from a different
## repo or branch and/or want to use a different image name
# export JR2D_REPO=https://github.com/clarin-eric/europeana-newspapers-notebooks
# export JR2D_REF=main
# export JR2D_IMAGE_NAME=europena-newspapers
bash build-europeana-notebooks-image.sh
```

Copy `.env-template` to `.env` and adapt as needed.

Then do

```
docker-compose up -d
```

and browse to `http://localhost:88` (or another port if you reconfigured `EXTERNAL_PORT`).
