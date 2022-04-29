#!/usr/bin/make -f
CURL=curl
DOCKER_EXISTS=$(shell command -v docker 2>&1 >/dev/null && echo 1 || echo 0)
DOCKER_COMPOSE_EXISTS=$(shell command -v docker-compose 2>&1 >/dev/null && echo 1 || echo 0)
ifneq ($(EUID),0)
SUDO=sudo
else
SUDO=
endif

.PHONY: system
system:  ## Bootstrap and install system packages
	$(SUDO) $(MAKE) system.apt
	$(MAKE) system.docker
	$(MAKE) system.brew
	$(MAKE) system.nix
	$(MAKE) system.pip

system.docker:
ifeq ($(DOCKER_EXISTS),0)
	$(CURL) -fsSL https://get.docker.com -o /tmp/get-docker.sh
	$(SUDO) sh /tmp/get-docker.sh
endif
	$(SUDO) usermod -aG docker "$(USER)"
ifeq ($(DOCKER_COMPOSE_EXISTS),0)
	$(SUDO) $(CURL) -L \
		"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(shell uname -s)-$(shell uname -m)" \
		-o /usr/local/bin/docker-compose \
	;
endif
