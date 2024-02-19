import { getNeighbors, manhattanDistance } from "./algoFunctions.jsx";

const greedy = (grid, startCell, endCell) => {
  const cellsInOrder = [];
  const unvisitedCells = [startCell];
  
  while (unvisitedCells.length) {
    const [nearestCell, nearestCellIndex] = getNearestCellGreedy(
      unvisitedCells,
      endCell
    );
    unvisitedCells.splice(nearestCellIndex, 1);
    cellsInOrder.push(nearestCell);
    if (nearestCell.end) return cellsInOrder;
    nearestCell.visited = true;
    const neighbors = getNeighbors(grid, nearestCell);
    neighbors.forEach((neighbor) => {
      neighbor.prevCell = nearestCell;
      neighbor.inList = true;
      unvisitedCells.push(neighbor);
    });
  }
  return cellsInOrder;
};

//Loop through unvisitedCells and find cell with lowest H-Cost
const getNearestCellGreedy = (unvisitedCells, endCell) => {
  let nearestCellIndex = 0;
  let nearestCell = unvisitedCells[0];
  let heuristicCost = manhattanDistance(nearestCell, endCell); //H-Cost

  for (let i = 1; i < unvisitedCells.length; i++) {
    const currCell = unvisitedCells[i];
    const currHeuristicCost = manhattanDistance(currCell, endCell);

    if (currHeuristicCost < heuristicCost) {
      nearestCellIndex = i;
      nearestCell = currCell;
      heuristicCost = currHeuristicCost;
    }
  }
  return [nearestCell, nearestCellIndex];
};

export default greedy;
