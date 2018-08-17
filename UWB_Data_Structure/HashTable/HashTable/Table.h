#ifndef __TABLE_H__
#define __TABLE_H__

#include <list>
#include <vector>
#include <map>

/**
 * Closed hash table.
 * @tparam Key Key for hash table, usually int.
 * @tparam Value value for hash table.
 */
template<class Key, class Value>
class Table
{
private:
    // Hash function definition.
    typedef Key HashFunc(Key k); 

    const int MAX_SIZE; // Max size for closed hash.
    HashFunc * hf;      // Hash function.

    // Table definition.
    std::vector<std::list<std::pair<Key, Value*>>> tbl;

public:
    // Only constructor to initialize
    Table(int size, HashFunc* hf);

    // Insert the key and valu.e
    bool insert(Key k, Value v);

    // Remote by key.
    Value remove(Key k);

    // Search function for hash.
    Value * search(Key k);

    // Destructor.
    ~Table();
};

#include "Table.hpp"

#endif
