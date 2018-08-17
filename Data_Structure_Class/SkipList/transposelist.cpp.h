//-------------------------------------------------------------------------------
/**
 * The definition of find function of transpose.
 * It will find the object from the list, and move the object to one unit
 * closer to the header node.
 * Assumption: Other part of the code is perfect.
 * @return: transposed object index.
 */
template <class Object>
int TransposeList<Object>::find(const Object &obj)
{
	DListNode<Object> *found = DList<Object>::header->next;

	int i = 0;
	for (; found != NULL && found->item != obj; found = found->next, ++i)
		++DList<Object>::cost;

	if (found == NULL)
		return -1; // not found

	if (found == DList<Object>::header->next)
		return 0; // no need to swap

	// remove found from the current position
	DList<Object>::remove(obj);
	// insert found before previous
	DList<Object>::insert(obj, --i);

	//return the index of the transposed object.
	return --i;
}