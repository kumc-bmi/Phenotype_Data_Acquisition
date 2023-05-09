#!/bin/bash
set -exo pipefail

# if send_to_n3c true, then send to N3C
if [ "$send_to_n3c" = "true" ] ; then
    echo "Sending to N3C sftp server"
    python db_exp.py --config config.ini --database postgres  \
	--phenotype  ../../PhenotypeScripts/N3C_phenotype_pcornet_postgres.sql \
	--extract ../../ExtractScripts/N3C_extract_pcornet6_postgres.sql \
	--output_dir ./output  --zip \
	--debug \
    --sftp
else
    echo "Not sending to N3C sftp server"
    python db_exp.py --config config.ini --database postgres  \
	--phenotype  ../../PhenotypeScripts/N3C_phenotype_pcornet_postgres.sql \
	--extract ../../ExtractScripts/N3C_extract_pcornet6_postgres.sql \
	--output_dir ./output  --zip \
	--debug
fi
