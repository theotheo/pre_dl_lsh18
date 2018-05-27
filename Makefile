all: build run
	@echo "DONE"

build:
	docker build -t pre_dl_lsh18_hub .

bash:
	docker run -it --rm -v pre_dl_lsh18:/hub --net=host --env-file=.env pre_dl_lsh18_hub bash

run:
	docker run -it --rm -v pre_dl_lsh18:/hub --name pre_dl_lsh18 --env-file=.env --net=host  -p 10000:10000 pre_dl_lsh18_hub jupyterhub --port 10000 --ip 0.0.0.0
