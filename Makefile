SHELL = /bin/bash

.DEFAULT_GOAL := all

PREFIX_ARG := $(if $(PREFIX),--prefix $(PREFIX),)
LIBDIR_ARG := $(if $(LIBDIR),--libdir $(LIBDIR),)
DESTDIR_ARG := $(if $(DESTDIR),--destdir $(DESTDIR),)
INSTALL_ARGS := $(PREFIX_ARG) $(LIBDIR_ARG) $(DESTDIR_ARG)

.PHONY: all
all: clean build

.PHONY: dev
dev: ## Create an opam switch and install development dependencies
	opam update
	# Ensuring that either a dev switch already exists or a new one is created
	[[ $(shell opam switch show) == $(shell pwd) ]] || \
		opam switch create -y . ocaml-base-compiler.4.12.0 --deps-only --with-test --with-doc
	opam install -y dune-release merlin ocamlformat utop ocaml-lsp-server

.PHONY: install
install: all ## Install the packages on the system
	opam exec -- dune install --root . $(INSTALL_ARGS) cvrdt

.PHONY: uninstall
uninstall: ## Uninstall the packages from the system
	opam exec -- dune uninstall --root . $(INSTALL_ARGS) cvrdt

.PHONY: fmt
fmt:
	opam exec -- dune build @fmt --auto-promote

.PHONY: check
check:
	opam exec -- dune build @check

.PHONY: build
build:
	opam exec -- dune build

.PHONY: test
test: clean
	opam exec -- dune runtest

.PHONY: clean
clean:
	opam exec -- dune clean

.PHONY: doc
doc: ## Generate odoc documentation
	opam exec -- dune build --root . @doc

.PHONY: servedoc
servedoc: doc ## Open odoc documentation with default web browser
	xdg-open _build/default/_doc/_html/index.html

.PHONY: lock
lock: ## Generate a lock file
	opam lock -y .

.PHONY: repl
repl:
	opam exec -- dune utop lib -- -implicit-bindings

.PHONY: watch
watch:
	opam exec -- dune build --watch
