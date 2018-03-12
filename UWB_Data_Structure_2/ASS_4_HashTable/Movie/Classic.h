#ifndef __CLASSIC_H_
#define __CLASSIC_H_

#include "Movie.h"

#include <vector>

/**
 * The classic class.
 */
class Classic :
    public Movie
{
public:
    static const std::string Genre;
    static const std::string MovieType;
    std::vector<std::string> majorActors;

public:
    Classic();
    Classic(const std::string& title, const std::string& director,
        std::string majorActor, int stock, int year, int month);
    Classic(std::string& infoString);
    virtual ~Classic();

    // Inherited via Movie
    virtual std::string getGenre() const override;

    // Todo: Implement them.
    virtual std::string toString() const override;
    virtual void displayMovieInfo() const override;

    // Accessor
    std::vector<std::string> getMajorActors() const;

    // Modifier
    void addMajorActor(std::string majorActor);
    void addMajorActors(std::vector<std::string> majorActors);

    ///**
    //* Arithematic operation based on
    //* Director(string), and title(string).
    //*/
    bool operator<(const Classic & rhs) const;
    bool operator>(const Classic & rhs) const;
    bool operator==(const Classic & rhs) const;
    bool operator!=(const Classic & rhs) const;
    bool operator<=(const Classic & rhs) const;
    bool operator>=(const Classic & rhs) const;

    // Input stream 
    friend std::istream& operator>>(std::istream& is, Classic& obj);
};

#endif