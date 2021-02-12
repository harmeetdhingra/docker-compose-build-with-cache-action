FROM tiangolo/docker-with-compose

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash
ENV PAGER="more"

RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
