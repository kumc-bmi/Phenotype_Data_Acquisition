venv_clear:
	# "deleting python virtual env"
	rm -rf venv


venv: venv_clear
	# "creating python virtual env"
	python -m venv venv
	. ./venv/bin/activate && \
	pip install --upgrade pip  && \
	pip install -r requirements.txt  && \
	pip freeze >  requirements_pip_freeze.txt  && \
	which pip && which python && python --version


encrypt_cols:
	sqlplus ${USER_NAME}/${USER_PASSWORD}@${ORACLE_SID} @encrypt_cols.sql ${encrypting_password}


encrypt_zip_file:
	zip -P ${n3c_zip_file_encryption_password_shared} KUMC_pcornet_${d1}.zip.zip KUMC_pcornet*.zip


run: venv encrypt_cols
	. venv/bin/activate && \
	which python && \
	mkdir -p ~/n3c/output/DATAFILES && \
	python db_exp.py --config config.ini --database oracle  \
	--phenotype  ../../PhenotypeScripts/N3C_phenotype_pcornet_oracle.sql \
	--extract ../../ExtractScripts/N3C_extract_pcornet6_oracle.sql \
	--output_dir ~/n3c/output  --zip \
	--debug
	#--sftp


clean: venv_clear
