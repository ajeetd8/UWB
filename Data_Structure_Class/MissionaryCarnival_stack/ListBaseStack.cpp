#include <cstdio>
#include <cstdlib>
#include "ListBaseStack.h"

void StackInit(Stack * pstack)
{
	pstack->head = NULL;
}

bool SIsEmpty(Stack * pstack)
{
	if (pstack->head == NULL)
		return true;
	else
		return false;
}

void SPush(Stack * pstack, Data data)
{
	Node * newNode = new Node;

	newNode->data = data;
	newNode->next = pstack->head;

	pstack->head = newNode;
}

Data SPop(Stack * pstack)
{
	Data rdata;
	Node * rnode;

	if (SIsEmpty(pstack)) {
		printf("Stack Memory Error!");
		exit(-1);
	}

	rdata = pstack->head->data;
	rnode = pstack->head;

	pstack->head = pstack->head->next;
	delete rnode;

	return rdata;
}

Data SPeek(Stack * pstack)
{
	if (SIsEmpty(pstack)) {
		printf("Stack Memory Error!");
		exit(-1);
	}

	return pstack->head->data;
}

bool SSearch(Stack * pstack, Data data)
{
	Node * temp = pstack->head;

	if (SIsEmpty(pstack))
	{
		return false;
	}
	else
	{
		while (temp != NULL)
		{
			if (*(temp->data) == *(data))
			{
				return true;
			}
			temp = temp->next;
		}
	}

	return false;
}