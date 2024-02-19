import { chooseRandomCell, unblockSet } from "./mazeFunctions";

const recursiveBacktracking = (grid, start, end) => {
  const startCell = chooseRandomCell(grid);
  startCell.visited = true;
  const pathInOrder = new Set();
  pathInOrder.add(startCell)
  dfs(grid, startCell, pathInOrder);
  unblockSet(grid, start, end, pathInOrder)
  return Array.from(pathInOrder);
};
  
const dfs = (grid, cell, pathInOrder) => {

  const unvisitedNeighbors = getUnvisitedNeighbors(grid, cell);
  while (unvisitedNeighbors.length) {
    const index = Math.floor(Math.random() * unvisitedNeighbors.length);
    const [x1, y1, x2, y2] = unvisitedNeighbors.splice(index, 1)[0]; //remove cell from array
    if (!grid[x2][y2].visited) {
        if(!grid[x1][y1].start && !grid[x1][y1].end) {
            grid[x1][y1].visited = true;
            pathInOrder.add(grid[x1][y1]);
        }
        if(!grid[x2][y2].start && !grid[x2][y2].end) {
            grid[x2][y2].visited = true;
            pathInOrder.add(grid[x2][y2]);
        }
      dfs(grid, grid[x2][y2], pathInOrder);
    }
  }
};

const getUnvisitedNeighbors = (grid, cell) => {
  const neighbors = [];
  const x = cell.row;
  const y = cell.col;
  if (x >= 2 && !grid[x - 2][y].visited) neighbors.push([x - 1, y, x - 2, y]);
  if (y >= 2 && !grid[x][y - 2].visited) neighbors.push([x, y - 1, x, y - 2]);
  if (x < grid.length - 2 && !grid[x + 2][y].visited)
    neighbors.push([x + 1, y, x + 2, y]);
  if (y < grid[0].length - 2 && !grid[x][y + 2].visited)
    neighbors.push([x, y + 1, x, y + 2]);
  return neighbors;
};

export default recursiveBacktracking;
