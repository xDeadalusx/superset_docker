#!/bin/bash

# Upgrading Superset metastore
superset db upgrade

# create Admin user, you can read these values from env or anywhere else possible
superset fab create-admin --username "$ADMIN_USERNAME" --firstname Superset --lastname Admin --email "$ADMIN_EMAIL" --password "$ADMIN_PASSWORD"

# Load some data to play with
superset load_examples

# setup roles and permissions
superset init

# run the development server on port 8088 exposing it to all network interfaces
superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debugger

# Starting server
# /bin/sh -c /usr/bin/run-server.sh