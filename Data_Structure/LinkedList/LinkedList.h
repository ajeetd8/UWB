#ifndef __LINKED_LIST_H__
#define __LINKED_LIST_H__

typedef int Object;

struct LNode
{
	Object * data;
	LNode * next;
};

//Single linked list, and it is opmized for the memory.
//Example:
//	LinkedList list;
//	list.insert(new Object());
//
//	if(list.LFirst())
//	{
//		//Do your work here.....
//
//		while(list.LNext())
//		{
//			//Do your work here.
//		}
//	}
class LinkedList
{
public:
	LinkedList();
	~LinkedList();
	LinkedList(LinkedList& list);

	void insert(Object * data);
	bool append(const int index, Object * data);
	Object *  get(int i);
	Object * remove(int i);
	void reverseIterate();
	void reverseRecursive();
	Object * LFirst();
	Object * LNext();
	Object * LRemove();
	int getNumberOfData() const;

private:
	LNode * head;
	LNode * tail;
	LNode * cur;
	LNode * before;
	int numOfData;
};

#include "LinkedList.cpp.h"

#endif
