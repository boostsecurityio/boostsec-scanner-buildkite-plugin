setup ()
{
  bats_load_library "bats-assert"
  bats_load_library "bats-file"
  bats_load_library "bats-support"

  PROJECT_ROOT=$(git rev-parse --show-toplevel)

  export BOOST_GIT_MAIN_BRANCH="main" # do not attempt git ops

  export SCRIPT_PATH=${PROJECT_ROOT}/lib
  # shellcheck disable=SC1091
  source "${SCRIPT_PATH}/scan.sh"
}

teardown ()
{
  :
}

@test "init.config.cli BOOST_API_ENABLED defined" {
  export BOOST_API_ENABLED=""
  export BUILDKITE_PLUGIN_BOOSTSEC_SCANNER_API_ENABLED="true"
  init.config

  assert_equal "${BOOST_API_ENABLED}" "true"
}

@test "init.config.cli BOOST_API_ENDPOINT defined" {
  export BOOST_API_ENDPOINT=""
  export BUILDKITE_PLUGIN_BOOSTSEC_SCANNER_API_ENDPOINT="true"
  init.config

  assert_equal "${BOOST_API_ENDPOINT}" "true"
}

@test "init.config.cli BOOST_API_TOKEN defined" {
  export BOOST_API_TOKEN=""
  export BUILDKITE_PLUGIN_BOOSTSEC_SCANNER_API_TOKEN="true"
  init.config

  assert_equal "${BOOST_API_TOKEN}" "true"
}

@test "init.config.cli BOOST_CLI_ARGUMENTS defined" {
  export BOOST_CLI_ARGUMENTS=""
  export BUILDKITE_PLUGIN_BOOSTSEC_SCANNER_ADDITIONAL_ARGUMENTS="true"
  init.config

  assert_equal "${BOOST_CLI_ARGUMENTS}" "true"
}

@test "init.config.cli BOOST_CLI_VERSION defined" {
  export BOOST_CLI_VERSION=""
  export BUILDKITE_PLUGIN_BOOSTSEC_SCANNER_CLI_VERSION="true"
  init.config

  assert_equal "${BOOST_CLI_VERSION}" "true"
}

@test "init.config.cli BOOST_IGNORE_FAILURE defined" {
  export BOOST_IGNORE_FAILURE=""
  export BUILDKITE_PLUGIN_BOOSTSEC_SCANNER_IGNORE_FAILURE="true"
  init.config

  assert_equal "${BOOST_IGNORE_FAILURE}" "true"
}

@test "init.config.cli BOOST_LOG_LEVEL defined" {
  export BOOST_LOG_LEVEL=""
  export BUILDKITE_PLUGIN_BOOSTSEC_SCANNER_LOG_LEVEL="true"
  init.config

  assert_equal "${BOOST_LOG_LEVEL}" "true"
}

@test "init.config.cli BOOST_GIT_MAIN_BRANCH defined" {
  export BOOST_GIT_MAIN_BRANCH=""
  export BUILDKITE_PLUGIN_BOOSTSEC_SCANNER_MAIN_BRANCH="true"
  init.config

  assert_equal "${BOOST_GIT_MAIN_BRANCH}" "true"
}

@test "init.config.cli BOOST_PRE_SCAN defined" {
  export BOOST_PRE_SCAN=""
  export BUILDKITE_PLUGIN_BOOSTSEC_SCANNER_PRE_SCAN_CMD="true"
  init.config

  assert_equal "${BOOST_PRE_SCAN}" "true"
}

@test "init.config.cli BOOST_SCANNER_REGISTRY_MODULE defined" {
  export BOOST_SCANNER_REGISTRY_MODULE=""
  export BUILDKITE_PLUGIN_BOOSTSEC_SCANNER_REGISTRY_MODULE="true"
  init.config

  assert_equal "${BOOST_SCANNER_REGISTRY_MODULE}" "true"
}

# vim: set ft=bash ts=2 sw=2 et :
