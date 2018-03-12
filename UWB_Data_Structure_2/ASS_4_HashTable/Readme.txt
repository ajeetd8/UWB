To compile:
cmake CMakeLists.txt
make

To run: ./ass4
Will read data4movies.txt, data4customers.txt, data4commands.txt

Addtional information.
valgrind test:
    kharam@uw1-320-01:~/Assignment_4$ valgrind --leak-check=full ./ass4
    ==3161== Memcheck, a memory error detector
    ==3161== Copyright (C) 2002-2015, and GNU GPL'd, by Julian Seward et al.
    ==3161== Using Valgrind-3.11.0 and LibVEX; rerun with -h for copyright info
    ==3161== Command: ./ass4
    ==3161==
    ** Read from Movie file: data4movies.txt **
    Z is invalid Movie type
    Z is invalid Movie type
    *****************************

    ** Read from Customer file: data4customers.txt **
    *****************************

    Following history instruction
    Action Type:    I
    ********** Comedy Invectory **********
    10, Woody Allen, Annie Hall, 1977
    10, Joel Coen, Fargo, 1996
    10, John Landis, National Lampoon's Animal House, 1978
    10, Gore Verbinski, Pirates of the Caribbean, 2003
    10, Nora Ephron, Sleepless in Seattle, 1993
    10, Rob Reiner, When Harry Met Sally, 1989
    10, Nora Ephron, You've Got Mail, 1998

    ********** Drama Invectory **********
    10, Barry Levinson, Good Morning Vietnam, 1988
    10, Clint Eastwood, Unforgiven, 1992
    10, Gus Van Sant, Good Will Hunting, 2000
    10, Jonathan Demme, Silence of the Lambs, 1991
    10, Nancy Savoca, Dogfight, 1991
    10, Phillippe De Broca, King of Hearts, 1967
    10, Steven Spielberg, Schindler's List, 1993

    ********** Classic Invectory **********
    20, George Cukor, Holiday, (Katherine Hepburn | Cary Grant) 9 1938
    10, Victor Fleming, The Wizard of Oz, (Judy Garland) 7 1939
    20, Victor Fleming, Gone With the Wind, (Vivien Leigh | Clark Gable) 2 1939
    20, George Cukor, The Philadelphia Story, (Katherine Hepburn | Cary Grant) 5 1940
    10, John Huston, The Maltese Falcon, (Humphrey Bogart) 10 1941
    20, Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    20, Frank Capra, It's a Wonderful Life, (James Steward | Donna Reed) 11 1946
    10, Hal Ashby, Harold and Maude, (Ruth Gordon) 3 1971
    10, Stanley Kubrick, A Clockwork Orange, (Malcolm McDowell) 2 1971

    **** History of Mouse Minnie: 1000****
    **** End of History ****

    **** History of Frog Freddie: 5000****
    **** End of History ****

    **** History of Wacky Wally: 8000****
    **** End of History ****

    Movie Type: Z is invalid Movie type
    Action type X is invalid action type
    Action type Z is invalid action type
    CustomerID: 1234 does not exist.

    media type: Z is invalid
    Action Type:    I
    ********** Comedy Invectory **********
    10, Woody Allen, Annie Hall, 1977
    10, Joel Coen, Fargo, 1996
    10, John Landis, National Lampoon's Animal House, 1978
    10, Gore Verbinski, Pirates of the Caribbean, 2003
    4, Nora Ephron, Sleepless in Seattle, 1993
    10, Rob Reiner, When Harry Met Sally, 1989
    10, Nora Ephron, You've Got Mail, 1998

    ********** Drama Invectory **********
    2, Barry Levinson, Good Morning Vietnam, 1988
    10, Clint Eastwood, Unforgiven, 1992
    10, Gus Van Sant, Good Will Hunting, 2000
    10, Jonathan Demme, Silence of the Lambs, 1991
    10, Nancy Savoca, Dogfight, 1991
    10, Phillippe De Broca, King of Hearts, 1967
    10, Steven Spielberg, Schindler's List, 1993

    ********** Classic Invectory **********
    20, George Cukor, Holiday, (Katherine Hepburn | Cary Grant) 9 1938
    10, Victor Fleming, The Wizard of Oz, (Judy Garland) 7 1939
    20, Victor Fleming, Gone With the Wind, (Vivien Leigh | Clark Gable) 2 1939
    20, George Cukor, The Philadelphia Story, (Katherine Hepburn | Cary Grant) 5 1940
    10, John Huston, The Maltese Falcon, (Humphrey Bogart) 10 1941
    2, Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    20, Frank Capra, It's a Wonderful Life, (James Steward | Donna Reed) 11 1946
    10, Hal Ashby, Harold and Maude, (Ruth Gordon) 3 1971
    10, Stanley Kubrick, A Clockwork Orange, (Malcolm McDowell) 2 1971

    **** History of Mouse Minnie: 1000****
    Borrow: Barry Levinson, Good Morning Vietnam, 1988
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Borrow: Barry Levinson, Good Morning Vietnam, 1988
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    **** End of History ****

    **** History of Mouse Mickey: 1111****
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    **** End of History ****

    **** History of Frog Freddie: 5000****
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Return: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Return: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Return: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    **** End of History ****

    **** History of Wacky Wally: 8000****
    Borrow: Nora Ephron, Sleepless in Seattle, 1993
    Return: Nora Ephron, Sleepless in Seattle, 1993
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    Borrow: Nora Ephron, Sleepless in Seattle, 1993
    **** End of History ****

    **** History of Pig Porky: 8888****
    Borrow: Nora Ephron, Sleepless in Seattle, 1993
    Borrow: Nora Ephron, Sleepless in Seattle, 1993
    Borrow: Barry Levinson, Good Morning Vietnam, 1988
    Borrow: Barry Levinson, Good Morning Vietnam, 1988
    Borrow: Michael Curtiz, Casablanca, (Ingrid Bergman | Humphrey Bogart) 8 1942
    **** End of History ****

    ==3161==
    ==3161== HEAP SUMMARY:
    ==3161==     in use at exit: 72,704 bytes in 1 blocks
    ==3161==   total heap usage: 1,931 allocs, 1,930 frees, 287,509 bytes allocated
    ==3161==
    ==3161== LEAK SUMMARY:
    ==3161==    definitely lost: 0 bytes in 0 blocks
    ==3161==    indirectly lost: 0 bytes in 0 blocks
    ==3161==      possibly lost: 0 bytes in 0 blocks
    ==3161==    still reachable: 72,704 bytes in 1 blocks
    ==3161==         suppressed: 0 bytes in 0 blocks
    ==3161== Reachable blocks (those to which a pointer was found) are not shown.
    ==3161== To see them, rerun with: --leak-check=full --show-leak-kinds=all
    ==3161==
    ==3161== For counts of detected and suppressed errors, rerun with: -v
    ==3161== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
