
### docker update 

* need add parameters to docker daemon
``` 
/usr/lib/systemd/system/docker.service

eg:
    docker daemon -g /mnt/docker -H fd:// -H unix:///var/run/docker.sock --cluster-store etcd://etcd.darg.ws --cluster-advertise 192.168.20.23:2375
```

### clear stopped container
```
docker rm $(docker ps -aq)
```

### clear no-used volumes

```
docker volume rm $(docker volume ls -q)
```