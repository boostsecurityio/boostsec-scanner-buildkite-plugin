#
# Makefile config
#
MAKEFLAGS       += --warn-undefined-variables
SHELL           := bash
.SHELLFLAGS     := -e -o pipefail -c
.DELETE_ON_ERROR:
.SUFFIXES:

-include $(PWD)/Makefile.conf

define usage
  @echo Usage: make [VAR=VALUE] TARGET [TARGET] [TARGET]
  @echo
  @echo Targets:
  @echo
  @grep -hE '^[-a-zA-Z_\.]+(.%)?:.*?## .*$$' $(MAKEFILE_LIST) | \
    sort | \
    awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
  @echo
  @if [ -n "$(ERROR)" ]; then \
  printf "\033[31m%s\033[0m\n" "$(ERROR)"; \
  echo; \
  exit 1; \
  fi
endef

#
# Global defaults
#
COMPOSE ?= docker-compose
DOCKER  ?= docker

#
# Targets
#
.PHONY: .phony
.phony:

help:  ## Displays usage information
help: ERROR = ""
help:
	$(usage)

lint:  ## Run linter in docker-compose
lint: .phony
	$(COMPOSE) run --rm lint

shell:  ## Execute a shell into an agent container
shell: .phony
	$(COMPOSE) run --rm shell

tests:  ## Run tests in docker-compose
tests: .phony
	$(COMPOSE) run --rm tests
