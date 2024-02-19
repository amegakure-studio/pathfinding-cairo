# Voyager
This is Voyager, a space-themed pathfinding visualizer I built for my interest in algorithms. 
Click and drag to move the start/end nodes, add/delete walls, and also view real-time animation updates based on changes in the grid. You can also adjust the animation speed for the pathfinding and maze generation algorithms!
Check it out here! https://voyager-aydenyip.vercel.app/ 

## Pathfinding Algorithms
* **Dijkstra's Algorithm:** Explores all paths, selects shortest to unvisited node iteratively
* **A\* Search:** Combines Dijkstra's method with heuristic (Manhattan Distance) for faster targeted pathfinding
* **Bidirectional Search:** Simultaneously searches from start and end nodes and meets in the middle
* **Iterative Deepening Search:** Depth-first with increasing depth limits for breadth-first's completeness
* **Greedy Best-first Search:** Prioritizes nodes closest to goal using heuristic (Manhattan Distance)
* **Breadth-first Search:** Explores neighbors level by level, ensuring shortest path
* **Depth-first Search:** Traverses deeply into each direction before backtracking

## Maze Generation Algorithms
* **Random Maze:** Single path maze randomized for animation purposes 
* **Recursive Division:** Divides grid recursively until a base condition is met, adding walls with passages
* **Recursive Backtracking:** Carves paths using DFS, backtracks upon reaching dead-ends for new paths
* **Prim's Algorithm:** Grows a single maze path from a starting cell, adding nearest walls
* **Binary Tree:** Chooses between two directions at each cell to create paths

https://github.com/aydenyipcs/Pathfinding-Visualizer-/assets/140589955/da183b85-838c-4239-ba46-a5af5c1cd20e

