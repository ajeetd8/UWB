#include <iostream>
#include "LinkedList.h"
using namespace std;


// Default constructor for the LinkedList class.
// Set the member variable and class to NULL(0);
LinkedList::LinkedList()
	:cur(NULL), numOfData(0), before(NULL), tail(NULL), head(NULL) { }



LinkedList::~LinkedList()
{
	Object * data;

	//Deleting every dynamically allocated object.
	if ((data = LFirst()) != NULL)
	{
		LRemove();
		delete data;
		while ((data = LNext()))
		{
			LRemove();
			delete data;
		}
	}
}

// Copy Constructor for the LinkedList class.
// Operate deep copy, and dynamically allocate the object.
LinkedList::LinkedList(LinkedList & list)
	:LinkedList()
{

	if (list.LFirst() != NULL)
	{
		Object * temp = list.LFirst();
		insert(new Object(*temp));

		while(NULL != (temp = list.LNext()))
			insert(new Object(*temp));
	}
}

// param data The data you want to save into the linked list.
// The function saves the data into at the end(tail) of the list.
void LinkedList::insert(Object * data)
{
	//Allocating space for the new Node.
	LNode * newNode = new LNode;
	newNode->data = data;
	newNode->next = NULL;

	if (head == NULL)	//Inseting first node.
	{
		head = newNode;
		tail = newNode;
		tail->next = NULL;
	}
	else  //Inserting second or after.
	{
		tail->next = newNode;
		tail = newNode;
		tail->next = NULL;
	}

	numOfData++;
}

// return ture it is add successfully, false, if it fails to add.
// param index The specific location that you want to add data.
// param data Data you want to append.
// Append data into the index location.
bool LinkedList::append(const int index, Object * data)
{
	if (index > numOfData)
		return false;

	LNode * newNode = new LNode;
	newNode->data = data;

	if (index == 0)
	{
		newNode->next = head;
		head = newNode;
	}
	else
	{
		//Resent the current location.
		cur = head;
		before = NULL;

		//Seeking place to add.
		for (int i = 0; i < index; i++)
		{
			before = cur;
			cur = cur->next;
		}

		//Add to the seeked location
		newNode->next = cur;
		before->next = newNode;
	}
	
	numOfData++;
	return true;
}

// Return index i th object.
// param i the index of the element.
// Get ith element from the list.
Object * LinkedList::get(int i)
{
	Object * temp = NULL;	//Temporary object container.

	if (numOfData == 0 || numOfData < i)		//When there is no data found, or index exceeds.
		return NULL;
	else if (i == 0)
		temp = LFirst();
	else
	{
		temp = LFirst();
		for(int k=0; k<i; k++)
		{
			temp = LNext();
		}
	}

	return temp;
}

Object * LinkedList::remove(int i)
{
	Object * temp = get(i);
	LRemove();
	return temp;
}


/**
 * \Iterate solution of reversing the list.
 */
void LinkedList::reverseIterate()
{
	tail = head;
	before = tail;

	while (tail->next != NULL)
	{
		head = tail->next;
		cur = head->next;
		head->next = before;
		before = head;
		tail->next = cur;
	}
}

//brief Recursively reverse the list.
void LinkedList::reverseRecursive()
{
	if(tail != NULL)		//I use the tail as first loop or not.
	{						//first loop, initialize.
		cur = NULL;
		before = NULL;
		tail = NULL;
	}

	//break statement.
	if(head->next == NULL)
	{
		head->next = cur;
		return;
	}

	//Change the direction of each node.
	before = cur;
	cur = head;
	head = head->next;
	cur->next = before;

	//Recursive call.
	reverseRecursive();

	//Setting the tail position recursively.
	tail = cur;
	cur = cur->next;
}

// return return NULL if there is no data
// return Object address if there is data
// The first data from the list. (The first)
Object * LinkedList::LFirst()
{
	if (head == NULL)
		return NULL;

	cur = head;
	before = NULL;
	Object * temp = cur->data;

	return temp;
}

// return return true if there is next data,
// return false is there is no data.
// param data The data you want to get form the list.
Object * LinkedList::LNext()
{
	if (cur == NULL)				//When LRemove is invoked at header.
		return LFirst();
	else if (cur->next == NULL)		//No more data
		return NULL;

	Object * temp = cur->next->data;

	before = cur;
	cur = cur->next;

	return temp;
}

// return Deleted object. (Delete is required)
// Remove the object currently indicating.
Object * LinkedList::LRemove()
{
	//Back up the object.
	Object * backup = cur->data;

	//if the object is header
	if (cur == head)
	{
		head = head->next;
		delete cur;
		cur = NULL;
	}
	else   //removing from the second node
	{
		//Removing the node.
		before->next = cur->next;
		delete cur;
		cur = before;
	}

	numOfData--;

	//Return the backup object.
	return backup;
}

// return number of the node in the list.
// brief Return the number of the data.
int LinkedList::getNumberOfData() const
{
	return numOfData;
}

