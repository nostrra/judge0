FROM judge0/compilers:1.3.0 AS production

ENV JUDGE0_HOMEPAGE "https://judge0.com"
LABEL homepage=$JUDGE0_HOMEPAGE

ENV JUDGE0_SOURCE_CODE "https://github.com/judge0/judge0"
LABEL source_code=$JUDGE0_SOURCE_CODE

ENV JUDGE0_MAINTAINER "Herman Zvonimir Došilović <hermanz.dosilovic@gmail.com>"
LABEL maintainer=$JUDGE0_MAINTAINER

ENV REDIS_HOST "redis"
ENV REDIS_PORT 6379
ENV REDIS_PASSWORD "YourPasswordHere1234"
ENV POSTGRES_HOST "db"
ENV POSTGRES_PORT 5432
ENV POSTGRES_DB "postgres"
ENV POSTGRES_USER "postgres"
ENV POSTGRES_PASSWORD "YourPasswordHere1234"

ENV MAINTENANCE_MESSAGE "Judge0 is currently in maintenance."
ENV RESTART_MAX_TRIES 10

# Rails
ENV RAILS_ENV "production"
ENV RAILS_MAX_THREADS 5
ENV RAILS_SERVER_PROCESSES 1
ENV SECRET_KEY_BASE $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 128 | head -n 1)
ENV PORT 3000
ENV RAILS_LOG_TO_STDOUT "true"

# Authentication
ENV AUTHN_HEADER "X-Auth-Token"

# Authorization
ENV AUTHZ_HEADER "X-Auth-User"

# Workers
ENV INTERVAL 0.1
ENV COUNT 1
ENV QUEUE "unknown"

# Other
ENV RUBYOPT "W:no-deprecated"
ENV DISABLE_DATABASE_ENVIRONMENT_CHECK 1

ENV PATH "/usr/local/ruby-2.7.0/bin:/opt/.gem/bin:$PATH"
ENV GEM_HOME "/opt/.gem/"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      cron \
      libpq-dev \
      sudo && \
    rm -rf /var/lib/apt/lists/* && \
    echo "gem: --no-document" > /root/.gemrc && \
    gem install bundler:2.1.4 && \
    npm install -g --unsafe-perm aglio@2.3.0

ENV VIRTUAL_PORT 3000
EXPOSE $VIRTUAL_PORT

WORKDIR /api

COPY Gemfile* ./
RUN RAILS_ENV=production bundle

COPY cron /etc/cron.d
RUN cat /etc/cron.d/* | crontab -


COPY . .

ENTRYPOINT ["./docker-entrypoint.sh"]

ENV JUDGE0_VERSION "1.12.0"
LABEL version=$JUDGE0_VERSION


FROM production AS development

ARG DEV_USER=judge0
ARG DEV_USER_ID=1000

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        vim && \
    useradd -u $DEV_USER_ID -m -r $DEV_USER && \
    echo "$DEV_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

USER $DEV_USER

CMD ["sleep", "infinity"]