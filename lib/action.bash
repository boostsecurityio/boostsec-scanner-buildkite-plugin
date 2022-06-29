#!/bin/bash

set -e
set -o pipefail
set -u

declare VAR_PREFIX=BUILDKITE_PLUGIN_BOOSTSEC_SCANNER
export BOOST_TMP_DIR=${BOOST_TMP_DIR:-${WORKSPACE_TMP:-${TMPDIR:-/tmp}}}
export BOOST_EXE=${BOOST_EXE:-${BOOST_TMP_DIR}/boost/cli/latest/boost.sh}


log.info ()
{ # $@=message
  printf "$(date +'%H:%M:%S') [\033[34m%s\033[0m] %s\n" "INFO" "${*}";
}

log.error ()
{ # $@=message
  printf "$(date +'%H:%M:%S') [\033[31m%s\033[0m] %s\n" "ERROR" "${*}";
}

config.get ()
{ # $1=key, [$2=default]
  declare _varname=${VAR_PREFIX}_${1}
  declare value=${!_varname:-}
  echo ${value:-${2:-}}
}

init.config ()
{
  log.info "initializing configuration"

  export BOOST_CLI_URL=${BOOST_CLI_URL:-https://assets.build.boostsecurity.io}
         BOOST_CLI_URL=${BOOST_CLI_URL%*/}
  export BOOST_DOWNLOAD_URL=${BOOST_DOWNLOAD_URL:-${BOOST_CLI_URL}/boost/get-boost-cli}
  export BOOST_EXEC_COMMAND=${INPUT_EXEC_COMMAND:-}

  export BOOST_API_ENDPOINT=${BOOST_API_ENDPOINT:-$(config.get "API_ENDPOINT")}
  export BOOST_API_TOKEN=${BOOST_API_TOKEN:-$(config.get "API_TOKEN")}

  export BOOST_SCANNER_IMAGE=${BOOST_SCANNER_IMAGE:-$(config.get "SCANNER_IMAGE")}
  export BOOST_SCANNER_VERSION=${BOOST_SCANNER_VERSION:-$(config.get "SCANNER_VERSION")}

  export BOOST_CLI_ARGUMENTS=${BOOST_CLI_ARGUMENTS:-$(config.get "ADDITIONAL_ARGS")}
  export BOOST_DIFF_SCAN_TIMEOUT=$(config.get "DIFF_SCAN_TIMEOUT")
  export BOOST_EXEC_COMMAND=$(config.get "EXEC_COMMAND")
  export BOOST_EXEC_FULL_REPO=$(config.get "EXEC_FULL_REPO")
  export BOOST_GIT_PROJECT=$(config.get "PROJECT_SLUG")
  export BOOST_IGNORE_FAILURE=$(config.get "IGNORE_FAILURE")
  export BOOST_STEP_NAME=$(config.get "STEP_NAME")
  export DOCKER_CREATE_ARGS=$(config.get "DOCKER_CREATE_ARGS")
}

init.cli ()
{
  if [ -f "${BOOST_BIN:-}" ]; then
    return
  fi

  mkdir -p "${BOOST_TMP_DIR}"
  curl --silent "${BOOST_DOWNLOAD_URL}" | bash
}

main.exec ()
{
  init.config
  init.cli

  if [ -z "${BOOST_EXEC_COMMAND:-}" ]; then
    log.error "the 'exec_command' option must be defined when in exec mode"
    exit 1
  fi

  if [ -z "${BOOST_STEP_NAME:-}" ]; then
    log.error "the 'step_name' option must be defined in exec mode"
    exit 1
  fi

  # shellcheck disable=SC2086
  exec ${BOOST_EXE} scan exec ${BOOST_CLI_ARGUMENTS:-} --command "${BOOST_EXEC_COMMAND}"
}

main.scan ()
{
  init.config
  init.cli

  if [ -n "${BOOST_EXEC_COMMAND:-}" ]; then
    log.error "the 'exec_command' option must only be defined in exec mode"
    exit 1
  fi

  # shellcheck disable=SC2086
  exec ${BOOST_EXE} scan run ${BOOST_CLI_ARGUMENTS:-}
}

main ()
{
  case "${BOOST_ACTION:-scan}" in
    exec)     main.exec ;;
    scan)     main.scan ;;
    *)        log.error "invalid action ${BOOST_ACTION}"
              exit 1
              ;;
  esac
}
