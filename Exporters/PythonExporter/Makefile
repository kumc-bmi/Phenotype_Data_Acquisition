d=$(date "+_%Y%m%d")

send_to_n3c: run
	# "sending to n3c"
	. venv/bin/activate && \
	./send_to_n3c.sh

covid_obsgen_n3c_export:run
	psql -v "ON_ERROR_STOP=1" -f covid_obsgen_n3c_export.sql
	mv OBS_GEN.csv KUMC_pcornet${d}/
	zip -r  KUMC_pcornet${d}.zip  KUMC_pcornet${d}

run: venv
	. venv/bin/activate && \
	which python && \
	mkdir -p ./output/DATAFILES && \
	cp /var/lib/jenkins/.env/n3c/config.ini config.ini && \
	python db_exp.py --config config.ini --database postgres  \
		--phenotype  ../../PhenotypeScripts/N3C_phenotype_pcornet_postgres.sql \
		--extract ../../ExtractScripts/N3C_extract_pcornet6_postgres.sql \
		--output_dir ./output \
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
