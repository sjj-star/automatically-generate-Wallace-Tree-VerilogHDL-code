#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include "list.h"

#define MAX_NAME_LEN 32

struct module_obj *all_graph[1024];

#define INPUTS 0
#define OUTPUTS 1

/* module library start */
#define HALF_ADDER 0
#define COMPRESSOR_3_2 1
#define COMPRESSOR_4_2 2
struct
{
    const char *name;
    const char *inports[2];
    const char *outports[2];
} m_0;
struct
{
    const char *name;
    const char *inports[3];
    const char *outports[2];
} m_1;
struct
{
    const char *name;
    const char *inports[5];
    const char *outports[3];
} m_2;

void *module_lib[3] = {&m_0, &m_1, &m_2};

#define module_info(id) ((const char **)(module_lib[id]+8))
/* module library end */

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

struct module_obj
{
    const char *module_name;
    int id;
    int group;
    char *instance_name;
    struct list_head inports;
    struct list_head outports;
    int indegree;
};

struct list_head Queue1, Queue2;

int max(int a[], int len);
void Initqueue(struct list_head *P);
int IsEmpty_queue(struct list_head *listhead);
void enqueue(struct list_head *listhead, struct wire *entry);
struct wire *dequeue(struct list_head *listhead);
struct module_obj *instance_module(int module, int component_id);
int init_netlist(struct list_head net[], int netnums[], int width);
struct module_obj *init_top(struct list_head net[], int width, int type);
int wallacetree_graph(struct list_head net[], int netnums[], int width);
void generate_code(struct module_obj *graph[], int nums, struct list_head net[], int width);

void auto_assign(struct list_head net[], int width);

int main(int argc, const char *argv[])
{
    int i, nums;
    int width=argc-1, *netnums=malloc(width*sizeof(int));
    struct list_head net[width];
    struct wire *in;

    if(width==0) {
        printf("None Parameters!\n");
        return -1;
    }
    for(i=0; i<width; i++) {
        sscanf(argv[i+1], "%d", &netnums[i]);
    }

/* Initialize module library start */
    m_0.name = "half_adder";
    m_0.inports[0] = "a";
    m_0.inports[1] = "b";
    m_0.outports[0] = "o";
    m_0.outports[1] = "cout";

    m_1.name = "compressor_3_2";
    m_1.inports[0] = "a";
    m_1.inports[1] = "b";
    m_1.inports[2] = "cin";
    m_1.outports[0] = "o";
    m_1.outports[1] = "cout";

    m_2.name = "compressor_4_2";
    m_2.inports[0] = "a";
    m_2.inports[1] = "b";
    m_2.inports[2] = "c";
    m_2.inports[3] = "d";
    m_2.inports[4] = "cin";
    m_2.outports[0] = "o";
    m_2.outports[1] = "co";
    m_2.outports[2] = "cout";
/* Initialize module library end */

    Initqueue(&Queue1);
    Initqueue(&Queue2);

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

    printf("%16s %8s %s\n", "module", "instance", "group");
    for(i=0; i<nums; i++) {
        printf("%16s %8s %d\n", all_graph[i]->module_name, all_graph[i]->instance_name, all_graph[i]->group);
    }

    generate_code(all_graph, nums, net, width);

    return 0;
}

void generate_code(struct module_obj *graph[], int nums, struct list_head net[], int width)
{
    int i=0, n=0, module, id, start;
    const char **name;
    struct wire *w;

    printf("\n/* Input nets */\n");
    list_for_from_node(&graph[0]->outports, &graph[0]->outports, op_list, w) {
        if(i%6==0)
            printf("wire ");
        printf("%8s, ", w->name);
        if(i%6==5)
            printf("\b\b;  \n");
        i++;
    }
    if(i%6!=5)
        printf("\b\b;  \n");

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
            printf("/* %s Output nets */\nwire ", graph[i]->instance_name);
            list_for_from_node(&graph[i]->outports, &graph[i]->outports, op_list, w) {
                if(*(w->name)!='\0')
                    printf("%8s,", w->name);
            }
            printf("\b;  \n");
        }
        printf("\n/* compress stage %d */\n", id);
        for(i=start; id == graph[i]->group && i<nums+1; i++, n=0) {
            printf("%s %s(", graph[i]->module_name, graph[i]->instance_name);
            sscanf(graph[i]->instance_name, "u%d%_%*d", &module);
            name = module_info(module);
            list_for_from_node(&graph[i]->inports, &graph[i]->inports, ip_list, w) {
                printf(".%s(%s), ", name[n++], w->name);
            }
            list_for_from_node(&graph[i]->outports, &graph[i]->outports, op_list, w) {
                printf(".%s(%s), ", name[n++], w->name);
            }
            printf("\b\b); \n");
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
    static int components=0, wires=0, stage=0;
    int i, j, count=0, carry_prse=0, carry_next=0;
    struct module_obj *new_component;
    struct wire *port, *net;
    List current_queue=&Queue1, next_queue=&Queue2;

    printf("compress stage %d: ", stage);
    for(i=width-1; i>=0; i--)
        printf("%d ", netnums[i]);
    printf("\n");

    stage++;
    if(max(netnums, width)==2) {
        all_graph[++components] = init_top(netgroup, width, OUTPUTS);
        all_graph[components]->id = components;
        all_graph[components]->group = stage;
        return components-1;
    }

    for(i=0; i<width; i++) {
Iteration:
        if(netnums[i]>=5) {
            new_component = instance_module(COMPRESSOR_4_2, ++components);
            all_graph[components] = new_component;
            if(IsEmpty_queue(current_queue))
                j=0;
            else {
                net = dequeue(current_queue);
                net->component_id = components;
                Insert(&new_component->inports, &net->ip_list);
                j=1;
            }
            for(; j<5; j++) {
                net = list_next_node(&netgroup[i], n_list, net);
                net->component_id = components;
                Delete(&net->n_list);
                Insert(&new_component->inports, &net->ip_list);
            }
            port = list_next_node(&new_component->outports, op_list, port);
            net = list_prev_node(&netgroup[i], n_list, net);
            Insert(&net->n_list, &port->n_list);
            sprintf(port->name, "t_%d", wires++);
            if((i+1)<width) {
                port = list_next_node(&port->op_list, op_list, port);
                net = list_prev_node(&netgroup[i+1], n_list, net);
                Insert(&net->n_list, &port->n_list);
                sprintf(port->name, "t_%d", wires++);
                port = list_next_node(&port->op_list, op_list, port);
                enqueue(next_queue, port);
                sprintf(port->name, "t_%d", wires++);
                netnums[i+1]++;
            }
            new_component->group = stage;
            new_component->indegree = 5;
            count++;
            netnums[i] -= 5;
            carry_next++;
            goto Iteration;
        }
        else if(netnums[i] >= 3) {
            new_component = instance_module(COMPRESSOR_3_2, ++components);
            all_graph[components] = new_component;
            if(IsEmpty_queue(current_queue))
                j=0;
            else {
                net = dequeue(current_queue);
                net->component_id = components;
                Insert(&new_component->inports, &net->ip_list);
                j=1;
            }
            for(; j<3; j++) {
                net = list_next_node(&netgroup[i], n_list, net);
                net->component_id = components;
                Delete(&net->n_list);
                Insert(&new_component->inports, &net->ip_list);
            }
            port = list_next_node(&new_component->outports, op_list, port);
            net = list_prev_node(&netgroup[i], n_list, net);
            Insert(&net->n_list, &port->n_list);
            sprintf(port->name, "t_%d", wires++);
            if((i+1)<width) {
                port = list_next_node(&port->op_list, op_list, port);
                net = list_prev_node(&netgroup[i+1], n_list, net);
                Insert(&net->n_list, &port->n_list);
                sprintf(port->name, "t_%d", wires++);
            }
            new_component->group = stage;
            new_component->indegree = 3;
            count++;
            netnums[i] -= 3;
            carry_next++;
            goto Iteration;
        }
        else if(netnums[i] == 2) {
            new_component = instance_module(HALF_ADDER, ++components);
            all_graph[components] = new_component;
            if(IsEmpty_queue(current_queue))
                j=0;
            else {
                net = dequeue(current_queue);
                net->component_id = components;
                Insert(&new_component->inports, &net->ip_list);
                j=1;
            }
            for(; j<2; j++) {
                net = list_next_node(&netgroup[i], n_list, net);
                net->component_id = components;
                Delete(&net->n_list);
                Insert(&new_component->inports, &net->ip_list);
            }
            port = list_next_node(&new_component->outports, op_list, port);
            net = list_prev_node(&netgroup[i], n_list, net);
            Insert(&net->n_list, &port->n_list);
            sprintf(port->name, "t_%d", wires++);
            if((i+1)<width) {
                port = list_next_node(&port->op_list, op_list, port);
                net = list_prev_node(&netgroup[i+1], n_list, net);
                Insert(&net->n_list, &port->n_list);
                sprintf(port->name, "t_%d", wires++);
            }
            new_component->group = stage;
            new_component->indegree = 2;
            count++;
            netnums[i] -= 2;
            carry_next++;
            goto Iteration;
        }
        else {
            for(; !IsEmpty_queue(current_queue);) {
                port = dequeue(current_queue);
                net = list_prev_node(&netgroup[i+1], n_list, net);
                Insert(&net->n_list, &port->n_list);
            }
            List tmp = current_queue;
            current_queue = next_queue;
            next_queue = tmp;
            netnums[i] += carry_prse + count;
            count = 0;
            carry_prse = carry_next;
            carry_next = 0;
        }
    }

    return wallacetree_graph(netgroup, netnums, width);
}

struct module_obj *init_top(struct list_head net[], int width, int type)
{
    int i, n;
    List l;
    struct wire *p, *tmp;
    struct module_obj *top = malloc(sizeof(struct module_obj));

    top->module_name = "TOP";
    switch(type) {
    case INPUTS :
        top->id = 0;
        top->instance_name = "Inputs";
        top->indegree = 0;
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
        top->indegree = n;
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
            Insert(l, &w->n_list);
        }
    }
    return n;
}

struct module_obj *instance_module(int module, int component_id)
{
    int out_nums;
    struct module_obj *obj = malloc(sizeof(struct module_obj));

    switch (module) {
    case HALF_ADDER :
        obj->module_name = m_0.name;
        out_nums = 2;
        break;
    case COMPRESSOR_3_2 :
        obj->module_name = m_1.name;
        out_nums = 2;
        break;
    case COMPRESSOR_4_2 :
        obj->module_name = m_2.name;
        out_nums = 3;
        break;
    default : return NULL;
    }
    obj->id = component_id;
    obj->instance_name = malloc(MAX_NAME_LEN);
    sprintf(obj->instance_name, "u%d_%d", module, component_id);

    int i;
    struct wire *p;
    List l;

    ListInit(&(obj->inports));

    ListInit(&(obj->outports));
    for(i=0, l=&(obj->outports); i<out_nums; i++) {
        p = malloc(sizeof(struct wire));
        p->component_id = -1;
        p->name = malloc(MAX_NAME_LEN);
        *(p->name) = '\0';
        Insert(l, &(p->op_list));
        l = &(p->op_list);
    }

    return obj;
}

void Initqueue(struct list_head *P)
{
    ListInit(P);
}
int IsEmpty_queue(struct list_head *listhead)
{
    return IsEmpty(listhead);
}
void enqueue(struct list_head *listhead, struct wire *entry)
{
    struct wire *p;
    if(IsEmpty(listhead))
        Insert(listhead, &entry->n_list);
    else {
        p = list_prev_node(listhead, n_list, p);
        Insert(&p->n_list, &entry->n_list);
    }
}
struct wire *dequeue(struct list_head *listhead)
{
    struct wire *p;
    if(IsEmpty(listhead))
        return NULL;
    else {
        p = list_next_node(listhead, n_list, p);
        Delete(&p->n_list);
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