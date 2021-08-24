REPOS=configuration course-discovery credentials cs_comments_service devstack edx-notes-api edx-platform edx-proctoring edx-themes frontend-app-course-authoring frontend-app-gradebook frontend-app-learning frontend-app-program-console frontend-app-publisher frontend-build frontend-platform frontend-template-application xblock-free-text-response xblock-image-modal xblock-in-video-quiz xblock-qualtrics-survey xblock-sdk xblock-sql-grader xblock-submit-and-compare
SRC_PATH=${HOME}/edx/src
GITHUG_USERNAME=stvstnfrd
WORKON_HOME ?= $(HOME)/.local/virtualenvs
DEVSTACK_NAME ?= devstack3p0
VENV_PATH = $(WORKON_HOME)/$(DEVSTACK_NAME)
SUBMODULE_PATH = src/edx/src

DEFAULT_SERVICES=lms+studio+forum+frontend-app-learning+discovery
DEVSTACK_WORKSPACE=$(HOME)/edx/src
DEVSTACK_CHECKOUT=$(DEVSTACK_WORKSPACE)/devstack

MAKE_DEVSTACK_IN_VENV=. $(VENV_PATH)/bin/activate && make -C $(DEVSTACK_CHECKOUT)

.PHONY: init
checkout:  ## Initialize working directory with base repositories
	test -e "$(VENV_PATH)" || python3 -m venv "$(VENV_PATH)"
	test -e "$(DEVSTACK_CHECKOUT)" || git clone git@github.com:edx/devstack.git "$(DEVSTACK_CHECKOUT)"
	$(MAKE_DEVSTACK_IN_VENV) requirements
	$(MAKE_DEVSTACK_IN_VENV) down || true
	$(MAKE_DEVSTACK_IN_VENV) dev.clone
	@for repo in $(REPOS); do \
		repo_path=$(DEVSTACK_WORKSPACE)/$${repo}; \
		GIT_IN="git -C $${repo_path}"; \
		if [ -e "$${repo_path}" ]; then \
			echo 'it already exists'; \
		else \
			echo; echo "Check-out repo: $${repo}"; \
			git clone git@github.com:edx/$${repo}.git \
				$${repo_path} \
			; \
		fi \
	done

.PHONY: init
init:  ## Initialize working directory with base repositories
	@for repo in $(REPOS); do \
		if [ ! -e "$(SUBMODULE_PATH)/$${repo}" ]; then \
			echo; echo "Check-out repo: $${repo}"; \
			git submodule add git@github.com:edx/$${repo}.git \
				$(SUBMODULE_PATH)/$${repo} \
			; \
		fi \
	done

.PHONY: reassign
reassign:  ## Try to reassign origin to a fork
	@for repo in $(REPOS); do \
		repo_path=$(SUBMODULE_PATH)/$${repo}; \
		if [ -e "$${repo_path}" ]; then \
			GIT_IN="git -C $${repo_path}"; \
			if test -n "${GITHUG_USERNAME}" && \
				$${GIT_IN} remote -v \
				| grep '^origin\s' \
				| grep ':edx/' \
				> /dev/null \
			; then \
				echo; echo Try to reassign $$repo; \
				forked_url="git@github.com:${GITHUG_USERNAME}/$${repo}.git"; \
				if $${GIT_IN} remote add fork "$${forked_url}" >/dev/null 2>&1 && \
					$${GIT_IN} fetch fork >/dev/null 2>&1 \
				; then \
					echo "Reassigning..."; \
					git config --file=.gitmodules \
						submodule.$${repo_path}.url \
						$${forked_url} \
					; \
					$${GIT_IN} remote rename fork upstream; \
					$${GIT_IN} remote set-url upstream "git@github.com:edx/$${repo}.git"; \
					git submodule sync >/dev/null 2>&1; \
					$${GIT_IN} fetch --all --prune >/dev/null 2>&1; \
					$${GIT_IN} checkout master; \
					$${GIT_IN} reset --hard origin/master; \
				else \
					echo "No such fork exists: $${forked_url}"; \
					$${GIT_IN} remote remove fork || true; \
				fi \
			; \
			fi \
		fi \
	done

.PHONY: add-my-remote
add-my-remote:
	for repo in $(REPOS); do \
		echo SRC: $(SRC_PATH); \
		git -C $(SRC_PATH)/$${repo} remote -v ; \
	done

	# test -e "$(VENV_PATH)" || python3 -m venv "$(VENV_PATH)"
	# . $(VENV_PATH)/bin/activate && \
	make -C ./src/edx/src/devstack \
		requirements \
		dev.clone \
		dev.pull \
		dev.provision \
	;

.PHONY: update
update:  ## Update the core code and all submodules
	git fetch origin --prune
	# git rebase origin/master
	git submodule init
	git submodule update --recursive

provision-with-updates:
	test -e "$(VENV_PATH)" || python3 -m venv "$(VENV_PATH)"
	$(MAKE_DEVSTACK_IN_VENV) requirements
	$(MAKE_DEVSTACK_IN_VENV) down || true
	$(MAKE_DEVSTACK_IN_VENV) \
		dev.pull \
		dev.provision \
		dev.up \
		dev.migrate \
		lms-logs \
	;

from_scratch:
	test -e "$(VENV_PATH)" || python3 -m venv "$(VENV_PATH)"
	. $(VENV_PATH)/bin/activate && \
	$(MAKE_DEVSTACK_IN_VENV) \
		destroy \
		requirements \
		dev.clone \
		dev.pull \
		dev.provision \
		dev.up \
		lms-logs \
	;
