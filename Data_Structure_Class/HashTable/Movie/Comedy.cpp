#include "Comedy.h"

#include <sstream>

// Setting the static  variable for genre.
const std::string Comedy::Genre = "Drama";
const std::string Comedy::MovieType = "F";

Comedy::Comedy()
        : Movie() {
}

Comedy::Comedy(const std::string &title, const std::string &director,
               int stock, int year)
        : Movie(title, director, stock, year) {
}

Comedy::Comedy(std::string &infoString) : Movie() {

    // Save the data info stringstream.
    std::stringstream strInfo;
    strInfo << infoString;

    // Throughout the movie type letter.
    std::string movieType;
    strInfo >> movieType;

    //Gettting the Director, and title
    std::string title, year_str;

    // Get the movie information from the string.
    std::getline(strInfo, title, ',');
    std::getline(strInfo, year_str, ',');

    // Remove the white space from the first line.
    title.erase(0, 1);
    year_str.erase(0, 1);

    // Setting the title and director of the movie
    setTitle(title);
    setYear(std::atoi(year_str.c_str()));
}

Comedy::~Comedy() {
}

std::string Comedy::getGenre() const {
    return Comedy::Genre;
}

// Todo: need definition here.
std::string Comedy::toString() const {
    std::string infoString = std::to_string(getStock()) + ", " +getDirector() +
            ", " +getTitle() + ", "+std::to_string(getReleaseYear());

    return infoString;
}

void Comedy::displayMovieInfo() const {
    std::cout << toString() << std::endl;
}

bool Comedy::operator<(const Comedy &rhs) const {
    return (this->getTitle() == rhs.getTitle()) ?
           this->getReleaseDate() < rhs.getReleaseDate() :
           this->getTitle() < rhs.getTitle();
}

bool Comedy::operator>(const Comedy &rhs) const {
    return rhs < *this;
}

bool Comedy::operator==(const Comedy &rhs) const {
    return (this->getTitle() == rhs.getTitle() &&
            this->getReleaseYear() == rhs.getReleaseYear());
}

bool Comedy::operator!=(const Comedy &rhs) const {
    return !(*this == rhs);
}

bool Comedy::operator<=(const Comedy &rhs) const {
    return ((*this < rhs) || *this == rhs);
}

bool Comedy::operator>=(const Comedy &rhs) const {
    return (rhs <= *this);
}

std::istream &operator>>(std::istream &is, Comedy &obj) {
    // Local variable to handle the information.
    std::string stock_str;
    std::string director;
    std::string title;
    std::string year_str;

    // Get each line from the front
    std::getline(is, stock_str, ',');
    std::getline(is, director, ',');
    std::getline(is, title, ',');
    std::getline(is, year_str, ',');

    // Remove the white space front.
    stock_str.erase(0, 1);
    director.erase(0, 1);
    title.erase(0, 1);
    year_str.erase(0, 1);

    // Save the stock and year to int.
    int stock = std::atoi(stock_str.c_str());
    int year = std::atoi(year_str.c_str());

    // Change the value in the string.
    obj.setTitle(title);
    obj.setDirector(director);
    obj.setYear(year);
    obj.setStock(stock);

    return is;
}
