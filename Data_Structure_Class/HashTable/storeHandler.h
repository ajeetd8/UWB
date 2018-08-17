#ifndef __STOREHANDLER_H_
#define __STOREHANDLER_H_

#include <string>
#include "Customer/customerHandler.h"
#include "Movie/movieHandler.h"

class storeHandler {
public:

    // The default constructor.
    storeHandler();

    // Destructor.
    ~storeHandler();

    // Read from the file
    bool readFile(std::string command,
                  std::string movieFile, std::string customerFile);

private:
    movieHandler m;
    customerHandler c;
};

#endif 
