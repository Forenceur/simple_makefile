#include "example.h"

int main(int argc, char* argv[]) {
    int i = 0;
    puts("Hello world !");
    for (i=0; i<argc; ++i) {
        puts(argv[i]);
    }
    return 0;
}
