ARG APP_ENV=prod
ARG PHP_VERSION=php-80
ARG BASE=bref/${PHP_VERSION}-fpm

FROM bref/extra-uuid-${PHP_VERSION}      AS uuid

FROM bref/extra-blackfire-${PHP_VERSION} AS blackfire

FROM ${BASE}                             AS vendor
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY composer.* .
RUN composer install
COPY .env .
ARG APP_ENV
RUN APP_ENV=${APP_ENV} composer symfony:dump-env prod

FROM ${BASE}
COPY --from=uuid      /opt             /opt
COPY --from=blackfire /opt             /opt
COPY --from=vendor    /var/task/vendor /var/task/vendor
COPY --from=vendor    /var/task/.env*  /var/task/
COPY . .

ARG APP_ENV
RUN APP_ENV=${APP_ENV} LAMBDA_TASK_ROOT=bref bin/console cache:warmup

CMD [ "public/index.php" ]
