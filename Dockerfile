# ----------------------------------- #
# build                               #
# ----------------------------------- #
FROM elixir:1.7.3 AS buildstep
WORKDIR /opt/app

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/opt/app/ TERM=xterm

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV=prod REPLACE_OS_VARS=true

# Cache elixir deps
COPY mix.exs mix.lock ./
RUN mix deps.get

COPY config ./config
RUN mix deps.compile

# ugh, can't do with one line?
COPY rel ./rel
COPY config ./config
COPY lib ./lib
COPY priv ./priv
COPY web ./web
COPY vm.args .

RUN mix release --env=prod

RUN APP_NAME="myapp" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    cp "$RELEASE_DIR/$APP_NAME.tar.gz" /export/

# ----------------------------------- #
# release                             #
# ----------------------------------- #
#FROM elixir:1.7.3-alpine # gives long name error
#FROM elixir:1.7.3-slim # gives long name error
FROM elixir:1.7.3
WORKDIR /app
EXPOSE 8000
#RUN apk add --no-cache bash
ENV DEBIAN_FRONTEND=noninteractive

ENV PORT=8000 MIX_ENV=prod REPLACE_OS_VARS=true SHELL=/bin/bash
COPY --from=buildstep /export/ .

RUN tar xfz myapp.tar.gz
ENTRYPOINT ["bin/myapp"]
