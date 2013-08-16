upstream tasking {
  # fail_timeout=0 means we always retry an upstream even if it failed
  # to return a good HTTP response (in case the Unicorn master nukes a
  # single worker for timing out).

  # for UNIX domain socket setups:
  server unix:///home/deploy/apps/tasking/shared/sockets/puma.sock fail_timeout=0;
}

server {
  listen 80;
  server_name tasking.cloudigisafe.com;
  root /home/deploy/apps/tasking/current/public;
  access_log /var/log/nginx/my_site_access.log;
  rewrite_log on;

  location / {
    proxy_pass http://tasking;
    proxy_redirect off;
    proxy_set_header   Host             $host;
    proxy_set_header   X-Real-IP        $remote_addr;
    proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;

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

  location ~ ^/(assets|images|javascripts|stylesheets|system)/ {
    root /home/deploy/apps/tasking/current/public;
    expires max;
    add_header Cache-Control public;
    add_header ETag "";
    break;
  }

  location /favicon.ico {
    root /home/deploy/apps/tasking/current/public;
    break;
  }
}
