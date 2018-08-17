#ifndef __COMEDY_H_
#define __COMEDY_H_

#include "Movie.h"

/**
 * The Comedy class.
 */
class Comedy :
    public Movie
{
public:
    static const std::string Genre;
    static const std::string MovieType;

public:
    Comedy();
    Comedy(const std::string& title, const std::string& director, int stock,
        int year);
    Comedy(std::string& infoString);
    virtual ~Comedy();

    // Inherited via Movie
    virtual std::string getGenre() const override;

    // TODO: Implement them.
    virtual std::string toString() const override;
    virtual void displayMovieInfo() const override;

    ///**
    //* Arithematic operation based on
    //* Director(string), and title(string).
    //*/
    bool operator<(const Comedy & rhs) const;
    bool operator>(const Comedy & rhs) const;
    bool operator==(const Comedy & rhs) const;
    bool operator!=(const Comedy & rhs) const;
    bool operator<=(const Comedy & rhs) const;
    bool operator>=(const Comedy & rhs) const;

    // Input stream 
    friend std::istream& operator>>(std::istream& is, Comedy& obj);
};

#endif