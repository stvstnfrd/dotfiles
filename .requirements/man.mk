MAN_COMMANDS=
COMMAND_DIR=$(HOME)/.local/bin
MAN_DIR=$(HOME)/.local/share/man/man1
MAN_FILES:=$(addprefix $(MAN_DIR)/,$(MAN_COMMANDS))
MAN_FILES:=$(addsuffix .1,$(MAN_FILES))
PANDOC=pandoc
PANDOC_ARGS=--standalone
PANDOC_PREPROCESS=convert-help-to-markdown

.PHONY: man
man: $(MAN_FILES)  ## Generate local man pages

$(MAN_DIR)/%.1: $(COMMAND_DIR)/%
	"$(<)" -h \
	| "$(PANDOC_PREPROCESS)" \
	| "$(PANDOC)" $(PANDOC_ARGS) --from markdown --to man -o "$(@)"
