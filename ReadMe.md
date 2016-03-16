### clear stopped container
```
docker rm $(docker ps -aq)
```

### clear no-used volumes

```
docker volume rm $(docker volume ls -q)
```