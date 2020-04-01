
############################################################
# 
docker run -d \
    --name openresty  \
    --network=host  \
    --restart=always  \
    -v /root/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf  \
    openresty/openresty:buster-fat
#
docker run -d 
    --name openresty \
    -p 80:80 \
    -p 81:81 \
    -p 442:442 \
    -p 443:443 \
    --restart=always \
    -v /root/docker/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf  \
    openresty/openresty:buster-fat
#
# docker ps | grep openresty
# docker exec -it 978f7aaefae9 /bin/sh
# docker exec -it 978f7aaefae9 nginx -s reload
# docker stop 978f7aaefae9 && docker rm 978f7aaefae9
# docker restart 978f7aaefae9
# 
# http://nginx.org/en/docs/stream/ngx_stream_core_module.html
# https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/
# 
cat << EOF > /root/docker/nginx.conf
worker_processes  4;
events {
    worker_connections  2048;
}
stream {
    access_log        off;
    ####################################################
    upstream backend_proxy_https {
        # server 172.17.0.1:30442 ;
        server 192.168.7.101:30442 weight=5;
        # server 192.168.7.102:30442 max_fails=2 fail_timeout=30s;
    }
    server {
        listen                  443;
        proxy_timeout           70s;
        proxy_pass              backend_proxy_https;
        proxy_protocol          on;
    }
    server {
        listen                  442;
        proxy_timeout           70s;
        proxy_pass              backend_proxy_https;
    }
    ####################################################
    upstream backend_proxy_http1 {
        # server 172.17.0.1:30081;
        server 192.168.7.101:30081 weight=5;
        # server 192.168.7.102:30081 max_fails=2 fail_timeout=30s;
    }
    server {
        listen                  80;
        proxy_timeout           70s;
        proxy_pass              backend_proxy_http1;
        proxy_protocol          on;
    }
    server {
        listen                  81;
        proxy_timeout           70s;
        proxy_pass              backend_proxy_http1;
    }
}
EOF




