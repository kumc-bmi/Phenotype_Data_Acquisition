send_to_n3c: run
	# "sending to n3c"
	. venv/bin/activate && \
	./send_to_n3c.sh

run: venv
	. venv/bin/activate && \
	which python && \
	mkdir -p ./output/DATAFILES && \
	cp /var/lib/jenkins/.env/n3c/config.ini config.ini && \
	python db_exp.py --config config.ini --database postgres  \
		--phenotype  ../../PhenotypeScripts/N3C_phenotype_pcornet_postgres.sql \
		--extract ../../ExtractScripts/N3C_extract_pcornet6_postgres.sql \
		--output_dir ./output  --zip \
		--debug

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
