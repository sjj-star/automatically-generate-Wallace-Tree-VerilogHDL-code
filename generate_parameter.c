#include <stdio.h>

#define width 32

int main(void)
{
    int a[width/2+1][width*2]={0};
    int i, j;

    for(i=0; i<width/2; i++) {
        for(j=i*2, a[i][j]+=1; j<(i+1)*2+width; j++) {
            a[i][j]++;
        }
    }
    for(i=width; i<width*2; i++) {
        a[width/2][i]++;
    }
    for(i=1; i<width/2+1; i++) {
        for(j=0; j<width*2; j++) {
            a[0][j] += a[i][j];
        }
    }
    for(i=0; i<width*2; i++)
        printf("%d ", a[0][i]);
    printf("\n\n");
    return 0;
}
