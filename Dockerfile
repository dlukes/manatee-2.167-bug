FROM ubuntu:18.04

# Manatee scripts need bash
RUN apt-get update && apt-get install -y --no-install-recommends \
  bash \
  bison \
  build-essential \
  ca-certificates \
  curl \
  libicu-dev \
  libltdl-dev \
  libpcre++-dev \
  libtool \
  libxslt-dev \
  python-dev \
  swig

ARG manatee_url
RUN curl -sLo manatee.tgz $manatee_url && \
  tar xzf manatee.tgz && \
  mv manatee-open-* manatee && \
  cd manatee && \
  ./configure --with-pcre && \
  make && \
  make install

ARG corp_name
COPY $corp_name.vrt /corpora/src/test
COPY $corp_name.conf /corpora/registry/test
RUN encodevert -c test

COPY queries.sh /
ENTRYPOINT ["/queries.sh"]
