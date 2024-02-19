import { getNeighbors } from "./algoFunctions";

const iddfs = (grid, start) => {
  let depth = 0;
  let cellsInOrder;
  const maxDepth = grid.length * grid[0].length;

  while (depth < maxDepth) {
    grid.forEach(row => row.forEach(cell => cell.visited = false));

    cellsInOrder = depthLimitedDfs(grid, start, depth);

    if (cellsInOrder.find(cell => cell.end)) return cellsInOrder;
    if (cellsInOrder.length === 0) break;

    depth++;
  }
  return cellsInOrder;
};

const depthLimitedDfs = (grid, startCell, limit, currentDepth = 0) => {
    if (currentDepth > limit) return [];

    const cellsInOrder = [];
    if (startCell.visited) return cellsInOrder;
    cellsInOrder.push(startCell);
    if (startCell.end) return cellsInOrder;
    
    startCell.visited = true;
    const neighbors = getNeighbors(grid, startCell);
    for (const neighbor of neighbors) {
      neighbor.prevCell = startCell;
      const result = depthLimitedDfs(grid, neighbor, limit, currentDepth + 1);
      cellsInOrder.push(...result);
      if (result.find(cell => cell.end)) {
        return cellsInOrder;
      }
    }
    return cellsInOrder;
  };
  
export default iddfs;
