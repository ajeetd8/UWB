#ifndef __LB_STACK_H__
#define __LB_STACK_H__

#include "Ground.h"

//The definition of the Data.
typedef AllGround * Data;

//The definition of Node.
typedef struct _node
{
	Data data;
	struct _node * next;
} Node;

//The definition of Stack.
typedef struct _listStack
{
	Node * head;
} ListStack;

//Change the name from ListStack to Stack.
typedef ListStack Stack;

//Initialize the stack.
void StackInit(Stack * pstack);
//Check whether the stack is empty or not.
bool SIsEmpty(Stack * pstack);

// Three basics functoin for stack.
void SPush(Stack * pstack, Data data);
Data SPop(Stack * pstack);
Data SPeek(Stack * pstack);

//--------------------------------------------------------
/*
* A Stack search function. It return whether the same
* data exist or not. (== function must be override).
* param: pstack: address of stack.
* param: data: the set of data you are looking for.
*/
bool SSearch(Stack * pstack, Data data);

#endif