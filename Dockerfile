# podman build -t superset_test_build --build-arg ADMIN_USERNAME='pi' --build-arg ADMIN_EMAIL='pi@pi.com' --build-arg ADMIN_PASSWORD='pi_pw' .
# podman run -it -p 8088:8088 -v C:/Users/<USER>/Downloads:/downloads localhost/superset_test_build:latest

FROM ghcr.io/astral-sh/uv:bookworm-slim

# declare which user to run the following commands with
USER root

# add superset user
RUN useradd -ms /bin/bash superset

# declare build args
ARG ADMIN_USERNAME
ARG ADMIN_EMAIL
ARG ADMIN_PASSWORD

# install dependencies
RUN apt-get update &&  \
    apt-get -y install  \
    build-essential \
    gcc libc-dev \
    python3-dev \
    libffi-dev \
    libssl-dev \
    libsasl2-dev \
    libldap2-dev \
    default-libmysqlclient-dev

# copy necessary files
COPY ./pyproject.toml .
COPY ./.python-version .
COPY ./superset_init.sh .
COPY superset_config.py /app/

# setup python environment
RUN uv sync

# assing environment variables
ENV ADMIN_USERNAME $ADMIN_USERNAME
ENV ADMIN_EMAIL $ADMIN_EMAIL
ENV ADMIN_PASSWORD $ADMIN_PASSWORD
ENV FLASK_APP superset
ENV SUPERSET_SECRET_KEY YOUR-SECRET-KEY
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

#USER superset

# add virtual environment binaries to path variable to be able to call them
ENV PATH="/.venv/bin:$PATH"

# declare entrypoint
CMD ["/bin/bash", "/superset_init.sh" ]