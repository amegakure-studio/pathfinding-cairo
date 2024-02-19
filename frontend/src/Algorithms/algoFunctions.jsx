
//find neighbors and change their distance and prevCell property
export const updateDistanceOfNeighbors = (grid, cell) => {
  const neighbors = getNeighbors(grid, cell);
  neighbors.forEach((neighbor) => {
    neighbor.distance = cell.distance + 1;
    neighbor.prevCell = cell;
  });
  return neighbors;
};

//Get neighbors of cells which are not yet added to the unvisited cells list,
// has not been visited and is not a wall or out of bounds
export const getNeighbors = (grid, cell) => {
  const neighbors = [];
  const { row, col } = cell;
  if (row > 0) neighbors.push(grid[row - 1][col]);
  if (col < grid[0].length - 1) neighbors.push(grid[row][col + 1]);
  if (row < grid.length - 1) neighbors.push(grid[row + 1][col]);
  if (col > 0) neighbors.push(grid[row][col - 1]);
  return neighbors.filter(
    (neighbor) => !neighbor.inList && !neighbor.visited && !neighbor.wall
  );
};

//Manhattan distance for H Cost (heuristic)
export const manhattanDistance = (currCell, endCell) => {
  return (
    Math.abs(endCell.row - currCell.row) + Math.abs(endCell.col - currCell.col)
  );
};

//Backtrack from end cell to start cell and find shortest path based on algorithm
//some algos do not guarantee actual shortest path
export const getShortestPath = (endCell) => {
  const shortestPath = [];
  let currCell = endCell;
  if(endCell.end) {
    while (currCell) {
      shortestPath.unshift(currCell);
      currCell = currCell.prevCell;
    }
  }
  return shortestPath;
};

//Animate pathfinder algorithm first then the shortest path
export const animateAlgo = (
  allCellsInOrder,
  shortestPath,
  setPathfindingAnimation,
  setShortestPathAnimation,
  setIsAnimating,
  animationSpeed = 5 //change speed of pathfinding and shortestPath animation here
) => {
  allCellsInOrder.forEach((cell, index) => { //Pathfinding Animation 
    setTimeout(() => {
      setPathfindingAnimation((prevState) => {
        const updatedState = new Set(prevState);
        updatedState.add(`cell-${cell.row}-${cell.col}`);
        return updatedState;
      });
    }, index * animationSpeed);
  });
  setTimeout(() => { //Shortest Path animation after pathfinding is complete 
    shortestPath.forEach((cell, index) => {
      setTimeout(() => {
        setShortestPathAnimation((prevState) => {
          const updatedState = new Set(prevState);
          updatedState.add(`cell-${cell.row}-${cell.col}`);
          return updatedState;
        });
      }, index * animationSpeed * 3);
    });
  }, allCellsInOrder.length * animationSpeed);

  const totalAnimationTime = allCellsInOrder.length * animationSpeed + (shortestPath.length * animationSpeed * 2.5);
  setTimeout(() => { //Set animation to false when done animating
    setIsAnimating(false)
  }, totalAnimationTime)
};