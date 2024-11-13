FROM alpine:latest

RUN apk update && apk add --no-cache wireguard-tools bash crond

COPY check.sh /usr/local/bin/check.sh

RUN chmod +x /usr/local/bin/check.sh

RUN echo "*/5 * * * * /usr/local/bin/check.sh" > /etc/crontabs/root

CMD ["crond", "-f"]
