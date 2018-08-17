#ifndef MOVIEHANDLER_H
#define MOVIEHANDLER_H

#include "Movie.h"
#include "Drama.h"
#include "Classic.h"
#include "Comedy.h"

#include "../HashTable/Table.h"

#include "../BSTree/Binarysearchtree.h"
#include <vector>

/**
 * The movie handler has all movie type
 * For the performance concern, they are saved in the tree.
 */
class movieHandler {
private:
    BinarySearchTree<Drama> DramaTree;
    BinarySearchTree<Comedy> ComedyTree;
    BinarySearchTree<Classic> ClassicTree;

public:
    movieHandler();

    //
    bool readFile(std::string filename);
    void showInventory();

    std::string BorRMovie(std::string infoString, std::string actionType);



    Movie * findMovie(std::string infoString);

private:
    void readFileHelper(std::string stringInfo);
    void readFileHelpoer(std::vector<std::string> stringVector);
//    Movie * findMovie(std::string infoString);
};

#endif 
