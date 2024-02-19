import { updateDistanceOfNeighbors } from "./algoFunctions.jsx";

//Find path from start to end using Dijkstra's Algorithm
const dijkstra = (grid, startCell) => {
  const cellsInOrder = [];
  let unvisitedCells = [startCell];
  startCell.distance = 0;
  while (unvisitedCells.length) {
    unvisitedCells.sort((cell1, cell2) => cell1.distance - cell2.distance);
    const nearestCell = unvisitedCells.shift();
    if (nearestCell.distance === Infinity) return cellsInOrder;
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

export default dijkstra;
