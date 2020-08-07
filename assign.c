#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include "list.h"

#define MAX_NAME_LEN 32

struct wire
{
    int component_id;
    char *name;
    struct list_head op_list;
    union {
        struct list_head n_list;
        struct list_head ip_list;
    };
};

int init_netlist(struct list_head net[], int netnums[], int width);
void auto_assign(struct list_head net[], int width);

int main(int argc, const char *argv[])
{
    int i;
    int width=argc-1, *netnums=malloc(width*sizeof(int));
    struct list_head net[width];

    if (width==0) {
        printf("None Parameters!\n");
        return -1;
    }
    for (i=0; i<width; i++) {
        sscanf(argv[i+1], "%d", &netnums[i]);
    }

    init_netlist(net, netnums, width);
    auto_assign(net, width);

    return 0;
}

void auto_assign(struct list_head net[], int width)
{
    int i, j, n;
    struct wire *w;

    width = width/2;
    printf("assign {\n");
    for (i=width-2, j=0; i>=0; i-=2, j++) {
        w = list_prev_node(&net[i], n_list, w);
        printf("%8s, ", w->name);
        Delete(&w->n_list);
        if (j%6==5)
            printf("\n");
    }
    if (j%6!=5)
        printf("\b\b  \n");
    printf("} = carry;\n\n");

    for(i=0; i<width/2; i++) {
        printf("assign {\n");
        for(j=(width+2)+(i*2)-1, n=0; j>=(i*2); j--, n++) {
            w = list_next_node(&net[j], n_list, w);
            printf("%8s, ", w->name);
            Delete(&w->n_list);
            if (n%6==5)
                printf("\n");
        }
        if (n%6!=5)
            printf("\b\b  \n");
        printf("} = partial_products[(width+2)*(%d+1)-1:(width+2)*%d];\n\n", i, i);
    }

    printf("assign {\n");
    for(i=width*2-1, n=0; i>=width; i--, n++) {
        w = list_next_node(&net[i], n_list, w);
        printf("%8s, ", w->name);
        Delete(&w->n_list);
        if (n%6==5)
            printf("\n");
    }
    if (n%6!=5)
        printf("\b\b  \n");
    printf("} = partial_products[(width+2)*(width/2+1)-1:(width+2)*width/2+2];\n\n");
}

int init_netlist(struct list_head net[], int netnums[], int width)
{
    int i, j, n=0;
    struct wire *w;
    List l;

    for (i=0; i<width; i++) {
        ListInit(&net[i]);
        for (j=0, l=&(net[i]); j<netnums[i]; j++, n++, l=&w->n_list) {
            w = malloc(sizeof(struct wire));
            w->name = malloc(MAX_NAME_LEN);
            sprintf(w->name, "s_%d_%d", i, j);
            Insert(l, &w->n_list);
        }
    }
    return n;
}