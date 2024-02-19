import { getNeighbors } from "./algoFunctions.jsx";

const bfs = (grid, startCell) => {
  const cellsInOrder = [];
  const unvisitedCells = [startCell]; // Will act as queue

  while (unvisitedCells.length) {
    const currCell = unvisitedCells.shift();
    cellsInOrder.push(currCell);
    if (currCell.end) return cellsInOrder;
    currCell.visited = true;
    const neighbors = getNeighbors(grid, currCell);
    neighbors.forEach((neighbor) => {
      neighbor.prevCell = currCell;
      neighbor.inList = true;
      unvisitedCells.push(neighbor);
    });
  }
  return cellsInOrder;
};

export default bfs;
