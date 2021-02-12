FROM docker:19.03.2

RUN which docker-compose
RUN chmod +x /usr/local/bin/docker-compose

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash
ENV PAGER="more"

RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
