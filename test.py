import time
import docker
from docker.errors import DockerException
from docker import types

class Boxer:
    legajo: str

    def __init__(self, legajo: str):
        self.client = docker.from_env()
        self.legajo = legajo

    def create_service(self):
        try:
            service = self.client.services.create(
                image="nginx",
                name=self.legajo,
                mode=types.ServiceMode("replicated", replicas=3)
            )
            print(f"Service '{service.name}' created successfully.")
        except DockerException as e:
            print(f"Error creating the service: {e}")

    def list_services(self):
        try:
            services = self.client.services.list()
            if not services:
                print("No active services in the Swarm.")
            else:
                print("Active services:")
                for service in services:
                    replicas = service.attrs['Spec']['Mode']['Replicated'].get('Replicas', 'Not specified')
                    print(f"Service: {service.name}, Replicas: {replicas}")
        except DockerException as e:
            print(f"Error listing services: {e}")

    def scale_service(self, replicas):
        try:
            service = self.client.services.get(self.legajo)
            service.update(mode=types.ServiceMode("replicated", replicas=replicas))
            print(f"Service '{self.legajo}' scaled to {replicas} replicas.")
        except DockerException as e:
            print(f"Error scaling the service: {e}")
        except Exception as e:
            print(f"Service not found: {e}")

    def remove_service(self):
        try:
            service = self.client.services.get(self.legajo)
            service.remove()
            print(f"Service '{self.legajo}' removed.")
        except DockerException as e:
            print(f"Error removing the service: {e}")
        except Exception as e:
            print(f"Service not found: {e}")

if __name__ == "__main__":

    manager = Boxer(legajo="b0185")

    manager.create_service()
    
    manager.list_services()

    manager.scale_service(5)

    manager.list_services()

    time.sleep(10)

    manager.remove_service()
