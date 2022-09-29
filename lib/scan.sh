#!/bin/bash

log.info ()
{ # $@=message
  printf "$(date +'%H:%M:%S') [\033[34m%s\033[0m] %s\n" "INFO" "${*}";
}

log.error ()
{ # $@=message
  printf "$(date +'%H:%M:%S') [\033[31m%s\033[0m] %s\n" "ERROR" "${*}";
}

git.ls_remote ()
{
  git ls-remote --symref origin HEAD \
    | awk '/^ref:/{sub(/refs\/heads\//, "", $2); print $2}'
}

init.config ()
{
  log.info "initializing configuration"

  export BOOST_TMP_DIR=${BOOST_TMP_DIR:-${WORKSPACE_TMP:-${TMPDIR:-/tmp}}}
  export BOOST_EXE=${BOOST_EXE:-${BOOST_TMP_DIR}/boost-cli/latest}

  export BOOST_CLI_URL=${BOOST_CLI_URL:-https://assets.build.boostsecurity.io}
         BOOST_CLI_URL=${BOOST_CLI_URL%*/}
  export BOOST_DOWNLOAD_URL=${BOOST_DOWNLOAD_URL:-${BOOST_CLI_URL}/boost-cli/get-boost-cli}

  export BOOST_MAIN_BRANCH
         BOOST_MAIN_BRANCH=${BOOST_MAIN_BRANCH:-$(git.ls_remote)}

  init.ci.config
}

init.ci.config ()
{
  declare VAR_PREFIX=BUILDKITE_PLUGIN_BOOSTSEC_SCANNER
  config.export BOOST_API_ENABLED API_ENABLED
  config.export BOOST_API_ENDPOINT API_ENDPOINT
  config.export BOOST_API_TOKEN API_TOKEN
  config.export BOOST_CLI_ARGUMENTS ADDITIONAL_ARGUMENTS
  config.export BOOST_CLI_VERSION CLI_VERSION
  config.export BOOST_IGNORE_FAILURE IGNORE_FAILURE
  config.export BOOST_LOG_LEVEL LOG_LEVEL
  config.export BOOST_MAIN_BRANCH MAIN_BRANCH
  config.export BOOST_PRE_SCAN PRE_SCAN_CMD
  config.export BOOST_SCANNER_REGISTRY_MODULE REGISTRY_MODULE
}

config.get ()
{ # $1=key, [$2=default]
  declare _varname=${VAR_PREFIX}_${1}
  declare value=${!_varname:-}
  echo "${value:-${2:-}}"
}

config.export ()
{ # $1=export, $2=key, [$3=default]
  declare value
  value=$(config.get "${2}" "${3:-}")
  # shellcheck disable=SC2086
  if [ -n "${value:-}" ]; then
    export "${1}"="${value}"
  fi
}


init.cli ()
{
  if [ -f "${BOOST_EXE:-}" ]; then
    return
  fi

  mkdir -p "${BOOST_TMP_DIR}"
  curl --silent "${BOOST_DOWNLOAD_URL}" | bash
}

main.scan ()
{
  init.config
  init.cli

  # shellcheck disable=SC2086
  exec ${BOOST_EXE} scan repo ${BOOST_CLI_ARGUMENTS:-} HEAD
}

if [ "${0}" = "${BASH_SOURCE[0]}" ]; then
  set -e
  set -o pipefail
  set -u

  main.scan
fi
