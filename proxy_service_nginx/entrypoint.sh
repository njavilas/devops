#!/bin/sh

envsubst '$BACKEND_SERVER_NAME $FRONTEND_SERVER_PORT $FRONTEND_SERVER_NAME $BACKEND_SERVER_PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"