
#include <stdio.h>

extern char* i2a(char* s, long int num);

int main () {

    char x1[20];
    char x2[20];
    char x3[20];

    char * y1 = i2a(x1, 10);
    char * y2 = i2a(x2, -10);
    char * y3 = i2a(x2, 0);

    printf("%s\n", y1);
    printf("%s\n", y2);
    printf("%s\n", y3);

    return 0;

}
