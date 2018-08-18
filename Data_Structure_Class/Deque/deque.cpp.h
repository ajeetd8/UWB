template <class Object>
Deque<Object>::Deque() {                          // the constructor
	front = back = NULL;
}

template <class Object>
Deque<Object>::Deque(const Deque &rhs) {         // the copy constructor
	front = back = NULL;
	*this = rhs;
}

template <class Object>
Deque<Object>::~Deque() {                         // the destructor
	clear();
}

template <class Object>
bool Deque<Object>::isEmpty() const {             // check if a deque is empty
	return front == NULL;
}

template <class Object>
int Deque<Object>::size() const {                 // retrieves # deque nodes
	int i = 0;
	for (DequeNode *ptr = front; ptr != NULL; ptr = ptr->next) // traverse que
		++i;

	return i;
}

template <class Object>
const Object &Deque<Object>::getFront() const {   // retrieve the front node
	if (isEmpty())
		throw "empty queue";
	return front->item;
}

template <class Object>
const Object &Deque<Object>::getBack() const {    // retrieve the tail node
	if (isEmpty())
		throw "empty queue";
	return back->item;
}

template <class Object>
void Deque<Object>::clear() {          // clean up all entries.
	while (!isEmpty())                 // dequeue till the queue gets empty.
		removeFront();
}

template <class Object>
void Deque<Object>::addFront(const Object &obj) {// add a new node to  front
	
	DequeNode * addNode = new DequeNode();

	//Node node pointers.
	addNode->item = obj;
	addNode->next = front;
	addNode->prev = NULL;
	
	if (front == NULL)		//If this node is the first node.
		front = back = addNode;
	else					//Adding second node.
	{
		front->prev = addNode;
		front = addNode;
	}
}

template <class Object>
void Deque<Object>::addBack(const Object &obj) { // add a new node to tail
	
	DequeNode * addNode = new DequeNode();
	
	//New node pointers.
	addNode->item = obj;
	addNode->next = NULL;
	addNode->prev = back;
	
	if (back == NULL)	//If this node is the first node.
		front = back = addNode;
	else				//Adding second node.
	{
		back->next = addNode;
		back = addNode;
	}
}

template <class Object>
Object Deque<Object>::removeFront() {  // remove the front node
	
	Object item = front->item;		//back up the object.
	DequeNode * next = front->next;	//back up the next node.

	//Delete the dynamically allocated memory.
	delete front;

	//When every data is reomoved, reset the front and back to NULL.
	if(next == NULL)
		front = back = NULL;
	else
		front = next;

	return item;
}

template <class Object>
Object Deque<Object>::removeBack() {   // remove the tail node

	Object item = back->item;		//back up the object.
	DequeNode * prev = back->prev;	//back up the previous node.

	//Delete the dynamically allocated memory.
	delete back;

	//When every data is reomoved, reset the front and back to NULL.
	if(prev == NULL)
		front = back = NULL;
	else
		back = prev;

	return item;

}

template <class Object>
const Deque<Object> &Deque<Object>::operator=(const Deque &rhs) { // assign
	if (this != &rhs) { // avoid self assignment
		clear();
		for (DequeNode *rptr = rhs.front; rptr != NULL; rptr = rptr->next)
			addBack(rptr->item);
	}
	return *this;
}
