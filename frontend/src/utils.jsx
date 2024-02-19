import jps from "./Algorithms/JPS.jsx";
import random from "./Mazes/Personal.jsx";
import recursiveDivision from "./Mazes/RecursiveDivision.jsx";
import recursiveBacktracking from "./Mazes/RecusiveBacktracking.jsx";
import prim from "./Mazes/Prims.jsx";
import binaryTree from "./Mazes/binaryTree.jsx";

export const algos = {
  "Jump Point Search": jps,
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
};

export const speeds = {
  Slow: 10,
  Average: 5,
  Fast: 3,
  Instant: 0,
};
