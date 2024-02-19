import { unblock } from "./mazeFunctions";

const binaryTree = (grid, start, end) => {
  const pathInOrder = [];
  for (let i = 0; i < grid.length; i++) {
    for (let j = 0; j < grid[0].length; j++) {
      if (
        i === 0 ||
        j === 0 ||
        i === grid.length - 1 ||
        j === grid[0].length - 1
      ) {
        if(!grid[i][j].start && !grid[i][j].end) pathInOrder.push(grid[i][j]);
      }
    }
  }
  for (let row = 0; row < grid.length; row += 2) {
    for (let col = 0; col < grid[0].length; col += 2) {
      if (row + 1 < grid.length && Math.random() > 0.5) {
        if (!grid[row][col].start && !grid[row][col].end)
          pathInOrder.push(grid[row][col]);
        if (!grid[row + 1][col].start && !grid[row + 1][col].end)
          pathInOrder.push(grid[row + 1][col]);
      } else if (col + 1 < grid[0].length) {
        if (!grid[row][col].start && !grid[row][col].end)
          pathInOrder.push(grid[row][col]);
        if (!grid[row][col + 1].start && !grid[row][col + 1].end)
          pathInOrder.push(grid[row][col + 1]);
      }
    }
  }
  unblock(grid, start, end,pathInOrder)
  return pathInOrder;
};

export default binaryTree;


