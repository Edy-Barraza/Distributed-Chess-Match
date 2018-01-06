compile:
	ocamlbuild board.byte
	ocamlbuild -pkgs graphics gui.byte -lib unix
	ocamlbuild -use-ocamlfind main.byte -pkgs graphics

server:
	ocamlbuild server.byte -lib unix
	./server.byte 12344

white1:
	./gui.byte White 127.0.0.1 12344

black1:
	./gui.byte Black 127.0.0.1 12344

main: 
	ocamlbuild -use-ocamlfind main.byte -pkgs graphics
	./main.byte
