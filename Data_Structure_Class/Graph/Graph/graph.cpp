#include <queue>
#include <climits>
#include <iostream>
#include <fstream>
#include <map>
#include <stack>
#include <queue>
#include <vector>

#include "graph.h"

/**
 * A graph is made up of vertices and edges
 * A vertex can be connected to other vertices via weighted, directed edge
 */


 /** constructor, empty graph */
Graph::Graph() : numberOfVertices(0), numberOfEdges(0)
{ }

/** destructor, delete all vertices and edges
	only vertices stored in map
	no pointers to edges created by graph */
Graph::~Graph()
{
	// Free the dynamically allocated memory (free heap)
	for (std::map<std::string, Vertex*>::iterator ite = vertices.begin();
		ite != vertices.end();
		ite++)
	{
		delete ite->second;
	}
}

/** return number of vertices */
int Graph::getNumVertices() const
{
	return this->numberOfVertices;
}

/** return number of vertices */
int Graph::getNumEdges() const
{
	return numberOfEdges;
}

/** add a new edge between start and end vertex
	if the vertices do not exist, create them
	calls Vertex::connect
	a vertex cannot connect to itself
	or have multiple edges to another vertex */
bool Graph::add(std::string start, std::string end, int edgeWeight)
{
	// Invalid input, start-end.
	if (start == end)
		return false;

	// Assign startV, and endV, if they exist.
	Vertex * startV = findOrCreateVertex(start);
	findOrCreateVertex(end);

	// Connect froM startV to endV.
	if (startV->connect(end, edgeWeight))
	{
		++numberOfEdges;
		return true;
	}

	return false;
}

/** return weight of the edge between start and end
	returns INT_MAX if not connected or vertices don't exist */
int Graph::getEdgeWeight(std::string start, std::string end) const
{
	Vertex * vertex = findVertex(start);

	// If the vertex does not exist.
	if (vertex == nullptr)
		return INT_MAX;

	return vertex->getEdgeWeight(end);
}

/** read edges from file
	the first line of the file is an integer, indicating number of edges
	each edge line is in the form of "string string int"
	fromVertex  toVertex    edgeWeight */
void Graph::readFile(std::string filename)
{
	// Open the filestream
	std::ifstream f;
	f.open(filename, std::ios_base::in);

	try
	{
		if (!f)
			throw std::runtime_error("File not found");

		// Get vertex number and save;
		int edgeNum;
		f >> edgeNum;

		for (int i = 0; i <= edgeNum; i++)
		{
			std::string fromV, toV;
			int weight;
			f >> fromV;
			f >> toV;
			f >> weight;

			add(fromV, toV, weight);
		}
	}
	catch (std::exception &e)
	{
		std::cerr << e.what() << std::endl;
	}
}

/** depth-first traversal starting from startLabel
	call the function visit on each vertex label */
void Graph::depthFirstTraversal(std::string startLabel,
	void visit(const std::string&))
{
	depthFirstTraversalHelper(findVertex(startLabel), visit);
}

/** breadth-first traversal starting from startLabel
	call the function visit on each vertex label */
void Graph::breadthFirstTraversal(std::string startLabel,
	void visit(const std::string&))
{
	breadthFirstTraversalHelper(findVertex(startLabel), visit);
}

/** find the lowest cost from startLabel to all vertices that can be reached
	using Djikstra's shortest-path algorithm
	record costs in the given map weight
	weight["F"] = 10 indicates the cost to get to "F" is 10
	record the shortest path to each vertex using given map previous
	previous["F"] = "C" indicates get to "F" via "C"

	cpplint gives warning to use pointer instead of a non-const map
	which I am ignoring for readability */
void Graph::djikstraCostToAllVertices(
	std::string startLabel,
	std::map<std::string, int>& weight,
	std::map<std::string, std::string>& previous)
{
	// Clear weight and previous to reduce the error.
	weight.clear();
	previous.clear();

	// Lambda function to organize the priority queue based on edge weight.
	auto cmp = [](std::pair<std::string, int> left,
		std::pair<std::string, int> right) {
		return (left.second) > (right.second);
	};

	// Declare Priority queue.
	std::priority_queue<std::pair<std::string, int>,
		std::vector<std::pair<std::string, int>>,
		decltype(cmp)> pq(cmp);

	Vertex * vt = findVertex(startLabel);
	vt->visit();

	for (std::string neigh; (neigh = vt->getNextNeighbor()) != startLabel;)
	{
		weight[neigh] = getEdgeWeight(startLabel, neigh);
		previous[neigh] = startLabel;
		pq.push(std::pair<std::string, int>(neigh, weight[neigh]));
	}

	while (!pq.empty())
	{
		vt = findVertex(pq.top().first);
		int commulate = pq.top().second;

		if (!(vt->isVisited()))
		{
			vt->visit();

			for (std::string neigh;
				(neigh = vt->getNextNeighbor()) != vt->getLabel();)
			{
				if (weight.find(neigh) == weight.end() &&
					!findVertex(neigh)->isVisited())
				{
					// We could not get 'neigh' before.
					// This is the only path.
					weight[neigh] = getEdgeWeight(vt->getLabel(), neigh)
						+ pq.top().second;
					pq.push(std::pair<std::string, int>
						(neigh, weight[neigh]));
					previous[neigh] = vt->getLabel();
				}
				else if (!findVertex(neigh)->isVisited())
				{
					// We could go neigh before
					// is going better?
					if (weight[neigh] >
						(getEdgeWeight(vt->getLabel(), neigh)+pq.top().second))
					{
						// Yes! It's better.
						weight[neigh] =
							getEdgeWeight(vt->getLabel(), neigh) +
							pq.top().second;

						previous[neigh] = vt->getLabel();

						pq.push(std::pair<std::string, int>
							(neigh, weight[neigh]));
					}
				}
			}
		}

		//	Remove the top. (Dequeue)
		pq.pop();
	}

	// Clear unvisited Vertex.
	unvisitVertices();
}

/** helper for depthFirstTraversal */
void Graph::depthFirstTraversalHelper(Vertex* startVertex,
	void visit(const std::string&))
{
	// An empty stack to trace.
	std::stack<Vertex*> vertexStack;

	// Mark the vertex as visited vertex.
	visit(startVertex->getLabel());
	startVertex->visit();
	vertexStack.push(startVertex);

	Vertex* vertexTrav = startVertex;

	while (!vertexStack.empty())
	{
		while (vertexStack.top() !=
			(vertexTrav = findVertex(vertexTrav->getNextNeighbor())))
		{
			if (vertexTrav->isVisited())
			{
				// If this is the visited vertex.

				vertexTrav = vertexStack.top();
				continue;
			}
			else
			{
				// If this is not visited vertex.

				vertexStack.push(vertexTrav);
				vertexTrav->visit();
				visit(vertexTrav->getLabel());
				continue;
			}
		}

		// Pop out from stack, if there is not possible route.
		vertexStack.pop();
		if (!vertexStack.empty())
			vertexTrav = vertexStack.top();
	}


	// Reset the searching info (visit info)
	unvisitVertices();
}

/** helper for breadthFirstTraversal */
void Graph::breadthFirstTraversalHelper(Vertex*startVertex,
	void visit(const std::string&))
{
	// An empty queue to trace.
	std::queue<Vertex*> vertexQueue;

	// Mark the vertex as visited vertex.
	visit(startVertex->getLabel());
	startVertex->visit();
	vertexQueue.push(startVertex);

	// Iterate solution BFS.
	Vertex* vertexTrav = startVertex;
	while (!vertexQueue.empty())
	{
		vertexTrav = vertexQueue.front();

		// Compare top of queue with its neighbor.
		while (vertexQueue.front() !=
			(vertexTrav = findVertex(vertexQueue.front()->getNextNeighbor())))
		{
			// Search only for not visited vertex.
			if (!vertexTrav->isVisited())
			{
				vertexQueue.push(vertexTrav);
				vertexTrav->visit();
			}
		}

		// Dequeue if there is no unvisited vertex.
		vertexQueue.pop();
		if (!vertexQueue.empty())
			visit(vertexQueue.front()->getLabel());
	}

	// Reset the searching info (visit info)
	unvisitVertices();
}

/** mark all verticies as unvisited */
void Graph::unvisitVertices()
{
	// Using iterator to mark everything as unvisited!!
	std::map<std::string, Vertex*>::iterator ite;
	for (ite = vertices.begin(); ite != vertices.end(); ite++)
	{
		ite->second->unvisit();
	}

	return;
}

/** find a vertex, if it does not exist return nullptr */
Vertex* Graph::findVertex(const std::string& vertexLabel) const
{
	if (vertices.end() == vertices.find(vertexLabel))
		return nullptr;

	return (vertices.find(vertexLabel))->second;
}

/** find a vertex, if it does not exist create it and return it */
Vertex* Graph::findOrCreateVertex(const std::string& vertexLabel)
{
	if (findVertex(vertexLabel) != nullptr)
		return findVertex(vertexLabel);

	// Adding process must be implemented here!!!!
	Vertex * vertex = new Vertex(vertexLabel);
	++numberOfVertices;
	vertices.insert(std::pair<std::string, Vertex*>(vertexLabel, vertex));
	return vertex;
}
