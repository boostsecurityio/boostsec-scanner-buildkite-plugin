#!/usr/bin/env bats

setup ()
{
  load '/usr/local/lib/bats/load.bash'

  # Uncomment to enable stub debugging
  # export GIT_STUB_DEBUG=/dev/tty
}

@test "Tests should run" {
  true
  assert_success
}

# vim: set ft=bash ts=2 sw=2 et :
