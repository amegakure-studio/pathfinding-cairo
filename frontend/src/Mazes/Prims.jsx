import { chooseRandomCell, unblock } from "./mazeFunctions";

const prim = (grid, start, end) => {
  const startCell = chooseRandomCell(grid);
  const { row, col } = startCell;
  let path = [];
  const frontiers = [[row, col, row, col]];

  while (frontiers.length) {
    const index = Math.floor(Math.random() * frontiers.length);
    const [x1, y1, x2, y2] = frontiers.splice(index, 1)[0]; //remove cell from array

    const cell1 = grid[x1][y1];
    const cell2 = grid[x2][y2];
    if (!cell2.visited) {
      cell1.visited = true;
      cell2.visited = true;
      if (!cell1.start && !cell1.end) path.push(cell1);
      if (!cell2.start && !cell2.end) path.push(cell2);
      const neighbors = getFrontiers(grid, x2, y2);
      neighbors.forEach((n) => frontiers.push(n));
    }
  }
  path = unblock(grid, start, end, path)
  return path;
};

const getFrontiers = (grid, x, y) => {
  const frontiers = [];
  if (x >= 2 && !grid[x - 2][y].visited) frontiers.push([x - 1, y, x - 2, y]);
  if (y >= 2 && !grid[x][y - 2].visited) frontiers.push([x, y - 1, x, y - 2]);
  if (x < grid.length - 2 && !grid[x + 2][y].visited)
    frontiers.push([x + 1, y, x + 2, y]);
  if (y < grid[0].length - 2 && !grid[x][y + 2].visited)
    frontiers.push([x, y + 1, x, y + 2]);
  return frontiers;
};

export default prim;
