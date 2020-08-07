#ifndef __LIST_H__
#define __LIST_H__

#include <stddef.h>

/*
 * List class
 * adta type define
 */
struct list_head {
	struct list_head *next, *prev;
};

typedef struct list_head *List;

/*
 * Calculation struct element offset
 */
// #define offsetof(TYPE, MEMBER)	((unsigned int)&((TYPE *)0)->MEMBER)

/*
 * list function: Initialize list head
 * Return a list. It is empty
 */
void ListInit(struct list_head *P)
{
    P->next = P;
    P->prev = P;
}

/*
 * list function: Judge if a list is empty
 * Return turn(1) or false(0)
 */
int IsEmpty(struct list_head *listhead)
{
    return listhead->next == listhead;
}

/*
 * list function: Judge if a node of list is last.
 * Return turn(1) or false(0)
 */
int IsLast(List list_point, struct list_head *listhead)
{
    return list_point->next == listhead;
}

/*
 * list function: add a node after one node of list
 */
void Insert(List list_pointer, List list_new)
{
    list_new->next = list_pointer->next;
    list_new->prev = list_pointer;
    list_pointer->next = list_new;
    list_new->next->prev = list_new;
}

/*
 * list function: delete a node from list
 */
void Delete(List list_pointer)
{
    list_pointer->prev->next = list_pointer->next;
    list_pointer->next->prev = list_pointer->prev;
}

/*
 * list function: get a node that is counterpart of the pointer of list
 */
#define list_node(list_pointer, node_list_name, node_pointer) \
    (typeof(node_pointer))((char *)list_pointer - offsetof(typeof(*node_pointer), node_list_name))

/*
 * list function: get a node that is previous of the list object
 */
#define list_prev_node(list_pointer, node_list_name, node_pointer) \
    list_node((list_pointer)->prev, node_list_name, node_pointer)

/*
 * list function: get a node that is next of the list object
 */
#define list_next_node(list_pointer, node_list_name, node_pointer) \
    list_node((list_pointer)->next, node_list_name, node_pointer)

/*
 * list function: Travers the node from the pointer of list by "for"
 * Note: Not include the list pointer.
 */
#define list_for_from_node(listhead, list_pointer, node_list_name, node_pointer) \
    for(node_pointer = list_node((list_pointer)->next, node_list_name, node_pointer); \
        &((node_pointer)->node_list_name) != listhead; \
        node_pointer = list_node((node_pointer)->node_list_name.next, node_list_name, node_pointer))

/*
 * list function: Find a node where the element is located
 * This is a #define. It need be inputed head of list, name of list in node,
 * name of element in node, value of found element and a pointer to be assignmented
 */
#define Find(listhead, node_list_name, node_element_name, element, node_pointer) \
    ({ \
        list_for_from_node(listhead, listhead, node_list_name, node_pointer) \
            if((node_pointer)->node_element_name == element) \
                break; \
        if(&(node_pointer)->node_list_name == listhead) \
            node_pointer = NULL; \
    })

/*
 * list function: The similar as Find(), but the function get the former node
 */
#define FindPrevious(listhead, node_list_name, node_element_name, element, node_pointer) \
    ({ \
        Find(listhead, node_list_name, node_element_name, element, node_pointer) \
        node_pointer = list_node(&(node_pointer)->node_list_name.prev, node_list_name, node_pointer); \
    })

#endif