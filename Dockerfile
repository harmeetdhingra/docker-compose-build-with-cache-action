FROM docker:19.03.2

RUN curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash
ENV PAGER="more"

RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
