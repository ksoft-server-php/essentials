# Makefile modules:
include mak/flags.mak
include mak/cmd.mak
include mak/path.mak
include mak/message.mak
include mak/utils.mak

# Project-specific configuration:
# Directories
DIR_BIN				:= $(DIR_ROOT)vendor/bin/
DIR_SRC				:= $(DIR_ROOT)src/
DIR_ENV				:= $(DIR_ROOT)env/
DIR_TMP				:= $(DIR_ROOT)tmp/
DIR_TOOL			:= $(DIR_ROOT)tools/

DIR_TEST			:= $(DIR_TMP)testers/
DIR_FORMAT			:= $(DIR_TMP)formatters/

# Other
DOCKER_CONTEXT		:= $(DIR_ENV)
DOCKER_VOLUME		:= /volume
DOCKER_IMAGE		:= php-webutils

# Targets
all: format static test

init:
	$(info $(MSG_INIT))
	docker build --tag $(DOCKER_IMAGE) $(DOCKER_CONTEXT)
	docker run --rm --interactive --tty --volume $(DIR_ROOT):$(DOCKER_VOLUME) $(DOCKER_IMAGE) \
		sh -c "composer update --prefer-stable --prefer-dist --no-interaction && sh"

format:
	$(info $(MSG_FORMAT))
	$(MK) $(DIR_FORMAT)
	composer normalize
	$(CD) $(DIR_TOOL) && $(DIR_BIN)php-cs-fixer fix

static:
	$(info $(MSG_STATIC))
	$(CD) $(DIR_TOOL) && $(DIR_BIN)phpstan analyse

test:
	$(info $(MSG_TEST))
	$(MK) $(DIR_TEST)
	$(CD) $(DIR_TOOL) && XDEBUG_MODE=coverage $(DIR_BIN)phpunit

clean:
	$(info $(MSG_CLEAN))
	$(ECHO) "$(GREEN)Removing $(DIR_TMP) ...$(RESET)"
	$(RM) $(DIR_TMP)

# Special
.PHONY: init all docker composer format static test clean
