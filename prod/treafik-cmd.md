docker service create \
    --name traefik-prod \
    --constraint=node.role==manager \
    --publish 80:80 \
    --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
    --network traefik-net \
    traefik \
    --docker \
    --docker.swarmmode \
    --docker.domain=swarm.gokit.info \
    --docker.watch \
    --web


docker service create \
    --name whoami \
    --label traefik.port=80 \
    --network traefik-net \
    emilevauge/whoami

docker service create \
    --network traefik-net \
    --name=dash \
    --env DASH_PORT_8080_TCP=tcp://traefik-prod:8080 \
    --label traefik.port=8080 \
    --constraint=node.role==manager \
    svendowideit/ambassador

docker service create \
    --network traefik-net \
    --name=viz \
    --label traefik.port=8080 \
    --constraint=node.role==manager \
    --mount=type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
  manomarks/visualizer

docker service create \
    --mode global \
    --network traefik-net \
    --mount type=bind,source=/,destination=/rootfs,ro=1 \
    --mount type=bind,source=/var/run,destination=/var/run \
    --mount type=bind,source=/sys,destination=/sys,ro=1 \
    --mount type=bind,source=/var/lib/docker/,destination=/var/lib/docker,ro=1 \
    --label traefik.port=8080 \
    --name=cadvisor \
  google/cadvisor:latest

docker service create \
    --name admin \
    --network traefik-net \
    --label traefik.port=9000 \
    --constraint=node.role==manager \
    --mount type=volume,src=portainer-prod,dst=/data \
    --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
    portainer/portainer \
    -H unix:///var/run/docker.sock


docker service create \
    --name vaultier \
    --label traefik.port=80 \
    --network traefik-net \
    rclick/vaultier:latest