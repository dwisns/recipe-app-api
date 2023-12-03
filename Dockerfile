FROM python:3.9-alpine3.13
LABEL maintainer="dwisatrionurseto@gmail.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /venv && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache posgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp build-deps \
        build-base posgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [pybin "$DEV" = "true"] ; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disable-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user
