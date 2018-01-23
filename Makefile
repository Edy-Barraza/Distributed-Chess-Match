compile:
	ocamlbuild -use-ocamlfind board.byte gui.byte main.byte

server:
	ocamlbuild -use-ocamlfind server.byte
	./server.byte 12344

white:
	./gui.byte White 127.0.0.1 12344

black:
	./gui.byte Black 127.0.0.1 12344

main:
	./main.byte

clean:
	ocamlbuild -clean

test:
	ocamlbuild -use-ocamlfind test.byte
	./test.byte
