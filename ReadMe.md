
### Install docker

```

sudo yum update

curl -fsSL https://get.docker.com/ | sh

sudo service docker start
sudo docker run hello-world
```

### Install docker-compose
```
curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

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
$dest=/mnt/docker

docker ps -q | xargs docker kill
systemctl stop docker
cd /var/lib/docker/devicemapper/mnt
umount ./*
mv /var/lib/docker $dest
ln -s $dest /var/lib/docker
systemctl start docker
```


### Bash Completion
Linux:

```
curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
curl -L https://raw.githubusercontent.com/docker/docker/v$(docker version -f "{{.Server.Version}}")/contrib/completion/bash/docker -o /etc/bash_completion.d/docker
```

Mac:
```
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion /usr/local/etc/bash_completion.d/docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion /usr/local/etc/bash_completion.d/docker-machine
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion /usr/local/etc/bash_completion.d/docker-compose

curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose > /usr/local/etc/bash_completion.d/docker-compose
curl -L https://raw.githubusercontent.com/docker/docker/v$(docker version -f "{{.Server.Version}}")/contrib/completion/bash/docker > /usr/local/etc/bash_completion.d/docker

files=(docker-machine docker-machine-wrapper docker-machine-prompt)
for f in "${files[@]}"; do
  curl -L https://raw.githubusercontent.com/docker/machine/v$(docker-machine --version | tr -ds ',' ' ' | awk 'NR==1{print $(3)}')/contrib/completion/bash/$f.bash > /usr/local/etc/bash_completion.d/$f
done

```


### Zsh Completion

```
curl -L https://raw.githubusercontent.com/docker/machine/v$(docker-machine --version | tr -ds ',' ' ' | awk 'NR==1{print $(3)}')/contrib/completion/zsh/_docker-machine > ~/.zsh/completion/_docker-machine
curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose
curl -L https://raw.githubusercontent.com/docker/docker/v$(docker version -f "{{.Server.Version}}")/contrib/completion/zsh/_docker > ~/.zsh/completion/_docker
```

### Kill process in docker container tomcat
```
docker exec tomcat sh -c 'kill `ps -aux | grep java|grep -v grep | awk -F " " '"'"'{print $2}'"'"'`'
```

Backup: 

[Link](http://stackoverflow.com/questions/26331651/how-can-i-backup-a-docker-container-with-its-data-volumes/26339869#26339869)

```
docker run --rm --volumes-from container-name -v $(pwd):/backup -w container-backup-dir busybox tar cvf /backup/backup.tar .
```


### docker daemon config

```
sudo mkdir -p /etc/docker && \
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://XXXXXX.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```


### tar backup & restore

```
tar -cvf ~/backupportainer.tar .

tar -xvpf ~/backupportainer.tar -C /var/lib/docker/volumes

```


### colorful bash

```
export PS1="[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]"
```