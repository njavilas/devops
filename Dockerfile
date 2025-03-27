FROM python:3.14-alpine

RUN apk add --no-cache sudo openssh-client git curl wget bash bash-completion shadow pv make build-base docker gcc musl-dev python3-dev glib glib-dev docker.io docker-compose

RUN getent group docker || addgroup -S docker

RUN adduser -D -s /bin/bash vscode 
RUN adduser vscode docker

RUN echo "vscode ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vscode

USER vscode

RUN echo "source /usr/share/bash-completion/completions/git" >> /home/vscode/.bashrc

WORKDIR /workspaces

RUN curl -s https://api.github.com/repos/njavilas/githooks/releases/latest | \
    grep "browser_download_url" | \
    cut -d '"' -f 4 | \
    xargs wget && \
    chmod +x githooks

COPY requirements.txt /tmp/requirements.txt

RUN python3 -m venv /workspaces/venv 
RUN /workspaces/venv/bin/pip install --upgrade pip
RUN /workspaces/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt
