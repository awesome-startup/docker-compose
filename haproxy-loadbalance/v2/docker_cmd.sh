docker rm $(docker ps -lq)
docker logs $(docker ps -lq)
docker run -it --rm --name haproxy-syntax-check haproxy haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
docker run -d -v $PWD//haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro -p 38080:8080 haproxy


```
global
    # log haproxy-logger local0 notice
    # user haproxy
    # group haproxy
defaults
    log global
    retries 2
    timeout connect 3000
    timeout server 5000
    timeout client 5000
listen mysql-cluster
    bind 0.0.0.0:3306
    mode tcp
    #option mysql-check user haproxy_check  (This is not needed as for Layer 4 balancing)
    option tcp-check
    balance roundrobin
    # The below nodes would be hit on 1:1 ratio. If you want it to be 1:2 then add 'weight 2' just after the line.
    # server mysql1 mysql1:3306 check
    # server mysql2 mysql2:3306 check
# Enable cluster status
listen mysql-clusterstats
    bind 0.0.0.0:8080
    mode http
    stats enable
    stats uri /
    stats realm Strictly\ Private
    stats auth status:keypas5

```