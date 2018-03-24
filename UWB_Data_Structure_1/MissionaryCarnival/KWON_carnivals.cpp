/** KWON_carnivals.cpp : This program is designed to solve Carnival
* and explorer problem.
*/

#include "Ground.h"
#include "ListBaseStack.h"
#include <iostream>

using namespace std;

//---------------------------------------------------------------------
/**
* This function get two two ground, and initial boat position, and
* stack. It will recursively solve the problem of the explorer and
* carnival problem.
* @param: A: Ground type. This is ground from.
* @param: B: Ground type. This is ground to.
* @param: boat: Boat type, and initially start with CLOSE.
* @param: stack: A initialized stack to store the data.
* @return: return ture if there is solution, and return false, if
*			there is no solution.
*/
bool CarnivalExplorerSolver(Ground A, Ground B, Boat boat, Stack *stack);

int main() {
    Stack stack;
    StackInit(&stack);

    //Starting set up for the explorer.
    Ground A(3, 3);
    Ground B(0, 0);
    Boat boat = CLOSE;


    if (CarnivalExplorerSolver(A, B, CLOSE, &stack)) {
        //Printout until the stack is empty.
        while (!SIsEmpty(&stack)) {
            //Saving current data into a temporary variable.
            Data as = SPop(&stack);
            int LExplor = (as->boat == CLOSE) ? as->B.explorer : as->A.explorer;
            int LCarnival = (as->boat == CLOSE) ? as->B.carnival : as->A.carnival;
            int RExplor = (as->boat == CLOSE) ? as->A.explorer : as->B.explorer;
            int RCarnival = (as->boat == CLOSE) ? as->A.carnival : as->B.carnival;
            Boat boat = as->boat;

            //Showing the visual result.
            for (int i = 0; i < LExplor; i++) {
                cout << 'E';
            }

            for (int i = 0; i < LCarnival; i++) {
                cout << 'C';
            }
            for (int i = 0; i < (6 - (LExplor + LCarnival)); i++)
                cout << '_';

            if (boat != CLOSE)
                cout << "\\__/        ";
            else
                cout << "        \\__/";
            for (int i = 0; i < RExplor; i++) {
                cout << 'E';
            }

            for (int i = 0; i < RCarnival; i++) {
                cout << 'C';
            }
            for (int i = 0; i < (6 - RExplor + RCarnival); i++)
                cout << '_';

            cout << endl;

            //Drawing the moving boat pciture.
            Data onBoat = SPeek(&stack);
            int onBoatE = onBoat->A.explorer - as->B.explorer;
            onBoatE = (onBoatE > 0) ? onBoatE : -onBoatE;

            int onBoatC = onBoat->A.carnival - as->B.carnival;
            onBoatC - (onBoatC > 0) ? onBoatC : -onBoatC;

            cout << "          \\";
            if (onBoatC == onBoatE)
                cout << "EC";
            else if (onBoatC == 1)
                cout << "C_";
            else if (onBoatC == 2)
                cout << "CC";
            else if (onBoatE == 1)
                cout << "E_";
            else
                cout << "EE";
            cout << '/' << endl << endl << endl;;
        }
    }
    return 0;
}

bool CarnivalExplorerSolver(Ground A, Ground B, Boat boat, Stack *stack) {
    //Snapshot of the current state of game.
    AllGround *temp = new AllGround(A, B, boat);

    //Handle when  carnival exceed the explorer
    if ((A.explorer != 0) && (A.carnival > A.explorer)) {
        SPush(stack, temp);
        return false;
    } else if ((B.explorer != 0) && (B.carnival > B.explorer)) {
        SPush(stack, temp);
        return false;
    }
        //Remove the repeting steps.
    else if (SSearch(stack, temp)) {
        SPush(stack, temp);
        return false;
    }

        //Mission clear statement
    else if (boat == CLOSE &&
             B.carnival == 3 && B.explorer == 3) {
        SPush(stack, temp);
        return true;
    } else if (boat == AWAY &&
               A.carnival == 3 && A.explorer == 3) {
        SPush(stack, temp);
        return true;
    }

    //Chaning boat position
    boat = (boat == CLOSE) ? AWAY : CLOSE;

    //local variable for the recursion
    int AExplorer, BExplorer;
    int ACarnival, BCarnival;

    //If the new object pass all the criteria, save it into stack.
    SPush(stack, temp);

    //Recursive Solution
    for (int i = 0; i <= 2 && i <= A.explorer; i++) {
        for (int j = 0; j <= 2 && j <= A.carnival; j++) {
            if ((i + j) <= 2 && ((i + j) > 0)) {
                //The next recursive solution values.
                AExplorer = (A.explorer - i);
                BExplorer = (B.explorer + i);
                ACarnival = (A.carnival - j);
                BCarnival = (B.carnival + j);

                //Goto next step recursively.
                if (CarnivalExplorerSolver(Ground(BExplorer, BCarnival),
                                           Ground(AExplorer, ACarnival), boat, stack)) {
                    return true;
                }
                    //In case no solutoin, remove the stack from the last.
                else {
                    //In case that the approach is wrong, remove from stack.
                    Data a = SPop(stack);
                }
            }
        }
    }
    return false;
}