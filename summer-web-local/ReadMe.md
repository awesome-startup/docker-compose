# summer-web in docker

## Docker环境配置

### For mac or pc
#### 安装 Docker-ToolBox
[Download Link](https://www.docker.com/products/docker-toolbox)

#### 开启与配置Docker Machine
```
docker-machine start default

eval $(docker-machine env default)
```
### For linux

#### 安装docker

[Link](https://docs.docker.com/engine/installation/linux/centos/)

## 预设

* Change `/summer-web-path` in `docker-compose.yml`
```
...
volumes:
    - /path-to-your-summer-folder-name:/tomcat/webapps/ROOT
...
```

#### 部署
```
docker-compose up -d
```
#### 检查环境
```
docker-compose ps
```

#### 编译java
```
docker-compose run java javac xxxx

javac xxxx in command/command.sh

```

#### 日志
```
docker-compose logs tomcatapp
```

#### 葡语encoder

http://www.web2generators.com/html-based-tools/online-html-entities-encoder-and-decoder


## IDEA配置：

#### 下载
https://www.jetbrains.com/idea/

#### 导入
选择 `Open Project`

#### 配置Project Structure
1. `Project`选项 添加java SDK
2. `Modules`选项 修改`WEB-INF/classes`为Sources
3. `Libraries`选项 添加`javax.servlet.jsp:jsp-api:2.2`依赖


Summer Activity Server
#### 重启tomcat:
`sudo service tomcat restart`

#### 重启nginx:
`sudo service nginx restart`

#### 重启php:
PHP 54
`sudo service php54-fpm restart`
PHP 7
`sudo service php-fpm restart`
    
