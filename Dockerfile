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
RUN apt-get update \
    ## TODO Maybe for opencv, make this a different service
    && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 vim-tiny -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    ## USER RELATED ACTIONS
    && useradd -m -d /home/app app \
    && mkdir /home/app/.local
COPY --from=builder-science --chown=app:app /root/.local /home/app/.local/
COPY --chown=app:app . /app
USER app
RUN python -m spacy download es_core_news_sm 
WORKDIR /app
ENV PATH=$PATH:/home/app/.local/bin
ENV PYTHONPATH=/app
CMD ["jupyter", "lab", "--config", "conf/jupyter_lab_config.py"]

