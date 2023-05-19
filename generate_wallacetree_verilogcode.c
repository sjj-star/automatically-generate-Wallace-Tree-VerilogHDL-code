#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <math.h>
#include "list.h"

#define MAX_NAME_LEN 32

struct module_obj *all_graph[1024*40];

#define INPUTS 0
#define OUTPUTS 1

/* module library start */
#define HALF_ADDER 0
#define COMPRESSOR_3_2 1
#define COMPRESSOR_4_2 2
struct module_lib
{
    const char *name;
    const char **inports;
    const char **outports;
    int ins;
    int outs;
    float **io_latency;
};
struct module_lib module_libs[4];
/* module library end */

struct wire
{
    int component_id;
    char *name;
	struct list_head n_list;
	struct list_head ip_list;
    struct list_head op_list;
    float delay;
};

struct module_obj
{
    struct module_lib *lib;
    int id;
    int group;
    char *instance_name;
    struct list_head inports;
    struct list_head outports;
};

typedef struct {
    struct list_head head;
    int len;
} Queue;

int max(int a[], int len);
void Initqueue(Queue *Q);
void enqueue(Queue *Q, struct wire *entry);
struct wire *dequeue(Queue *Q);
struct module_obj *instance_module(int module, int component_id);
void update_out_delay(struct module_obj *obj);
int init_netlist(struct list_head net[], int netnums[], int width);
struct module_obj *init_top(struct list_head net[], int width, int type);
int wallacetree_graph(struct list_head net[], int netnums[], int width);
void generate_code(struct module_obj *graph[], int nums, struct list_head net[], int width);

void auto_assign(struct list_head net[], int width);

int main(int argc, const char *argv[])
{
    int i, nums;
    int width=argc-1;
	int *netnums = (int *)malloc(width*sizeof(int));
    struct list_head *net = (struct list_head *)malloc(width*sizeof(struct list_head));
    struct wire *in;

    if(width==0) {
        printf("None Parameters!\n");
        return -1;
    }
    for(i=0; i<width; i++) {
        sscanf(argv[i+1], "%d", &netnums[i]);
    }

/* Initialize module library start */
    module_libs[0].name = "half_adder";
    module_libs[0].ins = 2;
    module_libs[0].outs = 2;
    module_libs[0].inports = (const char **)malloc(module_libs[0].ins*sizeof(const char *));
    module_libs[0].inports[0] = "a";
    module_libs[0].inports[1] = "b";
    module_libs[0].outports = (const char **)malloc(module_libs[0].outs*sizeof(const char *));
    module_libs[0].outports[0] = "o";
    module_libs[0].outports[1] = "cout";
    module_libs[0].io_latency = (float **)malloc(module_libs[0].ins*sizeof(float *));
    for(i=0; i<module_libs[0].ins; i++)
        module_libs[0].io_latency[i] = (float *)malloc(module_libs[0].outs*sizeof(float));
    module_libs[0].io_latency[0][0] = 50.0;
    module_libs[0].io_latency[0][1] = 39.0;
    module_libs[0].io_latency[1][0] = 54.0;
    module_libs[0].io_latency[1][1] = 41.0;

    module_libs[1].name = "compressor_3_2";
    module_libs[1].ins = 3;
    module_libs[1].outs = 2;
    module_libs[1].inports = (const char **)malloc(module_libs[1].ins*sizeof(const char *));
    module_libs[1].inports[0] = "a";
    module_libs[1].inports[1] = "b";
    module_libs[1].inports[2] = "cin";
    module_libs[1].outports = (const char **)malloc(module_libs[1].outs*sizeof(const char *));
    module_libs[1].outports[0] = "o";
    module_libs[1].outports[1] = "cout";
    module_libs[1].io_latency = (float **)malloc(module_libs[1].ins*sizeof(float *));
    for(i=0; i<module_libs[1].ins; i++)
        module_libs[1].io_latency[i] = (float *)malloc(module_libs[1].outs*sizeof(float));
    module_libs[1].io_latency[0][0] = 71.0;
    module_libs[1].io_latency[0][1] = 62.0;
    module_libs[1].io_latency[1][0] = 75.0;
    module_libs[1].io_latency[1][1] = 70.0;
    module_libs[1].io_latency[2][0] = 77.0;
    module_libs[1].io_latency[2][1] = 68.0;

    module_libs[2].name = "compressor_4_2";
    module_libs[2].ins = 5;
    module_libs[2].outs = 3;
    module_libs[2].inports = (const char **)malloc(module_libs[2].ins*sizeof(const char *));
    module_libs[2].inports[0] = "a";
    module_libs[2].inports[1] = "b";
    module_libs[2].inports[2] = "c";
    module_libs[2].inports[3] = "d";
    module_libs[2].inports[4] = "cin";
    module_libs[2].outports = (const char **)malloc(module_libs[2].outs*sizeof(const char *));
    module_libs[2].outports[0] = "o";
    module_libs[2].outports[1] = "co";
    module_libs[2].outports[2] = "cout";
    module_libs[2].io_latency = (float **)malloc(module_libs[2].ins*sizeof(float *));
    for(i=0; i<module_libs[2].ins; i++)
        module_libs[2].io_latency[i] = (float *)malloc(module_libs[2].outs*sizeof(float));
    module_libs[2].io_latency[0][0] = 173.0;
    module_libs[2].io_latency[0][1] = 156.0;
    module_libs[2].io_latency[0][2] = 70.0;
    module_libs[2].io_latency[1][0] = 167.0;
    module_libs[2].io_latency[1][1] = 157.0;
    module_libs[2].io_latency[1][2] = 68.0;
    module_libs[2].io_latency[2][0] = 164.0;
    module_libs[2].io_latency[2][1] = 152.0;
    module_libs[2].io_latency[2][2] = 62.0;
    module_libs[2].io_latency[3][0] = 75.0;
    module_libs[2].io_latency[3][1] = 70.0;
    module_libs[2].io_latency[3][2] = -INFINITY;
    module_libs[2].io_latency[4][0] = 77.0;
    module_libs[2].io_latency[4][1] = 68.0;
    module_libs[2].io_latency[4][2] = -INFINITY;
/* Initialize module library end */

    nums = init_netlist(net, netnums, width);
    printf("this is input nets list :\n");
    for(i=0; i<width; i++) {
        printf("%2d: ", i);
        list_for_from_node((&net[i]), (&net[i]), n_list, in) {
            printf("%8s ", in->name);
        }
        printf("\n");
    }
    printf("the number of all nets: %d\n\n", nums);

    all_graph[0] = init_top(net, width, INPUTS);
    nums = wallacetree_graph(net, netnums, width);
    printf("the numbers of components: %d\n\n", nums);

    printf("%16s %8s %5s %24s\n", "module", "instance", "group", "input delay");
    for(i=0; i<nums; i++) {
        printf("%16s %8s %5d", all_graph[i]->lib->name, all_graph[i]->instance_name, all_graph[i]->group);
        list_for_from_node(&all_graph[i]->inports, &all_graph[i]->inports, ip_list, in) {
            printf(" %6.1f", in->delay);
        }
        printf("\n");
    }

    generate_code(all_graph, nums, net, width);

    return 0;
}

void generate_code(struct module_obj *graph[], int nums, struct list_head net[], int width)
{
    int i=0, n=0, id, start;
    const char **name;
    struct wire *w;

    printf("\n/* Input nets */\n");
    list_for_from_node(&graph[0]->outports, &graph[0]->outports, op_list, w) {
        if(i%6==0)
            printf("wire ");
        if(i%6==5 || IsLast(&w->op_list, &graph[0]->outports))
            printf("%8s;\n", w->name);
        else
            printf("%8s, ", w->name);
        i++;
    }

    printf("\n"
    "/*\n"
    " * Please insert your partial product generation module\n"
    " * interface signal allocation code here, you can use the\n"
    " * \"generate_wallacetree_verilogcode\" tool to output\n"
    " * the first part: \"input nets list\" information to write.\n"
    " */\n");

    for(i=1, start=1, id=1; i<nums+1; start = i, id = graph[i]->group) {
        printf("\n");
        for(; id == graph[i]->group && i<nums+1; i++) {
            w = list_next_node(&graph[i]->outports, op_list, w);
            printf("/* %s Output nets */\nwire %s", graph[i]->instance_name, w->name);
            list_for_from_node(&graph[i]->outports, &w->op_list, op_list, w) {
                if(*(w->name) != '\0')
                    printf(", %8s", w->name);
            }
            printf(";\n");
        }
        printf("\n/* compress stage %d */\n", id);
        for(i=start; id == graph[i]->group && i<nums+1; i++) {
            printf("%s %s(", graph[i]->lib->name, graph[i]->instance_name);
            name = graph[i]->lib->inports;
            n = 0;
            list_for_from_node(&graph[i]->inports, &graph[i]->inports, ip_list, w) {
                printf(".%s(%s), ", name[n++], w->name);
            }
            name = graph[i]->lib->outports;
            n = 0;
            list_for_from_node(&graph[i]->outports, &graph[i]->outports, op_list, w) {
                if(IsLast(&w->op_list, &graph[i]->outports))
                    printf(".%s(%s));\n", name[n++], w->name);
                else
                    printf(".%s(%s), ", name[n++], w->name);
            }
        }
    }

    printf( "\n/* Output nets Compression result */\n"
            "assign compress_a = {\n");
    for(i=width-1; i>=0; i--) {
        w = list_next_node(&net[i], n_list, w);
        if(i==0)
            printf("%8s", w->name);
        else
            printf("%8s,", w->name);
        if(i%4==0)
            printf("\n");
    }
    printf("};\n");

    printf("assign compress_b = {\n");
    for(i=width-1; i>=0; i--) {
        w = list_next_node(&net[i], n_list, w);
        if(IsLast(&w->n_list, &net[i]))
            if(i==0)
                printf("    1'b0");
            else
                printf("    1'b0,");
        else {
            w = list_prev_node(&net[i], n_list, w);
            if(i==0)
                printf("%8s", w->name);
            else
                printf("%8s,", w->name);
        }
        if(i%4==0)
            printf("\n");
    }
    printf("};\n");
}

int wallacetree_graph(struct list_head netgroup[], int netnums[], int width)
{
    int components=0, wires=0, stage=0;
    int i, j, sum_count=0;
    struct module_obj *new_component;
    struct wire *port, *net;
    Queue couts_half, couts_32, couts_42, couts;
    Queue cins_half, cins_32, cins_42, cins;
    Queue *Q;

    Initqueue(&couts_half);
    Initqueue(&couts_32);
    Initqueue(&couts_42);
    Initqueue(&couts);
    Initqueue(&cins_half);
    Initqueue(&cins_32);
    Initqueue(&cins_42);
    Initqueue(&cins);

    Iteration_level:
    printf("compress stage %d: ", stage);
    for(i=width-1; i>=0; i--)
        printf("%4d ", netnums[i]);
    printf("\n");

    stage++;
    if(max(netnums, width)==2) {
        all_graph[++components] = init_top(netgroup, width, OUTPUTS);
        all_graph[components]->id = components;
        all_graph[components]->group = stage;
        return components-1;
    }

    for(i=0; i<width; i++) {
        Iteration_column:
        if(netnums[i]>=5 ||
        (netnums[i]==4 && (!!cins_half.len || !!cins_32.len || !!cins_42.len)) ||
        (netnums[i]==3 && (cins_half.len + cins_32.len + cins_42.len)>=2)) {
            new_component = instance_module(COMPRESSOR_4_2, ++components);
            all_graph[components] = new_component;
            for (j = 0; j < 2; j++) {
                if (!!cins_half.len || !!cins_32.len || !!cins_42.len) {
                    if (!!cins_42.len)
                        Q = &cins_42;
                    else if (!!cins_32.len)
                        Q = &cins_32;
                    else
                        Q = &cins_half;
                    net = dequeue(Q);
                    Insert(&netgroup[i], &net->n_list);
                    netnums[i]++;
                }
            }
            for(j=0; j<5; j++,netnums[i]--) {
                net = list_next_node(&netgroup[i], n_list, net);
                net->component_id = components;
                Delete(&net->n_list);
                Insert(&new_component->inports, &net->ip_list);
            }
            port = list_next_node(&new_component->outports, op_list, port);
            Insert(netgroup[i].prev, &port->n_list);
            sprintf(port->name, "t_%d", wires++);
            if((i+1)<width) {
                port = list_next_node(&port->op_list, op_list, port);
                sprintf(port->name, "t_%d", wires++);
                enqueue(&couts, port);
                port = list_next_node(&port->op_list, op_list, port);
                sprintf(port->name, "t_%d", wires++);
                enqueue(&couts_42, port);
            }
            new_component->group = stage;
            update_out_delay(new_component);
            sum_count++;
            goto Iteration_column;
        }
        else
        if(netnums[i]+cins_42.len >= 3) {
            new_component = instance_module(COMPRESSOR_3_2, ++components);
            all_graph[components] = new_component;
            Q = &couts_32;
            for (j = 0; j < 3; j++) {
                if(!!cins_42.len) {
                    Q = &cins_42;
                    net = dequeue(Q);
                    Insert(&netgroup[i], &net->n_list);
                    netnums[i]++;
                    Q = &couts;
                }
            }
            for(j=0; j<3; j++) {
                net = list_next_node(&netgroup[i], n_list, net);
                Delete(&net->n_list);
                netnums[i]--;
                net->component_id = components;
                Insert(&new_component->inports, &net->ip_list);
            }
            port = list_next_node(&new_component->outports, op_list, port);
            Insert(netgroup[i].prev, &port->n_list);
            sprintf(port->name, "t_%d", wires++);
            if((i+1)<width) {
                port = list_next_node(&port->op_list, op_list, port);
                sprintf(port->name, "t_%d", wires++);
                enqueue(Q, port);
            }
            new_component->group = stage;
            update_out_delay(new_component);
            sum_count++;
            goto Iteration_column;
        }
        else if(netnums[i]+cins_42.len >= 2) {
            new_component = instance_module(HALF_ADDER, ++components);
            all_graph[components] = new_component;
            Q = &couts_half;
            for (j = 0; j < 2; j++) {
                if(!!cins_42.len) {
                    Q = &cins_42;
                    net = dequeue(Q);
                    Insert(&netgroup[i], &net->n_list);
                    netnums[i]++;
                    Q = &couts;
                }
            }
            for(j=0; j<2; j++,netnums[i]--) {
                net = list_next_node(&netgroup[i], n_list, net);
                Delete(&net->n_list);
                net->component_id = components;
                Insert(&new_component->inports, &net->ip_list);
            }
            port = list_next_node(&new_component->outports, op_list, port);
            Insert(netgroup[i].prev, &port->n_list);
            sprintf(port->name, "t_%d", wires++);
            if((i+1)<width) {
                port = list_next_node(&port->op_list, op_list, port);
                sprintf(port->name, "t_%d", wires++);
                enqueue(Q, port);
            }
            new_component->group = stage;
            update_out_delay(new_component);
            sum_count++;
            goto Iteration_column;
        }
        else {
            for(; !!cins_half.len || !!cins_32.len || !!cins_42.len || !!cins.len;) {
                if(!!cins_half.len)
                    Q = &cins_half;
                else if(!!cins_32.len)
                    Q = &cins_32;
                else if(!!cins_42.len)
                    Q = &cins_42;
                else if(!!cins.len)
                    Q = &cins;
                else
                    Q = NULL;
                port = dequeue(Q);
                Insert(netgroup[i].prev, &port->n_list);
                netnums[i]++;
            }
            for(; !!couts_half.len;)
                enqueue(&cins_half, dequeue(&couts_half));
            for(; !!couts_32.len;)
                enqueue(&cins_32, dequeue(&couts_32));
            for(; !!couts_42.len;)
                enqueue(&cins_42, dequeue(&couts_42));
            for(; !!couts.len;)
                enqueue(&cins, dequeue(&couts));
            netnums[i] += sum_count;
            sum_count = 0;
        }
    }
    goto Iteration_level;
}

struct module_obj *init_top(struct list_head net[], int width, int type)
{
    int i, n;
    List l;
    struct wire *p, *tmp;
    struct module_obj *top = malloc(sizeof(struct module_obj));

    top->lib = &module_libs[4];
    top->lib->name = "TOP";
    switch(type) {
    case INPUTS :
        top->id = 0;
        top->instance_name = "Inputs";
        ListInit(&top->inports);
        ListInit(&top->outports);
        for(i=0, l=&top->outports; i<width; i++) {
            list_for_from_node((&net[i]), (&net[i]), n_list, p) {
                p->component_id = -1;
                Insert(l, &p->op_list);
                l = &p->op_list;
            }
        }
        break;
    case OUTPUTS :
        top->instance_name = "Outputs";
        ListInit(&top->outports);
        ListInit(&top->inports);
        for(i=0, n=0, l=&top->inports; i<width; i++) {
            list_for_from_node((&net[i]), (&net[i]), n_list, p) {
                tmp = malloc(sizeof(struct wire));
                *tmp = *p;
                tmp->component_id = -1;
                Insert(l, &tmp->ip_list);
                l = &tmp->ip_list;
                n++;
            }
        }
        break;
    default: return NULL;
    }
    return top;
}

int init_netlist(struct list_head net[], int netnums[], int width)
{
    int i,j,n=0;
    struct wire *w;
    List l;

    for(i=0; i<width; i++) {
        ListInit(&net[i]);
        for(j=0, l=&(net[i]); j<netnums[i]; j++, n++, l=&w->n_list) {
            w = malloc(sizeof(struct wire));
            w->name = malloc(MAX_NAME_LEN);
            sprintf(w->name, "s_%d_%d", i, j);
            w->delay = 0.0;
            Insert(l, &w->n_list);
        }
    }
    return n;
}

struct module_obj *instance_module(int module, int component_id)
{
    struct module_obj *obj = malloc(sizeof(struct module_obj));

    obj->lib = &module_libs[module];
    obj->id = component_id;
    obj->instance_name = malloc(MAX_NAME_LEN);
    sprintf(obj->instance_name, "u%d_%d", module, component_id);

    int i;
    struct wire *p;
    List l;

    ListInit(&(obj->inports));

    ListInit(&(obj->outports));
    for(i=0, l=&(obj->outports); i<module_libs[module].outs; i++) {
        p = malloc(sizeof(struct wire));
        p->component_id = -1;
        p->name = malloc(MAX_NAME_LEN);
        *(p->name) = '\0';
        p->delay = 0.0;
        Insert(l, &(p->op_list));
        l = &(p->op_list);
    }

    return obj;
}

void update_out_delay(struct module_obj *obj)
{
    int i=0, o=0;
    struct wire *in, *out;

    list_for_from_node(&obj->outports, &obj->outports, op_list, out) {
        i = 0;
        list_for_from_node(&obj->inports, &obj->inports, ip_list, in) {
            if(out->delay < in->delay+obj->lib->io_latency[i][o])
                out->delay = in->delay+obj->lib->io_latency[i][o];
            i++;
        }
        o++;
    }
}

void Initqueue(Queue *Q)
{
    ListInit(&(Q->head));
    Q->len = 0;
}
void enqueue(Queue *Q, struct wire *entry)
{
    struct wire *p;
    if(IsEmpty(&(Q->head)))
        Insert(&(Q->head), &entry->n_list);
    else {
        p = list_prev_node(&(Q->head), n_list, p);
        Insert(&p->n_list, &entry->n_list);
    }
    Q->len++;
}
struct wire *dequeue(Queue *Q)
{
    struct wire *p;
    if(IsEmpty(&(Q->head)))
        return NULL;
    else {
        p = list_next_node(&(Q->head), n_list, p);
        Delete(&p->n_list);
        Q->len--;
        return p;
    }
}

int max(int a[], int len)
{
    int i, m;
    for(i=0,m=0; i<len; i++)
        if(a[i]>m)
            m = a[i];
    return m;
}
