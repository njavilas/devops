FROM areapip/backend:v7.dev.arca

USER root

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    lsb-release

RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg \
    | tee /etc/apt/keyrings/docker.asc | gpg --dearmor

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

RUN docker --version && docker compose version

USER vscode

CMD ["bash"]
