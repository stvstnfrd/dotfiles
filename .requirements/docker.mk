#!/usr/bin/make -f
.PHONY: docker.build
docker.build:  ## Build a docker container
	docker build -t dotfiles:latest .

DOCKER_RUN=docker run --hostname dotfiles
.PHONY: docker.lint
docker.lint:  ## Start a container and run the linter
	$(DOCKER_RUN) -v $(PWD):/root/.config/dotfiles --rm -it dotfiles:latest \
		bash -c "$(LINT_SH_SHEBANG) | less -R --quit-if-one-screen"

docker.lint.diff:  ## Start a container and run the linter against changed files
	$(DOCKER_RUN) -v $(PWD):/root/.config/dotfiles --rm -it dotfiles:latest \
		bash -c "$(LINT_SH_DIFF) | less -R --quit-if-one-screen"

docker.bash:  ## Start a container in a bash shell
	$(DOCKER_RUN) --rm -it --name dotfiles dotfiles:latest bash --login

docker.zsh:  ## Start a container in a zsh shell
	$(DOCKER_RUN) --rm -it --name dotfiles dotfiles:latest zsh --login

docker.sh:  ## Start a container in a POSIX shell
	$(DOCKER_RUN) --rm -it --name dotfiles dotfiles:latest sh --login
