FROM nginx:alpine

RUN apk add --no-cache bash curl jq yq

COPY ./generate_nginx_configs.sh generate_nginx_configs.sh

RUN chmod +x generate_nginx_configs.sh

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
