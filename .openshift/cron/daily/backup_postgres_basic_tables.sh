#!/bin/bash
# Backs up daily the OpenShift PostgreSQL database tables:
# costumes parts costumes_parts part_types

NOW="$(date +"%Y-%m-%d")"
FILENAME="$OPENSHIFT_DATA_DIR/$OPENSHIFT_APP_NAME-basic-tables.$NOW.backup.sql.gz"
pg_dump $OPENSHIFT_APP_NAME -t costumes -t parts -t costumes_parts -t part_types | gzip > $FILENAME
