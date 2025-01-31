TAG ?= audio-sigproc-playground
CORPORA_PATH ?= /media/aagnone/wd/corpora
MAGENTA_PATH ?= /home/aagnone/vimwiki/personal/academics/music/magenta
DOCKER_CMD ?= nvidia-docker
JUP_PORT ?= 8891

.PHONY: container
container:
	docker build \
		-t ${TAG} \
		.

.PHONY: run
run:
	${DOCKER_CMD} run \
		--mount type=bind,source="$(shell pwd)",target=/opt \
		--mount type=bind,source=/media/aagnone/wd/corpora,target=/corpora \
		--mount type=bind,source=/media/aagnone/wd/corpora,target=/home/aagnone/corpora \
        -p 6006:6006 \
        -p 8891:8891/tcp \
		-ti \
		--rm \
		${TAG} \
		python main.py -c configs/freesound.yml


.PHONY: jup
jup:
	${DOCKER_CMD} run \
		--mount type=bind,source="$(shell pwd)",target=/opt \
		--mount type=bind,source=${CORPORA_PATH},target=/corpora \
        --mount type=bind,source=${MAGENTA_PATH},target=/opt/magenta \
        -p 6006:6006 \
        -p 8891:8891/tcp \
		-ti \
		--rm \
		${TAG} \
        jupyter-lab --allow-root --ip=0.0.0.0 --port=${JUP_PORT}
