#!/usr/bin/env bash

set -e
cd "$(dirname "$0")"

corp_name="$1"
orig="$2"

if [[ ! -z "$orig" ]]; then
  manatee_url=https://corpora.fi.muni.cz/noske/src/manatee-open/archive/manatee-open-2.158.8.tar.gz
  tag=manatee-orig
else
  manatee_url=https://corpora.fi.muni.cz/noske/src/manatee-open/manatee-open-2.167.8.tar.gz
  tag=manatee-bug
fi

docker build \
  --build-arg manatee_url=$manatee_url \
  --build-arg corp_name="$corp_name" \
  -t $tag \
  .
docker run $tag
