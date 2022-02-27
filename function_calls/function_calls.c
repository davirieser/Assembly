
// -------------------------------------------------------------------------- //

#include <stdint.h>
#include <stdio.h>

#define i64 int64_t

// -------------------------------------------------------------------------- //

extern int asm_test(
    i64 a1, i64 a2, i64 a3, i64 a4, i64 a5, i64 a6, i64 a7, i64 a8
);

i64 c_test (
    i64 a1, i64 a2, i64 a3, i64 a4, i64 a5, i64 a6, i64 a7, i64 a8
);

// -------------------------------------------------------------------------- //

int main () {

    i64 result = asm_test(
        420, 69, 42069, 69420, 6969, 420420, 42, 4269
    );

    if (result) {
        printf("Everything went right: %li\n", result);
    } else {
        printf("Something went wrong!\n");
    }

    // return c_test(
    //     4269, 42, 420420, 6969, 69420, 42069, 69, 420
    // );

}

// -------------------------------------------------------------------------- //

i64 c_test (
    i64 a1, i64 a2, i64 a3, i64 a4, i64 a5, i64 a6, i64 a7, i64 a8
) {
    // printf("%li \n%li \n%li \n%li \n%li \n%li \n%li \n%li \n", a1, a2,a3,a4,a5,a6, a7, a8);
    if (
        (a1 == 4269) && (a2 == 42) && (a3 == 420420) && (a4 == 6969) &&
        (a5 == 69420) && (a6 == 42069) && (a7 == 69) && (a8 == 420))
    {
        printf("Successful called Function\n");
        return 0;
    } else {
        printf("Error calling Function\n");
        return 1;
    }
}

// -------------------------------------------------------------------------- //
