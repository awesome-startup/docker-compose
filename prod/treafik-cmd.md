docker service create \
    --name traefik-prod \
    --constraint=node.role==manager \
    --publish 80:80 --publish 8080:8080 \
    --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
    --network traefik-prod \
    traefik:1.1.2 \
    --docker \
    --docker.swarmmode \
    --docker.domain=swarm.gokit.info \
    --docker.watch \
    --web


docker service create \
    --name whoami \
    --label traefik.port=80 \
    --network traefik-prod \
    emilevauge/whoami

docker service create \
    --network traefik-prod \
    --name=viz \
    --label traefik.port=8080 \
    --constraint=node.role==manager \
    --mount=type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
  manomarks/visualizer

docker service create \
    --mode global \
    --network traefik-prod \
    --mount type=bind,source=/,destination=/rootfs,ro=1 \
    --mount type=bind,source=/var/run,destination=/var/run \
    --mount type=bind,source=/sys,destination=/sys,ro=1 \
    --mount type=bind,source=/var/lib/docker/,destination=/var/lib/docker,ro=1 \
    --label traefik.port=8080 \
    --name=cadvisor \
  google/cadvisor:latest

docker service create \
    --name admin \
    --network traefik-prod \
    --label traefik.port=9000 \
    --constraint=node.role==manager \
    --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
    portainer/portainer \
    -H unix:///var/run/docker.sock