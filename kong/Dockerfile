FROM kong:2.8.0-alpine

USER root

RUN mkdir /usr/local/share/lua/5.1/kong/plugins/custom-auth
COPY ./plugins/custom-auth /usr/local/share/lua/5.1/kong/plugins/custom-auth

USER kong

