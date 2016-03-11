docker run \
    -ti \
    -d \
    --restart=always \
    --name shipyard-swarm-manager \
    swarm:latest \
    manage --host tcp://0.0.0.0:4000 etcd://etcd.darg.ws
    
docker run \
    -ti \
    -d \
    --restart=always \
    --name shipyard-swarm-agent \
    swarm:latest \
    join --addr 192.168.30.57:2376 etcd://etcd.darg.ws
    
    
    
docker-machine create \
    -d virtualbox \
    --engine-env DOCKER_TLS=no \
    --engine-opt="cluster-store=etcd://etcd.darg.ws" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-agent-1
    
    
docker --tlscacert="/Users/llitfkitfk/.docker/machine/certs/ca.pem" \
    --tlscert="/Users/llitfkitfk/.docker/machine/certs/cert.pem" \
    --tlskey="/Users/llitfkitfk/.docker/machine/certs/key.pem" \
    -H tcp://192.168.99.100:2375 info