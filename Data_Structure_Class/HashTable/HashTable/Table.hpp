#include "Table.h"

#include <iostream>
#include <algorithm>
#include <list>

/**
 * constructor for hash
 * @param size max size for closed. larger number more performance.
 * @param hf Hash function definition.
 */
template<class Key, class Value>
Table<Key, Value>::Table(int size, HashFunc *hf)
        :tbl(size), MAX_SIZE(size), hf(hf) {}

/**
 * Insert the key and value to the table.
 * @param k Key to insert.
 * @param v Value to insert.
 * @return Successfully inserted or not.
 */
template<class Key, class Value>
bool Table<Key, Value>::insert(Key k, Value v) {
    // Get the hash value
    Key hv = this->hf(k);

    // If the key already exist.
    if (search(k) != nullptr) {
        std::cout << "Key overlapping" << std::endl;
        return false;
    }

    // If the new Key is unique. Save it.
    Value *value = new Value(v);
    tbl[hv].push_back(std::pair<Key, Value *>(k, value));

    return true;
}

/**
 * The from the table with key
 * @param k Key to remove
 * @return copy of the value removed.
 */
template<class Key, class Value>
Value Table<Key, Value>::remove(Key k) {
    Key hv = this->hf(k);

    Value *val = search(k);

    if (val != nullptr) {
        Value backUPVal = *val;
        delete val;
        tbl[hv].remove(std::pair<Key, Value *>(k, val));
        return backUPVal;
    }

    return nullptr;
}

/**
 * Find from the table by the key, return the pointer value.
 * @param k Key to search.
 * @return pointer of the found value.
 */
template<class Key, class Value>
Value *Table<Key, Value>::search(Key k) {
    // Get the hash value.
    Key hv = this->hf(k);

    for (typename std::list<std::pair<Key, Value *>>::iterator ite = tbl[hv].begin();
         ite != tbl[hv].end(); ite++) {
        if (ite->first == k)
            return ite->second;
    }

    return nullptr;
}

/**
 * Destructor to delete the dynamically allocated space.
 */
template<class Key, class Value>
Table<Key, Value>::~Table() {
    // Deleting every dynamically allocated memory
    for (typename std::vector<std::list<std::pair<Key, Value *>>>::iterator ite = tbl.begin();
         ite != tbl.end(); ite++) {
        for (typename std::list<std::pair<Key, Value *>>::iterator vIte = ite->begin();
             vIte != ite->end(); vIte++) {
            delete vIte->second;
        }
    }

}
