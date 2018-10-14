#include "storeHandler.h"

#include <fstream>
#include <sstream>
#include <queue>

storeHandler::storeHandler() {
}

storeHandler::~storeHandler() {
}

/**
 * Read from the file, and print out the data
 * @param command command file.
 * @param movieFile movie file.
 * @param customerFile customer file.
 * @return
 */
bool storeHandler::readFile(std::string command,
                            std::string movieFile, std::string customerFile) {

    // Read from Movie
    std::cout << "** Read from Movie file: " << movieFile << " **" << std::endl;
    if (!m.readFile(movieFile))
        return false;
    std::cout << "*****************************" << std::endl << std::endl;

    // Read from Customer file
    std::cout << "** Read from Customer file: " << customerFile << " **" << std::endl;
    if (!c.readFile(customerFile))
        return false;
    std::cout << "*****************************" << std::endl << std::endl;

    // Now let's work on our history file.
    std::cout << "Following history instruction" << std::endl;

    // Read the instruction.
    std::ifstream file(command);

    // When file was not found on the file.
    if (!file.is_open()) {
        std::cout << "file name: ";
        std::cout << command << " is invalid" << std::endl;
        return false;
    }

    // Save eachline to the line list.
    for (std::string line; !file.eof();) {
        std::getline(file, line);

        // Save each line to the string information.
        std::stringstream strInfo;
        strInfo << line;

        // Get the action type.
        std::string actionType;
        strInfo >> actionType;

        // For action type invectory.
        if (actionType == "I") {
            /**
             * The output of all the invectory in order of
             * Comedy movies, Drama, and classics.
             * According to the sorting order.
             */

            std::cout << "Action Type: \t" << actionType << std::endl;
            m.showInventory();

            //for action Type History.
        } else if (actionType == "H") {
            /**
             * List of all DVD transactions of each customer
             * in chronological order.
             */
            int customerID;
            strInfo >> customerID;
            c.printHistory(customerID);

            //For action type Borrow and Return.
        } else if (actionType == "B" || actionType == "R") {
            // Action for borrow and return.

            int customerID;
            std::string mediaType;
            std::string strCmd;

            strInfo >> customerID >> mediaType;

            // If the media type is correct
            if(mediaType == "D") {

                // Remove unnecessary informatoin.
                std::getline(strInfo, strCmd);
                strCmd.erase(0, 1);

                if (!(c.customerExists(customerID))) {
                    std::cout << "CustomerID: " << customerID;
                    std::cout << " does not exist. \n" << std::endl;
                } else {
                    std::string movieHistory = m.BorRMovie(strCmd, actionType);

                    if (movieHistory != "") {
                        c.addHistory(customerID, movieHistory, actionType);
                    }
                }
            } else {
                std::cout<<"media type: "<< mediaType << " is invalid"<<std::endl;
            }

        } else {
            // When the action is invalid.
            if (actionType != "") {
                std::cout << "Action type" << " ";
                std::cout << actionType << " is invalid action type" << std::endl;
            }
        }
    }

    return true;
}
