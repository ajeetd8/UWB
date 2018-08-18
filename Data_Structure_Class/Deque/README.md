# Topic: Queues - Deque

## Purpose
To implement a Deque class that allows a data item to be enqueued-to and dequeued-from both the back and the end of the structure. 

## Deque
Deque is an abbreviation for a "double ended queue". It allows a new data item to be enqueued not only to the back but also to the front. Similarly, it allows both the front and the back item to be retrieved and dequeued. The following code shows a header file of this Deque class:

```
#ifndef DEQUE_H
#define DEQUE_H
#include <iostream>

using namespace std;

template <class Object>
class Deque {
 public:
  Deque( );                                   // the constructor
  Deque( const Deque &rhs );                  // the copy constructor
  ~Deque( );                                  // the destructor

  bool isEmpty( ) const;                      // checks if a deque is empty.
  int size( ) const;                          // retrieves # deque nodes
  const Object &getFront( ) const;            // retrieve the front node
  const Object &getBack( ) const;             // retrieve the tail node

  void clear( );                              // clean up all deque entries.
  void addFront( const Object &obj );         // add a new node to the front
  void addBack( const Object &obj );          // add a new node to the tail
  Object removeFront( );                      // remove the front node
  Object removeBack( );                       // remove the tail node

  const Deque &operator=( const Deque &rhs ); // assignment

 private:
  struct DequeNode {                          // a deque node
    Object item;
    DequeNode *next;
    DequeNode *prev;
  };
  DequeNode *front;
  DequeNode *back;
};

#include "deque.cpp.h"
#endif
```

The difference b/w Deque and a FIFO queue is that Deque has three additional methods:

1. getBack( ): retrieves the tail object.
2. removeBack( ): removes the tail object.
3. addFront( object ): enqueues a new object to the front.

All the other methods are functionally identical to those of the FIFO queues.

# Statement of Work

Implement [only] the following four methods:
```
template <class Object>void Deque<Object>::addFront( const Object &obj ) {// add a new node to front//implement the function body.}
template <class Object>void Deque<Object>::addBack( const Object &obj ) { // add a new node to tail
//implement the function body.}
template <class Object>Object Deque<Object>::removeFront( ) { // remove the front node
//implement the function body.}template <class Object>Object Deque<Object>::removeBack( ) { 

//implement the function body.
} 
```

File description: 
* deque.h: the header file
* deque_incomplete.cpp.h: the template implementation you have to edit
* driver.cpp: the main program to verify your modification
2. Rename deque_incomplete.cpp.h into deque.cpp.h and edit this file to complete the implementation.
3. Compile the code (remember you have to do this in one of the Linux lab machines). 
4. Run this driver program to verify your implementation. 

```
./a.out
deque1: 
9
8
7
6
5
0
1
2
3
4
deque2: 
10
4
3
2
1
0
5
6
7
8
9
```
