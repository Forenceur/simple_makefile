./build/obj/debug/main.o build/dep/debug/main.d : src/main.c inc/example.h
	mkdir -p ./build/obj/debug
	gcc -o ./build/obj/debug/main.o -c src/main.c -W -Wall -ansi -pedantic -g -I ./inc