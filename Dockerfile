FROM python:3.8.12

ENV WORKDIR=/workspaces

ENV VIRTUAL_ENV=${WORKDIR}/venv
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

RUN apt-get update && \
    apt-get install -y git pv locales default-mysql-client git bash-completion nano docker.io && \
    rm -rf /var/lib/apt/lists/*

RUN echo "es_AR.UTF-8 UTF-8" >>/etc/locale.gen && \
    locale-gen && \ 
    locale

ENV SHELL=/bin/bash

RUN useradd -ms /bin/bash vscode

RUN echo "source /usr/share/bash-completion/completions/git" >> /home/vscode/.bashrc

USER vscode

WORKDIR ${WORKDIR}

RUN curl -s https://api.github.com/repos/njavilas/githooks/releases/latest | grep "browser_download_url" | cut -d '"' -f 4 | wget -i -

RUN chmod +x githooks

COPY requirements.txt /tmp/requirements.txt

RUN python3 -m venv ${VIRTUAL_ENV}

RUN chown -R vscode:vscode ${VIRTUAL_ENV}

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt
