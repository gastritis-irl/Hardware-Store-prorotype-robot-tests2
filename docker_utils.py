import docker

def get_docker_container_ip(container_name):
    """Gets the IP address of a Docker container by its name."""
    client = docker.from_env()
    container = client.containers.get(container_name)
    return container.attrs['NetworkSettings']['IPAddress']

def get_docker_container_port(container_name, port):
    """Gets the port of a Docker container by its name."""
    client = docker.from_env()
    container = client.containers.get(container_name)
    return container.attrs['NetworkSettings']['Ports'][port][0]['HostPort']