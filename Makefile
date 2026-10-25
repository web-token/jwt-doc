# The documentation of Beffroi. "make install" once, "make serve" to write, "make check" before a pull
# request. Every target runs in .venv, created from requirements.txt, with uv when it is installed.

VENV := .venv
BIN := $(VENV)/bin
UV := $(shell command -v uv 2>/dev/null)

# News about the MkDocs ecosystem, not findings about this site. requirements.txt pins the 1.x line.
export NO_MKDOCS_2_WARNING := true
export DISABLE_MKDOCS_2_WARNING := true

.DEFAULT_GOAL := help
.PHONY: help install serve build check versions clean

help: ## Show this help
	@grep -E '^[a-z-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

$(BIN)/mkdocs: requirements.txt
ifdef UV
	uv venv --allow-existing $(VENV)
	VIRTUAL_ENV=$(VENV) uv pip install -r requirements.txt
else
	python3 -m venv $(VENV)
	$(BIN)/pip install --upgrade pip
	$(BIN)/pip install -r requirements.txt
endif
	@touch $(BIN)/mkdocs

install: $(BIN)/mkdocs ## Install the toolchain in .venv

serve: install ## Serve the site on http://127.0.0.1:8000, rebuilt as you save
	$(BIN)/mkdocs serve

build: install ## Build the site into site/
	$(BIN)/mkdocs build

check: install ## Build strictly: a broken link, a missing anchor or a page outside the navigation fails
	$(BIN)/mkdocs build --strict

versions: install ## List the versions published on gh-pages
	$(BIN)/mike list

clean: ## Remove the build and the virtual environment
	rm -rf site $(VENV)
