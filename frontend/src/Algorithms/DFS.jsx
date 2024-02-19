import { getNeighbors } from "./algoFunctions.jsx";

const dfs = (grid, startCell) => {
  const cellsInOrder = [];
  const unvisitedCells = [startCell]; // Will act as a stack

  while (unvisitedCells.length) {
    const currCell = unvisitedCells.pop();
    if (currCell.visited) continue;
    cellsInOrder.push(currCell);
    if (currCell.end) return cellsInOrder;
    currCell.visited = true;
    const neighbors = getNeighbors(grid, currCell);
    neighbors.forEach((neighbor) => {
      neighbor.prevCell = currCell;
      unvisitedCells.push(neighbor);
    });
  }
  return cellsInOrder;
};

export default dfs;
