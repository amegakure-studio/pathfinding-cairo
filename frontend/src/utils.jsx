import dijkstra from "./Algorithms/Dijkstra";
import aStar from "./Algorithms/AStar.jsx";
import bds from "./Algorithms/BDS.jsx";
import iddfs from "./Algorithms/IDDFS.jsx";
import greedy from "./Algorithms/Greedy.jsx";
import bfs from "./Algorithms/BFS.jsx";
import dfs from "./Algorithms/DFS.jsx";
import random from "./Mazes/Personal.jsx";
import recursiveDivision from "./Mazes/RecursiveDivision.jsx";
import recursiveBacktracking from "./Mazes/RecusiveBacktracking.jsx";
import prim from "./Mazes/Prims.jsx";
import binaryTree from "./Mazes/binaryTree.jsx";

export const algos = {
  "Dijkstra's Algorithm": dijkstra,
  "A* Search": aStar,
  "Bidirectional Search": bds,
  "Iterative Deepening Search": iddfs,
  "Greedy Best-First Search": greedy,
  "Breadth-First Search": bfs,
  "Depth-First Search": dfs,
};

export const mazes = {
  "Random Maze": random,
  "Recursive Division": recursiveDivision,
  "Recursive Backtracking": recursiveBacktracking,
  "Prim's Algorithm": prim,
  "Binary Tree": binaryTree
};

export const descriptions = {
  "Dijkstra's Algorithm": "is weighted and guarantees the shortest path!",
  "A* Search": "is weighted and guarantees the shortest path!",
  "Greedy Best-First Search":
    "is weighted and does not guarantee the shortest path!",
  "Breadth-First Search": "is unweighted and guarantees the shortest path!",
  "Depth-First Search":
    "is unweighted and does not guarantee the shortest path!",
  "Random Maze": "was custom made for fun :)",
  "Recursive Division": "divides a space recursively until a condition is met",
  "Prim's Algorithm": "creates a minimum spanning tree",
  "Recursive Backtracking": "recursively explores and carves paths",
  "Binary Tree": "creates a maze with a diagonal bias",
  "Bidirectional Search": "is weighted and does not guarantee the the shortest path!",
  "Iterative Deepening Search": "is unweighted and does not guarantee the shortest path!"
};

export const speeds = {
  Slow: 10,
  Average: 5,
  Fast: 3,
  Instant: 0,
};
