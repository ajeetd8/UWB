#include <ctime>
#include <iostream>
#include <cstdlib>

template<class Object>
SList<Object>::SList()
{
	init();
}

template<class Object>
SList<Object>::SList(const SList &rhs)
{
	init();
	*this = rhs;                                   // then assign rhs to this.
}

template<class Object>
void SList<Object>::init()
{
	for (int i = 0; i < LEVEL; i++)  // for each level
	{
		// create the left most dummy nodes;
		header[i] = new SListNode<Object>;
		header[i]->prev = NULL;
		header[i]->down = (i > 0) ? header[i - 1] : NULL;
		header[i]->up = NULL;
		if (i > 0)
			header[i - 1]->up = header[i];

		// create the right most dummy nodes;
		header[i]->next = new SListNode<Object>;
		header[i]->next->next = NULL;
		header[i]->next->prev = header[i];
		header[i]->next->down = (i > 0) ? header[i - 1]->next : NULL;
		header[i]->next->up = NULL;
		if (i > 0)
			header[i - 1]->next->up = header[i]->next;
	}

	// reset cost.
	cost = 0;
}

template<class Object>
SList<Object>::~SList()
{
	clear();                                      // delete items starting 1st
	for (int i = 0; i < LEVEL; i++)
	{
		delete header[i]->next;                   // delete the right most dummy
		delete header[i];                          // delete the left most dummy
	}
}

template<class Object>
bool SList<Object>::isEmpty() const
{
	return (header[0]->next->next == NULL);
}

template<class Object>
int SList<Object>::size() const
{
	SListNode < Object > *p = header[0]->next; // at least the right most dummy
	int size = 0;

	for (; p->next != NULL; p = p->next, ++size)
		;
	return size;
}

template<class Object>
void SList<Object>::clear()
{
	for (int i = 0; i < LEVEL; i++)
	{        // for each level
		SListNode < Object > *p = header[i]->next;  // get the 1st item
		while (p->next != NULL)
		{              // if this is not the left most
			SListNode < Object > *del = p;
			p = p->next;                           // get the next item
			delete del;                            // delete the current item
		}

		header[i]->next = p;                    // p now points to the left most
	}                                          // let the right most point to it
}
//------------------------------------------------------------------------
/**
 * This is the function that I implement with instruction.
 * This function will insert node into the skiplist, and randomly decide whether
 * it will add up node to imporve the searching speed.
 * Assumption: Other part of code is perfect.
 */
template<class Object>
void SList<Object>::insert(const Object &obj)
{
	// right points to the level-0 item before which a new object is inserted.
	SListNode < Object > *right = searchPointer(obj);
	SListNode < Object > *up = NULL;

	if (right->next != NULL && right->item == obj)	// there is an identical object
		return;

	//Add node from the bottom.
	SListNode<Object> * addNode = new SListNode<Object>;
	addNode->item = obj;
	addNode->prev = right->prev;
	addNode->next = right;
	addNode->up = NULL;
	addNode->down=NULL;
	right->prev->next = addNode;
	right->prev = addNode;
	right = addNode;			//Move right to the current object.

	//Randomly decide whether we make up-node.
	bool decision = (rand() % 2);	//flip the coin.

	for(int i = 1; (decision && i < LEVEL); i++)
	{
		//Find the closest node which has up.
		while(right->up == NULL)
			right = right->prev;

		//Alleviate up and goto rightside.
		right = right->up->next;

		//Making up-node to insert
		up = new SListNode<Object>;
		up->item = obj;
		up->prev = right->prev;
		up->next = right;
		up->up = NULL;
		up->down=addNode;
		addNode->up = up;
		right->prev->next = up;
		right->prev = up;

		//Move index location to the node we add.
		right = up;
		addNode = up;

		//Make another decision.
		decision = (rand() % 2);
	}

}

template<class Object>
bool SList<Object>::find(const Object &obj)		// points to the level-0 item close to a given object
{
	SListNode < Object > *p = searchPointer(obj);

	return (p->next != NULL && p->item == obj);     // true if obj was found
}

template<class Object>
SListNode<Object> *SList<Object>::searchPointer(const Object &obj)
{
	SListNode < Object > *p = header[LEVEL - 1];     // start from the top left
	while (p->down != NULL)							// toward level 0
	{
		p = p->down;                                // shift down once
		cost++;

		if (p->prev == NULL)						// at the left most item
		{
			if (p->next->next == NULL)              // no intermediate items
				continue;
			else									// some intermediate items
			{
				if (p->next->item <= obj)			// if 1st item <= obj
					p = p->next;					// shift right to item 1
				cost++;
			}
		}

		while (p->next->next != NULL && p->next->item <= obj) // shift right through intermediate items as far as the item value <= obj
		{
			p = p->next;
			cost++;
		}
	}

	// now reached the bottom. shift right once if the current item < obj
	if (p->prev == NULL || p->item < obj)
	{
		p = p->next;
		cost++;
	}
	return p; // return the pointer to an item >= a given object.
}

//-------------------------------------------------------------------
/**
 * When delete is called with the specific object, the function will find the
 * object and delete the object. (Since the list does not allow duplification, 
 * we don't need to worry about duplification).
 * Assumption: Other part of code is perfect.
 */
template<class Object>
void SList<Object>::remove(const Object &obj)
{
	// p points to the level-0 item to delete
	SListNode < Object > *p = searchPointer(obj);

	// validate if p is not the left most or right most and exactly contains the
	// item to delete
	if (p->prev == NULL || p->next == NULL || p->item != obj)
		return;

	// deleting the object from the down.
	while(p->up != NULL)
	{
        // Link left and right.
		p->prev->next = p->next;
		p->next->prev = p->prev;

		p=p->up;
		cout<<"Deleting unknown"<<endl;
		delete p->down;
	}

	//deleting the highest node.
    p->prev->next = p->next;
    p->next->prev = p->prev;
	delete p;

}

template<class Object>
const SList<Object> &SList<Object>::operator=(const SList &rhs)
{
	if (this != &rhs)
	{ // avoid self-assignment
		clear();           // deallocate old items

		int index;
		SListNode < Object > *rnode;
		for (index = 0, rnode = rhs.header[0]->next; rnode->next != NULL;
				rnode = rnode->next, ++index)
			insert(rnode->item);

		cost = rhs.cost;
	}
	return *this;
}

template<class Object>
int SList<Object>::getCost() const
{
	return cost;
}

template<class Object>
void SList<Object>::show() const
{
	cout << "contents:" << endl;
	for (SListNode < Object > *col = header[0]; col != NULL; col = col->next)
	{
		SListNode < Object > *row = col;
		for (int level = 0; row != NULL && level < LEVEL; level++)
		{
			if (row->prev == NULL)
				cout << "-inf\t";
			else if (row->next == NULL)
				cout << "+inf\t";
			else
				cout << row->item << "\t";
			row = row->up;
		}
		cout << endl;
	}
}

