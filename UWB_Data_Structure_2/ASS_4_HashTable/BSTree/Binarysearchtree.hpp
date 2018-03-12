#include "Binarysearchtree.h"

// stub file
// provided so that the BinarySearchTree can be compiled
// none of the functions are implemented

template<class ItemType>
BinarySearchTree<ItemType>::BinarySearchTree() {
    //Set root ptr to null.
    rootPtr = nullptr;
}

template<class ItemType>
BinarySearchTree<ItemType>::~BinarySearchTree() {
    clear();        // Invoke the clear function delete the mememory.
}

template<class ItemType>
BinarySearchTree<ItemType>::BinarySearchTree(const ItemType &rootItem) {
    // Initialize the root tree with new rootItem.
    rootPtr = new BinaryNode<ItemType>(rootItem);
}

template<class ItemType>
BinarySearchTree<ItemType>::BinarySearchTree(const BinarySearchTree<ItemType> &bst) {
    // Copy every tree memeber from LHS to RHS.
    BinarySearchTree<ItemType>::copy(this->rootPtr, bst.rootPtr);
}

template<class ItemType>
bool BinarySearchTree<ItemType>::isEmpty() const {
    return rootPtr == nullptr;
}

template<class ItemType>
int BinarySearchTree<ItemType>::getHeight() const {
    // Invoke the getHeight function to calculate height recursively.
    return BinarySearchTree<ItemType>::getHeight(rootPtr);
}

template<class ItemType>
int BinarySearchTree<ItemType>::getNumberOfNodes() const {
    // Recursive solution to get the height.
    return getNumberOfNodes(rootPtr);
}

template<class ItemType>
bool BinarySearchTree<ItemType>::add(const ItemType &item) {
    BinaryNode<ItemType> *pNode = nullptr;        // Parents Node.
    BinaryNode<ItemType> *cNode = rootPtr;        // Current Node.
    BinaryNode<ItemType> *nNode = nullptr;        // New node

    // Finding place to add new node.
    while (cNode != nullptr) {
        if (item == cNode->getItem())
            return false;  // We don't allow key overlapping.

        pNode = cNode;

        if (item < cNode->getItem())
            cNode = cNode->getLeftChildPtr();
        else
            cNode = cNode->getRightChildPtr();
    }

    // Allocate memory to add data.
    nNode = new BinaryNode<ItemType>(item);

    // Adding newNode(nNode) to subtree
    if (pNode != nullptr)  // If new Node is not a root Node
    {
        if (item < pNode->getItem())
            pNode->setLeftChildPtr(nNode);
        else
            pNode->setRightChildPtr(nNode);
    } else   // if pNode is rootNode
    {
        rootPtr = nNode;
    }

    return true;
}

template<class ItemType>
void BinarySearchTree<ItemType>::clear() {
    // Invoke the clear function to clear.
    BinarySearchTree<ItemType>::clear(rootPtr);
    rootPtr = nullptr;
}

template<class ItemType>
bool BinarySearchTree<ItemType>::contains(const ItemType &item) const {
    // Recursively find the item.
    return nullptr != BinarySearchTree<ItemType>::findNode(rootPtr, item);
}

template<class ItemType>
BinaryNode<ItemType> *BinarySearchTree<ItemType>::
findNode(BinaryNode<ItemType> *subTreePtr, const ItemType &target) const {
    BinaryNode<ItemType> *cNode = subTreePtr;    // current node.
    ItemType cd;                                // current data.

    //Iteration solutoin to find node (preorder)
    while (cNode != nullptr) {
        cd = cNode->getItem();

        if (target == cd)
            return subTreePtr;
        else if (target < cd)
            cNode = cNode->getLeftChildPtr();
        else
            cNode = cNode->getRightChildPtr();
    }

    //If we don't find the node that we need
    return nullptr;
}

template<class ItemType>
void BinarySearchTree<ItemType>::inorderTraverse(void visit(ItemType &)) const {
    // Resursive solutoin to find inorder Traverse.
    BinarySearchTree<ItemType>::inorderTraverseHelper(rootPtr, visit);
}

template<class ItemType>
void BinarySearchTree<ItemType>::preorderTraverse(void visit(ItemType &)) const {
    // Resursive solutoin to find preorder Traverse.
    BinarySearchTree<ItemType>::preorderTraverseHelper(rootPtr, visit);
}

template<class ItemType>
void BinarySearchTree<ItemType>::postorderTraverse(void visit(ItemType &)) const {
    // Resursive solutoin to find postorder Traverse.
    BinarySearchTree<ItemType>::postorderTraverseHelper(rootPtr, visit);
}

template<class ItemType>
void BinarySearchTree<ItemType>::
inorderTraverseHelper(BinaryNode<ItemType> *bt, void visit(ItemType &)) const {
    if (bt == nullptr)
        return;

    ItemType temp = bt->getItem();

    BinarySearchTree<ItemType>::inorderTraverseHelper(bt->getLeftChildPtr(), visit);
    visit(temp);
    BinarySearchTree<ItemType>::inorderTraverseHelper(bt->getRightChildPtr(), visit);
}

template<class ItemType>
void BinarySearchTree<ItemType>::preorderTraverseHelper(BinaryNode<ItemType> *bt,
                                                        void visit(ItemType &)) const {
    if (bt == nullptr)
        return;

    ItemType temp = bt->getItem();

    visit(temp);
    BinarySearchTree<ItemType>::preorderTraverseHelper(bt->getLeftChildPtr(), visit);
    BinarySearchTree<ItemType>::preorderTraverseHelper(bt->getRightChildPtr(), visit);
}

template<class ItemType>
void BinarySearchTree<ItemType>::rebalance() {
    ItemType *arr = new ItemType[getNumberOfNodes()];

    int index = 0;                            // Temporary index value.
    thisBSTToArray(rootPtr, arr, index);    // Binary search tree to ordered array.
    readTree(arr, getNumberOfNodes());        // sorted array to balanced tree.

    delete[] arr;
}

template<class ItemType>
bool BinarySearchTree<ItemType>::readTree(ItemType arr[], int n) {
    //Array check
    if (isSortedArray(arr, n)) {
        //Clear BinaryNode.
        clear();

        // Modify this
        rootPtr = sortedArrayToBBST(arr, 0, n - 1);

        return true;
    }

    return false;;
}

template<class ItemType>
void BinarySearchTree<ItemType>::sideways(BinaryNode<ItemType> *current, int level) const {
    if (current != NULL) {
        level++;
        sideways(current->getRightChildPtr(), level);

        // indent for readability, 4 spaces per depth level
        for (int i = level; i >= 0; i--) {
            cout << "    ";
        }

        cout << current->getItem() << endl;     // display information of object
        sideways(current->getLeftChildPtr(), level);
    }
}

template<class ItemType>
bool BinarySearchTree<ItemType>::operator==(const BinarySearchTree<ItemType> &other) const {
    return compare(this->rootPtr, other.rootPtr);
}

template<class ItemType>
bool BinarySearchTree<ItemType>::operator!=(const BinarySearchTree<ItemType> &other) const {
    return !(*this == other);
}

template<class ItemType>
void BinarySearchTree<ItemType>::postorderTraverseHelper(BinaryNode<ItemType> *bt,
                                                         void visit(ItemType &)) const {
    if (bt == nullptr)
        return;

    ItemType temp = bt->getItem();

    BinarySearchTree<ItemType>::postorderTraverseHelper(bt->getLeftChildPtr(), visit);
    BinarySearchTree<ItemType>::postorderTraverseHelper(bt->getRightChildPtr(), visit);
    visit(temp);
}

template<class ItemType>
int BinarySearchTree<ItemType>::getNumberOfNodes(BinaryNode<ItemType> *bt) const {
    if (bt == nullptr)
        return 0;

    return 1 + getNumberOfNodes(bt->getLeftChildPtr()) +
           getNumberOfNodes(bt->getRightChildPtr());
}

template<class ItemType>
void BinarySearchTree<ItemType>::clear(BinaryNode<ItemType> *bt) {
    //if the tree is already empty.
    if (bt == nullptr)
        return;

    //Postorder traverse to delete everything.
    BinarySearchTree<ItemType>::clear(bt->getLeftChildPtr());
    BinarySearchTree<ItemType>::clear(bt->getRightChildPtr());
    delete bt;
}

template<class ItemType>
void BinarySearchTree<ItemType>::copy(BinaryNode<ItemType> *lhs, BinaryNode<ItemType> *rhs) {

    // If both node is null.
    if (lhs == nullptr && rhs == nullptr)
        return;

    // If it is root node. Make a root node.
    if (rootPtr == nullptr && rhs != nullptr) {
        rootPtr = new BinaryNode<ItemType>(*rhs);
        lhs = rootPtr;
    }


    if (nullptr != rhs->getLeftChildPtr()) {
        lhs->setLeftChildPtr(new BinaryNode<ItemType>(*rhs->getLeftChildPtr()));
        copy(lhs->getLeftChildPtr(), rhs->getLeftChildPtr());
    }
    if (nullptr != rhs->getRightChildPtr()) {
        lhs->setRightChildPtr(new BinaryNode<ItemType>
                                      (*rhs->getRightChildPtr()));
        copy(lhs->getRightChildPtr(), rhs->getRightChildPtr());
    }
}

template<class ItemType>
int BinarySearchTree<ItemType>::getHeight(BinaryNode<ItemType> *subTreePtr) const {
    if (rootPtr == nullptr || subTreePtr == nullptr)
        return 0;

    int lhs = getHeight(subTreePtr->getLeftChildPtr());
    int rhs = getHeight(subTreePtr->getRightChildPtr());

    return 1 + ((lhs < rhs) ? rhs : lhs);
}

template<class ItemType>
BinaryNode<ItemType> *BinarySearchTree<ItemType>::
sortedArrayToBBST(ItemType arr[], int first, int last) const {
    if (first > last)
        return nullptr;

    int mid = (first + last) / 2;
    BinaryNode<ItemType> *node = new BinaryNode<ItemType>(arr[mid]);

    node->setLeftChildPtr(sortedArrayToBBST(arr, first, mid - 1));
    node->setRightChildPtr(sortedArrayToBBST(arr, mid + 1, last));

    return node;
}

template<class ItemType>
void BinarySearchTree<ItemType>::
thisBSTToArray(BinaryNode<ItemType> *subTree, ItemType arr[], int &index) const {
    if (subTree == nullptr)
        return;

    //Inorder traverse to get sored array.
    thisBSTToArray(subTree->getLeftChildPtr(), arr, index);
    arr[index++] = subTree->getItem();
    thisBSTToArray(subTree->getRightChildPtr(), arr, index);
}

template<class ItemType>
bool BinarySearchTree<ItemType>::
compare(const BinaryNode<ItemType> *lhsTree, const BinaryNode<ItemType> *rhsTree) const {
    //Escape condition.
    if (lhsTree == nullptr && rhsTree == nullptr)         // If both currently indicating nullptr.
        return true;
    else if (lhsTree == nullptr || rhsTree == nullptr)    // If only one of them indicating nullptr.
        return false;

    if (lhsTree->getItem() == rhsTree->getItem())         // We are comparing the item currently indicating.
    {
        if (!compare(lhsTree->getLeftChildPtr(),
                     rhsTree->getLeftChildPtr()))   // Compare the left child.
            return false;
        if (!compare(lhsTree->getRightChildPtr(),
                     rhsTree->getRightChildPtr()))  // Compare the right child.
            return false;
    } else
        return false;

    return true;
}

template<class ItemType>
bool BinarySearchTree<ItemType>::isSortedArray(ItemType arr[], int length) {
    // Check whehter the array is sorted or not.
    for (int i = 1; i < length; i++) {
        if (arr[i - 1] >= arr[i]) {
            return false;
        }
    }

    return true;
}

template<class ItemType>
ItemType *BinarySearchTree<ItemType>::itemSearch(const ItemType &item) {

    BinaryNode<ItemType> *node = findNode(rootPtr, item);

    // If the time does not exist, return nullptr.
    if (node == nullptr)
        return nullptr;

    return node->getItemPtr();
}