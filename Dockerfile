FROM python:3.8-alpine

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache --virtual .tmp gcc libc-dev linux-headers
RUN pip install -r /requirements.txt

RUN mkdir /app
COPY . /app
WORKDIR /app

EXPOSE 8000

ENV PYTHONUNBUFFERED=1 \
    PORT=8000

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

RUN adduser -D user
RUN chown -R user:user /vol
RUN chmod -R 755 /vol/web
#swtiching to user
USER user

RUN ./manage.py collectstatic --noinput

CMD uwsgi --socket :8000 --master --enable-threads --module config.wsgi