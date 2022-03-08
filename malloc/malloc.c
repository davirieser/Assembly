
// -------------------------------------------------------------------------- //

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#define brk my_brk_int
#define brk_long my_brk_long

extern void * brk(int x);
extern void * brk_long(long x);
extern void * get_brk();

// -------------------------------------------------------------------------- //

int main () {

    printf("Init (for some Reason printf allocates Heap Memory when first called)\n");

    int iLauf = 0;
    void * brks[10];

    brks[iLauf++] = brk(0);

    // This one will succeed.
    void * x = brk(0x1234);

    brks[iLauf++] = brk(0);

    // This one fails because the System will not allocate this much memory.
    void * y = brk_long(0xffffffffffffffff);

    brks[iLauf++] = brk(0);

    // This one will fail because you cannot call brk() using a negative number.
    void * u = brk(-1);

    brks[iLauf++] = brk(0);

    for (int iLauf2 = 0; iLauf2 < iLauf; iLauf2 ++)
        printf("C   Heap Base Pointer: %p \n", brks[iLauf2]);

    return 0;

}

void print_test(void * a) {
    printf("%p\n", a);
}

// -------------------------------------------------------------------------- //
