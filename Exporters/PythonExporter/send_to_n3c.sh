#!/bin/bash
set -exo pipefail

# if send_to_n3c true, then send to N3C
if [ "$send_to_n3c" = "true" ] ; then
    echo "Sending to N3C sftp server"
	python db_exp.py --config config.ini --sftp
else
    echo "Not sending to N3C sftp server"
fi
