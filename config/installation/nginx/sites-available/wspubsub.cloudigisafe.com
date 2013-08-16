upstream wspubsub {
  server 127.0.0.1:8889;
}

server {
  listen 80;
  server_name wspubsub.cloudigisafe.com;
  root /home/deploy/apps/tasking/current/wspubsub/public;
  access_log /var/log/nginx/wspubsub_access.log;
  rewrite_log on;

  location / {
    proxy_pass http://wspubsub;
    proxy_redirect off;
    proxy_set_header Host             $host;
    proxy_set_header X-Real-IP        $remote_addr;
    proxy_set_header X-Forwarded-For  $proxy_add_x_forwarded_for;

    proxy_http_version          1.1;
    proxy_set_header Upgrade    $http_upgrade;
    proxy_set_header Connection "upgrade";

    chunked_transfer_encoding  off;

    client_max_body_size       10m;
    client_body_buffer_size    128k;

    proxy_connect_timeout      90;
    proxy_send_timeout         90;
    proxy_read_timeout         90;

    proxy_buffer_size          4k;
    proxy_buffers              4 32k;
    proxy_busy_buffers_size    64k;
    proxy_temp_file_write_size 64k;
  }

  location ~ ^/(images|javascripts|stylesheets)/ {
    root /home/deploy/apps/tasking/current/wspubsub/priv/static;
    expires max;
    add_header Cache-Control public;
    add_header ETag "";
    break;
  }

  location /favicon.ico {
    root /home/deploy/apps/tasking/current/wspubsub/priv/static;
    break;
  }
}
