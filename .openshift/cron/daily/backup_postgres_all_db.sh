#!/bin/bash
# Backs up daily the OpenShift PostgreSQL database:

NOW="$(date +"%Y-%m-%d")"
FILENAME="$OPENSHIFT_DATA_DIR/$OPENSHIFT_APP_NAME-all-db.$NOW.backup.sql.gz"
pg_dump $OPENSHIFT_APP_NAME | gzip > $FILENAME
