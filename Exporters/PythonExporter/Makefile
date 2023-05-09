run: venv
	. venv/bin/activate && \
	which python && \
	mkdir -p ./output/DATAFILES && \
	cp /var/lib/jenkins/.env/n3c/config.ini config.ini && \
	./run.sh

venv:
	# "creating python virtual env"
	python -m venv venv
	. ./venv/bin/activate && \
	pip install --upgrade pip  && \
	pip install -r requirements.txt  && \
	pip freeze >  requirements_pip_freeze.txt  && \
	which pip && which python && python --version

clean: 
	rm -rf venv
