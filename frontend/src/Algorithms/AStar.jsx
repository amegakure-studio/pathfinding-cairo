import {
  updateDistanceOfNeighbors,
  manhattanDistance,
} from "./algoFunctions.jsx";

//Find path from start to end using aStar search
const aStar = (grid, startCell, endCell) => {
  const cellsInOrder = [];
  const unvisitedCells = [startCell];
  startCell.distance = 0;
  while (unvisitedCells.length) {
    const [nearestCell, nearestCellIndex] = getNearestCellAStar(
      unvisitedCells,
      endCell
    );
    if (nearestCell.distance === Infinity) return cellsInOrder;
    unvisitedCells.splice(nearestCellIndex, 1);
    cellsInOrder.push(nearestCell);
    if (nearestCell.end) return cellsInOrder;
    nearestCell.visited = true;
    const neighbors = updateDistanceOfNeighbors(grid, nearestCell);
    neighbors.forEach((neighbor) => {
      neighbor.inList = true;
      unvisitedCells.push(neighbor);
    });
  }
  return cellsInOrder;
};

//Loop through unvisitedCells and find cell with lowest F-Cost, if tied - choose cell with lowest H-Cost
const getNearestCellAStar = (unvisitedCells, endCell) => {
  let nearestCellIndex = 0;
  let nearestCell = unvisitedCells[0];
  let heuristicCost = manhattanDistance(nearestCell, endCell); //H-Cost
  let totalCost = nearestCell.distance + heuristicCost; //F-Cost = G-Cost + H-Cost

  for (let i = 1; i < unvisitedCells.length; i++) {
    const currCell = unvisitedCells[i];
    const currHeuristicCost = manhattanDistance(currCell, endCell);
    const currTotalCost = currCell.distance + currHeuristicCost;

    if (
      currTotalCost < totalCost ||
      (currTotalCost === totalCost && currHeuristicCost < heuristicCost)
    ) {
      nearestCellIndex = i;
      nearestCell = currCell;
      heuristicCost = currHeuristicCost;
      totalCost = currTotalCost;
    }
  }
  return [nearestCell, nearestCellIndex];
};

export default aStar;
