#!/bin/sh
# fail if there is an error and exit
set -e

python manage.py collectstatic --noinput
python manage.py migrate

# running uwsgi as a socket on port 8000 as master thread in foreground
# --enable-threds enables multi-threading, --module is djangoappname.wsgi.py
uwsgi --socket :8000 --master --enable-threads --module app.wsgi