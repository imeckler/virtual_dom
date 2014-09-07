all:
	oasis setup
	ocaml setup.ml -configure
	ocaml setup.ml -build

clean:
	rm myocamlbuild.ml setup.data setup.log setup.ml
