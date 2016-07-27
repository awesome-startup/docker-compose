
### docker update 

* need add parameters to docker daemon
``` 
/usr/lib/systemd/system/docker.service

eg:
    docker daemon -g /mnt/docker -H fd:// -H unix:///var/run/docker.sock --cluster-store etcd://etcd.darg.ws --cluster-advertise 192.168.20.23:2375
```

### cleanup stopped container
```
docker rm $(docker ps -aq)
```

### cleanup no-used volumes

```
docker volume rm $(docker volume ls -q)
```

### cleanup <none> images
```
docker rmi $(docker images | grep '<none>' | awk '{print $3}')
```


### Change Docker Dir
```
docker ps -q | xargs docker kill
stop docker
cd /var/lib/docker/devicemapper/mnt
umount ./*
mv /var/lib/docker $dest
ln -s $dest /var/lib/docker
start docker
```