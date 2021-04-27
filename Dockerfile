FROM python:3.8-alpine

RUN mkdir /app
WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=8000

RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add postgresql-dev \
    && pip install psycopg2 \
    && apk del build-deps

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

RUN ./manage.py collectstatic --noinput

RUN adduser -D user
RUN chown -R user:user /vol
RUN chmod -R 755 /vol/web
#swtiching to user
USER user

CMD gunicorn config.wsgi:application --bind 0.0.0.0:$PORT