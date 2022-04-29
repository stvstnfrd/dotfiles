#!/usr/bin/make -f
DOCKER_FILES=$(wildcard ./.requirements/docker/*-*.dockerfile)
DOCKER_TARGETS=$(subst .dockerfile,,$(subst ./.requirements/docker/,,$(DOCKER_FILES)))
DOCKER_BUILD_TARGETS=$(addprefix docker.build.,$(DOCKER_TARGETS))
DOCKER_SHELL_TARGETS=$(addprefix docker.shell.,$(DOCKER_TARGETS))
DOCKER_RUN=docker run --hostname dotfiles
DOCKER_SHELLS=sh bash zsh
DOCKER_COMMAND=
ifneq ($(DOCKER_COMMAND),)
DOCKER_COMMAND_FLAG=-c '$(DOCKER_COMMAND)'
else
DOCKER_COMMAND_FLAG=
endif

.PHONY: docker.files
docker.files: $(DOCKER_FILES)  ## Rebuild dockerfiles from the base ./Dockerfile
$(DOCKER_FILES): Dockerfile .requirements/docker.mk
	@echo "Updating:	$(@)"
	@name="$(notdir $(basename $(@)))"; \
	id="$$(echo "$${name}" | cut -d '-' -f 1)"; \
	codename="$$(echo "$${name}" | cut -d '-' -f 2)"; \
	{ \
		echo "# This file was created automatically by: .requirements/docker.mk"; \
		sed \
			-e "s@^FROM .*\$$@FROM $${id}:$${codename}@" \
			'$(<)' \
		; \
	} \
	>'$(@)' \
	;
	@echo "Updated: $(@)"

.PHONY: docker.build
docker.build:  ## Build a docker container; choose base with docker.build.*
	@echo "Usage:"
	@for target in $(DOCKER_BUILD_TARGETS); \
	do \
		printf '\tmake %s\n' "$${target}"; \
	done

.PHONY: $(DOCKER_BUILD_TARGETS)
$(DOCKER_BUILD_TARGETS):  ## Build a docker container; from a specific base
	@echo "Building:	$(@)"
	@id="$(basename $(subst -,.,$(subst docker.build.,,$(@))))"; \
	codename="$(subst .,,$(suffix $(subst -,.,$(subst docker.build.,,$(@)))))"; \
	tag="dotfiles-$${id}:$${codename}"; \
	dockerfile="./.requirements/docker/$${id}-$${codename}.dockerfile"; \
	$(MAKE) "./.requirements/deb/$${id}-$${codename}.cfg" "$${dockerfile}"; \
	docker build -t "$${tag}" --file "$${dockerfile}" .
	@echo "Built:	$(@)"

.PHONY: docker.lint.all
docker.lint.all:  ## Start a container and run the linter against all files
	$(DOCKER_RUN) -v $(PWD):/root/.config/dotfiles --rm -it dotfiles:latest \
		bash -c "$(LINT_SH_SHEBANG) | less -R --quit-if-one-screen"

docker.lint.diff:  ## Start a container and run the linter against changed files
	$(DOCKER_RUN) -v $(PWD):/root/.config/dotfiles --rm -it dotfiles:latest \
		bash -c "$(LINT_SH_DIFF) | less -R --quit-if-one-screen"

.PHONY: docker.shell
docker.shell:  ## Start a container with a new --login shell; choose ${SHELL} with docker.shell.*
	@echo "Usage:"
	@for target in $(DOCKER_SHELL_TARGETS); \
	do \
		for shell in $(DOCKER_SHELLS); \
		do \
			if [ "$${shell}" = sh ]; \
			then \
				printf '\tmake %s\n' "$${target}"; \
			else \
				printf '\tmake %s SHELL=%s\n' "$${target}" "$${shell}"; \
			fi \
		done \
	done
	@echo
	@echo 'You can also specify a command to be run by the shell by setting the COMMAND variable, like:'
	@printf '\t%s\n' "make docker.shell.ubuntu-jammy COMMAND='ls -al'"

.PHONY: $(DOCKER_SHELL_TARGETS)
$(DOCKER_SHELL_TARGETS):  ## Start a container with a new --login shell, customize via ${SHELL}
	@id="$(basename $(subst -,.,$(subst docker.shell.,,$(@))))"; \
	codename="$(subst .,,$(suffix $(subst -,.,$(subst docker.shell.,,$(@)))))"; \
	tag="dotfiles-$${id}:$${codename}"; \
	image_id=$$(docker image ls "$${tag}" --quiet); \
	[ -n "$${image_id}" ] || $(MAKE) docker.build.$${id}-$${codename}; \
	$(DOCKER_RUN) --rm -it \
		--name dotfiles \
		"dotfiles-$${id}:$${codename}" \
		"$(SHELL)" --login $(DOCKER_COMMAND_FLAG) \
	;
