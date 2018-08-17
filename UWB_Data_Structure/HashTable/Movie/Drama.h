#ifndef __DRAMA_H_
#define __DRAMA_H_

#include "Movie.h"

/**
 * The drama class inherit from Movie class.
 */
class Drama :
    public Movie
{
public:
    static const std::string Genre;
    static const std::string MovieType;

public:
    Drama();
    Drama(const std::string& title, const std::string& director, int stock,
        int year);
    Drama(std::string& infoString);
    virtual ~Drama();

    // Inherited via Movie
    virtual std::string getGenre() const override;
    virtual std::string toString() const override;
    virtual void displayMovieInfo() const override;

    ///**
    //* Arithematic operation based on
    //* Director(string), and title(string).
    //*/
    bool operator<(const Drama &) const;
    bool operator>(const Drama &) const;
    bool operator==(const Drama &) const;
    bool operator!=(const Drama &) const;
    bool operator<=(const Drama &) const;
    bool operator>=(const Drama &) const;

    // Input stream 
    friend std::istream& operator>>(std::istream& is, Drama& obj);
};

#endif