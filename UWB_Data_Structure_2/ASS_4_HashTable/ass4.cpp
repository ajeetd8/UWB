//Scott Allenspach
//Haram Kwon
//Assignment 4

/** Assumption:
 * - The format of the file is corrent although the context could be wrong.
 * -
 *
 * Criteria
 * - Discard the line where there is wrong context.
 */

#include <iostream>
#include "storeHandler.h"
#include "Movie/movieHandler.h"

using namespace std;

int main() {
    // Make store handler object, and load the file.
	storeHandler s;
    s.readFile("data4commands.txt", "data4movies.txt", "data4customers.txt");

    return 0;
}
