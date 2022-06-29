#!/bin/bash

set -e
set -o pipefail
set -u

PLUGIN_NAME="boostsecurityio/boostsec-scanner"
PLUGIN_VERSION=$(git rev-parse HEAD)

cat <<EOF
steps:
  - label: "boostsecurity scanner"
    plugins:
      - ${PLUGIN_NAME}#${PLUGIN_VERSION}:
          action: scan
EOF
