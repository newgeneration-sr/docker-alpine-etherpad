FROM dotriver/alpine-s6

ENV DATABASE_HOST=localhost \
    DATABASE_PORT=3306 \
    DATABASE_PASSWORD=password \
    DATABASE_USERNAME=username \
    DATABASE_NAME=etherpad \
    ADMIN_USERNAME=admin \
    ADMIN_PASSWORD=password

RUN set -x \
    && apk --no-cache add nodejs npm abiword abiword-plugin-command

RUN set -x \
    && apk --no-cache add mysql-client \
    && rm -R /var/www/* || true \
    && addgroup -S etherpad && adduser -S etherpad -G etherpad

ADD conf/ /

RUN set -x \
    && chmod +x /etc/cont-init.d/ -R \
    && chmod +x /etc/periodic/ -R  \
    && chmod +x /etc/s6/services/ -R 