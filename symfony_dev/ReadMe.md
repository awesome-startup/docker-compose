# **Symfony in Docker**


## Docker Configuration

### For mac or pc
#### Install Docker-ToolBox
[Download Link](https://www.docker.com/products/docker-toolbox)

#### Start & config docker machine
```
docker-machine start default

eval $(docker-machine env default)
```
### For linux
#### Install docker
[Link](https://docs.docker.com/engine/installation/linux/centos/)

## Prerequisites

* Change `/symfony-project-path` in `docker-compose.yml`
```
app:
  build: code
  volumes:
    - /path-to-your-symfony-project-folder-name:/symfony
```

* php running environment:
    * php54 (by default)
    * if using php56/php70: just ununcomment php56/php70 in `docker-compose.yml` (php56 in demo):

```
...

php56:
   build: php56
   volumes:
     - ./config/php56/symfony.ini:/usr/local/etc/php/conf.d/symfony.ini
     - ./config/php56/php-fpm.conf:/etc/php-fpm.conf
   links:
     - db
     - redis
   volumes_from:
     - app
 ...

nginx:
  image: nginx
  ports:
    - 80:80
  volumes:
    - ./config/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    - ./config/nginx/php54.conf:/etc/nginx/conf.d/php54.conf
    - ./config/nginx/php56.conf:/etc/nginx/conf.d/php56.conf
    # - ./config/nginx/php70.conf:/etc/nginx/conf.d/php70.conf
    - ./config/nginx/logs:/var/log/nginx
  links:
    - php54
    - php56
    # - php70
  volumes_from:
    - app
```


## Deploy symfony in Docker

#### Build
```
docker-compose build
```

#### Deploy
```
docker-compose up -d
```

#### check runing
```
docker-compose ps
```

#### logs
```
docker-compose logs nginx
```
#### db
* symfony project config:
    * Modify symfony-project `app/config/parameters.yml` 
```
parameters:
            ...
            database_host: db
            redis_host: redis
            ...
```

* GUI Connection: IP
```
docker-machine ip default
```

* MySQL_PASSWORD in `docker-compose.yml`:
```
db:
  image: mysql
  ports:
    - 3306:3306
  environment:
    MYSQL_ROOT_PASSWORD: root
    MYSQL_DATABASE: symfony
    MYSQL_USER: root
    MYSQL_PASSWORD: root
```

#### Command
* run `./app/console` 
```
docker-compose run php ./app/console
```
* run `./cc`
```
docker-compose run php ./cc
```
* ...

## Launcher

* Add Hosts (using php54)
```
echo "$(docker-machine ip default) php54.symfony.dev" >> /etc/hosts
```

* Open Browser http://php54.symfony.dev/app_dev.php/admintools


