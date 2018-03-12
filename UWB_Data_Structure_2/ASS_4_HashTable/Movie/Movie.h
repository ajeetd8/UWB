#ifndef __MOVIE_h_
#define __MOVIE_h_

#include "../Date/Date.h"
#include <string>
#include <iostream>

/**
 * A virtual Movie class, which will define the property of movie, and
 * the information that each class should have.
 */
class Movie {
private:
    // Common Movie properties.
    std::string title{""};
    std::string director{""};
    int stock{0};
    Date date{0, 0, 0};

public:
    // Default constructor.
    Movie() {}

    // Constructor with basic information + year.
    Movie(const std::string &title, const std::string &director, int stock,
          int year);

    // Constructor with basic information + year and month.
    Movie(const std::string &title, const std::string &director, int stock,
          int year, int month);

    // Constructor with basic information + year, month, and day.
    Movie(const std::string &title, const std::string &director, int stock,
          int year, int month, int day);

    // Accessor: get title.
    std::string getTitle() const;

    // Accessor: get director.
    std::string getDirector() const;

    // Accessor: get date in data format.
    Date getReleaseDate() const;

    // Accessor: get year.
    int getReleaseYear() const;

    // Accessor: get month.
    int getReleaseMonth() const;

    // Accessor: get day.
    int getReleaseDay() const;

    // Accessor: get stock.
    int getStock() const;


    // Virtual Accessor: get genre
    virtual std::string getGenre() const = 0;

    // Virtual Accessor: return string info.
    virtual std::string toString() const = 0;

    // Virtual Accessor: display movie info.
    virtual void displayMovieInfo() const = 0;

    // Modifier: set title.
    void setTitle(const std::string &title);

    // Modifier: set director.
    void setDirector(const std::string &director);

    // Modifier: set stock.
    void setStock(const int &stock);

    // Modifier: set year.
    void setYear(const int &year);

    // Modifier: set month.
    void setMonth(const int &month);

    // Modifier: set day.
    void setDay(const int &day);

    // Destructor.
    virtual ~Movie() {}
};

#endif