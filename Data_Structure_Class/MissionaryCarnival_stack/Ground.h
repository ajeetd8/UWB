#ifndef __GROUND_H
#define __GROUND_H

//Enum type for the boat position.
enum Boat { CLOSE, AWAY };

//Class for saving only one side of the ground
class Ground
{
public:
	int explorer;
	int carnival;

	Ground(int explorer, int carnival)
		:explorer(explorer), carnival(carnival) {}
	Ground(const Ground& ground)
		:explorer(ground.explorer), carnival(ground.carnival) {}

	bool operator==(const Ground& gr)
	{
		if (this->explorer == gr.explorer &&
			this->carnival == gr.carnival)
			return true;
		else
			return false;
	}
};

//class to save the two ground and boat
class AllGround
{
public:
	Ground A, B;
	Boat boat;

	AllGround(Ground A, Ground B, Boat boat)
		:A(A), B(B), boat(boat) {}

	bool operator==(const AllGround& AGR)
	{
		if (this->boat == AGR.boat)
		{
			return (this->A == AGR.A) ? true : false;
		}
		else
			return false;
	}
};

#endif
