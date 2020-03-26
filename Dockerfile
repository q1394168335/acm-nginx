FROM nginx:alpine
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN apk add --no-cache bash curl openssl coreutils && chmod +x /docker-entrypoint.sh
STOPSIGNAL SIGTERM
CMD ["/docker-entrypoint.sh"]