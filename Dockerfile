ARG PHP_VERSION=php-80

FROM bref/${PHP_VERSION}-fpm 		     AS base
ENV APP_ENV=prod

FROM bref/extra-uuid-${PHP_VERSION}      AS uuid

FROM bref/extra-blackfire-${PHP_VERSION} AS blackfire

FROM base                                AS vendor
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY composer.* .
RUN composer install --prefer-dist --optimize-autoloader --no-dev --no-progress
COPY .env .
RUN composer symfony:dump-env prod

FROM base
COPY --from=uuid      /opt             /opt
COPY --from=blackfire /opt             /opt
COPY --from=vendor    /var/task/vendor /var/task/vendor
COPY --from=vendor    /var/task/.env*  /var/task/
COPY . .

RUN LAMBDA_TASK_ROOT=bref bin/console cache:warmup

CMD [ "public/index.php" ]
