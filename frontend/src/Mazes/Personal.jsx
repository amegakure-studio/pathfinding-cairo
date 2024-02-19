import { chooseRandomCell, unblockSet } from "./mazeFunctions";

const random = (grid, start, end) => {
  const frontiers = new Set();
  const inside = new Set();
  const startCell = chooseRandomCell(grid);
  startCell.visited = true;
  inside.add(startCell);
  addFrontiers(startCell, grid, frontiers);

  while (frontiers.size > 0) {
    const frontier = getRandomFrontier(frontiers);
    frontiers.delete(frontier);
    const [x1, y1, x2, y2] = frontier;
    const cell1 = grid[x1][y1];
    const cell2 = grid[x2][y2];

    if (!cell2.visited) {
      cell1.visited = true;
      cell2.visited = true;
      if (!cell1.start && !cell1.end) inside.add(cell1);
      if (!cell2.start && !cell2.end) inside.add(cell2);
      addFrontiers(cell2, grid, frontiers);
    }
  }

  unblockSet(grid, start, end, inside)
  return shuffleArray(Array.from(inside));
};
const addFrontiers = (cell, grid, frontiers) => {
  const x = cell.row;
  const y = cell.col;
  if (x >= 2 && !grid[x - 2][y].visited) frontiers.add([x - 1, y, x - 2, y]);
  if (y >= 2 && !grid[x][y - 2].visited) frontiers.add([x, y - 1, x, y - 2]);
  if (x < grid.length - 2 && !grid[x + 2][y].visited)
    frontiers.add([x + 1, y, x + 2, y]);
  if (y < grid[0].length - 2 && !grid[x][y + 2].visited)
    frontiers.add([x, y + 1, x, y + 2]);
};
const getRandomFrontier = (frontiers) => {
  const num = Math.floor(Math.random() * frontiers.size);
  let index = 0;
  for (const ele of frontiers) {
    if (index === num) return ele;
    index++;
  }
  return;
};
const shuffleArray = (array) => {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]]; // Swap elements
    }
    return array;
  };

  export default random;