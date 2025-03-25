#!/bin/bash

clients_file="/docker-entrypoint.d/clients.yml"

nginx_config_path="/etc/nginx/conf.d/"

count=$(yq e '.clients | length' "$clients_file")

domain_internal="example.net"

generate_nginx_config() {
  id="$1"
  subdomain="$2"
  domain="$3"
  domain_internal="$4"
  cat <<EOF
server {
    listen 80;
    server_name ${subdomain}.${domain};

    location / {

        proxy_pass http://${id}.${domain_internal};

        resolver 127.0.0.11 valid=10s;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
}

for i in $(seq 0 $((count - 1))); do

  id=$(yq e ".clients[$i].id" "$clients_file")

  subdomain=$(yq e ".clients[$i].subdomain" "$clients_file")

  domain=$(yq e ".clients[$i].domain" "$clients_file")
  
  echo "ID: $id, Subdominio: $subdomain, Dominio: $domain"

  generate_nginx_config "$id" "$subdomain" "$domain" "$domain_internal" > "$nginx_config_path/$id.conf"
done

nginx -s reload
