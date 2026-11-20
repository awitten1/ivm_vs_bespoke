FROM postgres:18
# Install headers that match this image, then keep the upgraded server.
# A newer postgresql-server-dev than the server binary leaves pg_ivm.so
# with symbols the running postgres cannot load.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      git \
      postgresql-server-dev-18 \
 && git clone --depth 1 --branch v1.17 https://github.com/sraoss/pg_ivm.git /tmp/pg_ivm \
 && make -C /tmp/pg_ivm -j"$(nproc)" \
 && make -C /tmp/pg_ivm install \
 && rm -rf /tmp/pg_ivm \
 && apt-get purge -y build-essential git postgresql-server-dev-18 \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*
