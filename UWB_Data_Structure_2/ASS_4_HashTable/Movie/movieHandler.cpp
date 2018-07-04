#include "movieHandler.h"

#include <fstream>
#include <sstream>
#include <queue>

movieHandler::movieHandler() {
}

bool movieHandler::readFile(std::string filename) {
    std::ifstream file(filename);

    // When file was not found on the file.
    if (!file.is_open()) {
        std::cout << "file name: ";
        std::cout << filename << " is invalid" << std::endl;
        return false;
    }

    std::vector<std::string> lines;
    std::vector<std::string> classics;

    // Save each line to the string
    for (std::string line; !file.eof();) {
        std::getline(file, line);
        lines.push_back(line);
    }

    for (auto ite = lines.begin(); ite != lines.end(); ite++) {
        if (ite->c_str()[0] == 'C') {
            classics.push_back(*ite);
        }
        else {
            readFileHelper(*ite);
        }
    }

    std::string classic = "";
    // Handling classic movie
    for(auto ite = classics.begin(); ite != classics.end(); ite++)
    {
        classic += *ite + "\n";
    }

    readFileHelper(classic);
    return true;
}

Movie *movieHandler::findMovie(std::string infoString) {
    std::stringstream strInfo;

    strInfo << infoString;
    std::string movieType;
    strInfo >> movieType;

    Movie *pMovie = nullptr;

    // put the file into the Tree.
    // Assuming that the file format is correct.
    if (movieType == Drama::MovieType) {
        Drama drama(infoString);
        pMovie = DramaTree.itemSearch(drama);
    } else if (movieType == Comedy::MovieType) {
        Comedy comedy(infoString);
        pMovie = ComedyTree.itemSearch(comedy);
    } else if (movieType == Classic::MovieType) {
        Classic classic(infoString);
        pMovie = ClassicTree.itemSearch(classic);
    } else  //Where we manage the error
    {
        std::cout << "Movie Type: ";
        std::cout << movieType << " is invalid Movie type" << std::endl;
    }

    // Where if failed to search the movie.
    if (pMovie == nullptr && movieType == "")
        std::cout << infoString << " Not valid command" << std::endl;

    // return found movie or nullptr.
    return pMovie;
}

/**
 * Helper function for read file. Get's the string info.
 * @param stringInfo
 */
void movieHandler::readFileHelper(std::string stringInfo) {
    std::stringstream strInfo;

    strInfo << stringInfo;
    std::string movieType;
    std::getline(strInfo, movieType, ',');

    // put the file into the Tree.
    // Assuming that the file format is correct.
    if (movieType == Drama::MovieType) {
        Drama drama;
        strInfo >> drama;
        DramaTree.add(drama);
    } else if (movieType == Comedy::MovieType) {
        Comedy comedy;
        strInfo >> comedy;
        ComedyTree.add(comedy);
    } else if (movieType == Classic::MovieType) {

        std::stringstream strStream;
        strStream << stringInfo;

        for(std::queue<Classic> classics;!strStream.eof();)
        {
            Classic classic;
            std::getline(strStream, movieType, ',');
            strStream >> classic;

            if(!classics.empty())
            {
                if(classics.front().getTitle() == classic.getTitle())
                {
                    classics.push(classic);
                }
                else
                {
                    Classic tempClassic = classics.front();
                    classics.pop();

                    while(!classics.empty())
                    {
                        tempClassic.setStock(tempClassic.getStock() + classics.front().getStock());
                        tempClassic.addMajorActors(classics.front().getMajorActors());
                        classics.pop();
                    }

                    classics.push(classic);
                    ClassicTree.add(tempClassic);
                }
            } else {
                classics.push(classic);
            }
        }
    } else  //Where we manage the error
    {
        // show reading file is wrong.
        if(movieType != "")
            std::cout << movieType << " is invalid Movie type" << std::endl;
    }
}

void movieHandler::readFileHelpoer(std::vector<std::string> stringVector) {

}

// Local function to show Drama data.
void ShowAllDramaData(Drama &drama) {
    std::cout << drama.toString() << std::endl;
}

// Local function to show Classic data
void ShowAllClassicData(Classic &classic) {
    std::cout << classic.toString() << std::endl;
}

// Local function to show Comedy data
void ShowAllComedyData(Comedy &drama) {
    std::cout << drama.toString() << std::endl;
}

void movieHandler::showInventory() {

    std::cout << "********** Comedy Invectory **********" << std::endl;
    ComedyTree.inorderTraverse(ShowAllComedyData);
    std::cout << endl;

    std::cout << "********** Drama Invectory **********" << std::endl;
    DramaTree.inorderTraverse(ShowAllDramaData);
    std::cout << endl;

    std::cout << "********** Classic Invectory **********" << std::endl;
    ClassicTree.inorderTraverse(ShowAllClassicData);
    std::cout << endl;

}

std::string movieHandler::BorRMovie(std::string infoString, std::string actionType) {

    Movie *pMovie = findMovie(infoString);

    // Handling the error case
    if (pMovie == nullptr) {
        // When the movie was not found.
        return "";
    }

    // If the Action type is borrow ('B')
    if (actionType == "B") {
        if (pMovie->getStock() < 1) {
            // When there is no stock.
            std::cout << pMovie->getTitle() << " has no stock" << std::endl;
            return "";
        }

        // Time to decrease the number of the movie;
        pMovie->setStock(pMovie->getStock() - 1);

        return pMovie->toString();
    } else {
        pMovie->setStock(pMovie->getStock() + 1);
        return pMovie->toString();
    }
}
