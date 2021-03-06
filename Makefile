SHELL := bash

build:
	opam exec dune -- build @install --profile=dev

release:
	opam exec dune -- build @install --profile=release

test:
	OCAMLRUNPARAM=b opam exec dune -- runtest

test_update:
	-opam exec dune -- runtest --auto-promote

coverage:
	opam exec dune -- clean
	OCAMLRUNPARAM=b BISECT_ENABLE=yes opam exec dune -- runtest
	opam exec bisect-ppx-report -- -html=_coverage \
		-coveralls=_coverage/coverage.json \
		-I=_build/default/ \
		_build/default/**/bisect*.out

clean:
	opam exec dune -- clean

fmt:
	-opam exec dune -- build @fmt --auto-promote

doc:
	opam exec dune -- build @doc

dep:
	opam install . --deps-only --with-test

install: release
	opam install .

uninstall: release
	opam remove .

.PHONY: build test clean fmt doc release install uninstall test_update coverage dep
