# Dockerfile.build
FROM elixir:1.7.3 AS buildstep
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/opt/app/ TERM=xterm
# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force
WORKDIR /opt/app
ENV MIX_ENV=prod REPLACE_OS_VARS=true

# Cache elixir deps
COPY mix.exs mix.lock ./
RUN mix deps.get

COPY config ./config
RUN mix deps.compile

# COPY package-lock.json package.json brunch-config.js ./
# COPY web/* ./web/
# COPY config/* ./config/
# COPY rel/* ./rel/
# COPY priv/* ./priv/
# COPY lib/* ./lib/
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY package-lock.json package.json brunch-config.js web lib priv rel config ./
#COPY . .
COPY rel ./rel
COPY config ./config
COPY lib ./lib
COPY priv ./priv
COPY web ./web

RUN mix release --env=prod

# Dockerfile.release
FROM elixir:1.7.3
ENV DEBIAN_FRONTEND=noninteractive
EXPOSE 8000
ENV PORT=8000 MIX_ENV=prod REPLACE_OS_VARS=true SHELL=/bin/bash
WORKDIR /app
COPY --from=buildstep /opt/app/_build/prod/rel/myapp/releases/0.0.1/myapp.tar.gz ./

RUN tar xfz myapp.tar.gz
ENTRYPOINT ["bin/myapp"]
