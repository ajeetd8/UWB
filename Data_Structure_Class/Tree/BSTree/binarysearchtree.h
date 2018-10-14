// Yusuf Pisan pisan@uw.edu
// 15 Jan 2018

// BinarySearchTree class
// Creates a BST to store values
// Uses BinaryNode which holds the data
// Uses templates to store any type of data
// binarysearchtreee.cpp file is included at the bottom of the .h file
// binarysearchtreee.cpp is part of the template, cannot be compiled separately

#ifndef BINARYSEARCHTREE_H
#define BINARYSEARCHTREE_H

#include "binarynode.h"

using namespace std;

template<class ItemType>
class BinarySearchTree {
public:
	// constructor, empty tree
	BinarySearchTree();
	// constructor, tree with root
	explicit BinarySearchTree(const ItemType& rootItem);
	// copy constructor
	BinarySearchTree(const BinarySearchTree<ItemType>& bst);
	// destructor
	virtual ~BinarySearchTree();
	// true if no nodes
	bool isEmpty() const;
	// 0 if empty, 1 if only root, otherwise
	// max height of subtrees + 1
	int getHeight() const;
	// number of nodes and data in tree
	int getNumberOfNodes() const;
	// add a new item
	// return true if succesasfull
	// false if item already in tree or some other reason to fail
	bool add(const ItemType& item);
	// true if item is in tree
	bool contains(const ItemType& item) const;
	// dispaly a sideways ascii representation of tree
	void displaySideways() const;
	// inorder traversal: left-root-right
	// takes a function that takes a single parameter of ItemType
	// the function can modify the data in tree, but the
	// tree structure is not changed
	void inorderTraverse(void visit(ItemType&)) const;
	// create dynamic array, copy all the items to the array
	// and then read the array to re-create this tree
	void rebalance();
	// delete all nodes in tree and set root to nullptr
	void clear();
	// given an array of length n
	// create this tree to have all items in that array
	// with the minimum height
	bool readTree(ItemType arr[], int n);
	// trees are equal if they have the same structure
	// AND the same item values at all the nodes
	bool operator==(const BinarySearchTree<ItemType> &) const;
	// not == to each other
	bool operator!=(const BinarySearchTree<ItemType> &) const;
private:
	// root of the tree
	BinaryNode<ItemType>* rootPtr{ nullptr };
	// add a new node, helper function for add
	//BinaryNode<ItemType>* placeNode(BinaryNode<ItemType>* subTreePtr, BinaryNode<ItemType>* newNodePtr);
	// find the node with given vale, helper function for contains
	BinaryNode<ItemType>* findNode(BinaryNode<ItemType>* subTreePtr, const ItemType& target) const;
	// helper function for displaySideways to work recursively
	void sideways(BinaryNode<ItemType>* current, int level) const;
	//helper function for inorderTraverse to work recursively.
	void inorderTraverse(BinaryNode<ItemType> * bt, void visit(ItemType&)) const;
	//Helper function for counting the node.
	int getNumberOfNodes(BinaryNode<ItemType> * bt) const;
	//Helper function for clear
	void clear(BinaryNode<ItemType> * bt);
	//Copy each node pre-order traverse, helper function for copy constructor.
	void copy(BinaryNode<ItemType> * lhs, BinaryNode<ItemType> * rhs);
	//Helper function for getHeight() function.
	int getHeight(BinaryNode<ItemType> * subTreePtr) const;
	//Helper function for sored array to Balanced binary search tree.
	BinaryNode<ItemType> * sortedArrayToBBST(ItemType arr[], int first, int last) const;
	//Helper function for binary search tree to arrray
	void thisBSTToArray(BinaryNode<ItemType> * subTree, ItemType arr[], int& index) const;
	//Helper function for comparing two Binary Search Tree
	bool compare(const BinaryNode<ItemType> * lhsTree, const BinaryNode<ItemType> * rhsTree) const;
	bool isSortedArray(ItemType arr[], int length);
};

#include "binarysearchtree.cpp"

#endif // BINARYSEARCHTREE_H