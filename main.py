import docker
from docker import DockerClient
from docker.models.networks import Network
from typing import List


class Boxer:
    client: DockerClient

    def __init__(self) -> None:
        self.client = docker.from_env()

    def list_networks(self):
        networks: List[Network] = list(self.client.networks.list())  # type: ignore

        for net in networks:
            print(f"ID: {net.id}, Nombre: {net.name}, Driver: {net.attrs['Driver']}")

    def run(self):

        self.client.containers.run(
            image="backend:local",
            name="b_0095_c",
            detach=True,
            environment={
                "BACKEND_SERVER_NAME": "b0095_b.backend.boxer.net",
                "BACKEND_SERVER_NAME": "b0095_b.backend.boxer.net",
            },
            volumes={
                "./b0095_b/logs": {"bind": "/logs", "mode": "rw"},
                "./b0095_b/images": {"bind": "/app/images", "mode": "rw"},
            },
        )


boxer = Boxer()

boxer.list_networks()
