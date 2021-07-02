FROM python:3.8.10-slim as builder-science
LABEL maintener="Xavier Petit <nuxion@gmail.com>"

SHELL ["/bin/bash", "-c"]
ADD requirements.txt /tmp
RUN apt-get -y update \
    && apt-get install -y --no-install-recommends\
    build-essential \
    python3-dev\
    #&& python -m venv /tmp/.venv \
    #&& source /tmp/.venv/bin/activate \
    && pip install --user -r /tmp/requirements.txt 

FROM python:3.8.10-slim as app
# Some other dependecies should be installed as nodejs
# ffmpeg is required by opencv, maybe should be striped.
RUN apt-get update -yq\
    && apt-get install -y --no-install-recommends \
    curl gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get update -yq \
    && apt-get install -y --no-install-recommends \
    ffmpeg libsm6 libxext6 \
    vim-tiny \
    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    ## USER RELATED ACTIONS
    && useradd -m -d /home/app app \
    && mkdir /home/app/.local
COPY --from=builder-science --chown=app:app /root/.local /home/app/.local/
COPY --chown=app:app . /app
## Initializations, now as user app
USER app
WORKDIR /app
ENV PATH=$PATH:/home/app/.local/bin
ENV PYTHONPATH=/app
RUN python -m spacy download es_core_news_sm \
    && jupyter labextension enable \
    && jupyter labextension install dask-labextension \
    && jupyter serverextension enable dask_labextension

CMD ["jupyter", "lab", "--config", "conf/jupyter_lab_config.py"]

