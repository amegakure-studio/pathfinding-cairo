let NUM_ROW = 5;
let NUM_COL = 4;

export const createBlankGrid = (startPosition, endPosition) => {
  const blankGrid = [];
  console.log("creating..")
  for (let row = 0; row < NUM_ROW; row++) {
    const currRow = [];
    for (let col = 0; col < NUM_COL; col++) {
      currRow.push(createCellData(row, col, startPosition, endPosition));
    }
    blankGrid.push(currRow);
  }
  return blankGrid;
};

//Function to create a grid of cell data w/ default start & end

const createCellData = (row, col, startPosition, endPosition) => {
  return {
    row,
    col,
    start: row === startPosition[0] && col === startPosition[1],
    end: row === endPosition[0] && col === endPosition[1],
    distance: Infinity,
    visited: false,
    wall: false,
    prevCell: null,
  };
};

export const setSize = (width, height) => {
  NUM_ROW = height
  NUM_COL = width
  createBlankGrid(start(), end())
  console.log("SETSIZE!")
};

export const start = () => {
  return [Math.floor(NUM_ROW / 8), Math.floor(NUM_COL / 2 - 1)];
};
export const end = () => {
  return [Math.floor((NUM_ROW / 8) * 7), Math.floor(NUM_COL / 2 - 1)];
};
export const clearPath = (
  grid,
  setGrid,
  setDescription,
  setPathfindingAnimation,
  setShortestPathAnimation,
  setPathfindingLength,
  setShortestPathLength
) => {
  //keep grid w walls and reset all other properties, empty sets with animation information
  setPathfindingAnimation(new Set());
  setShortestPathAnimation(new Set());
  let newGrid = [...grid];
  newGrid.forEach((row) => {
    row.forEach((cell) => {
      cell.visited = false;
      cell.inList = false;
      cell.prevCell = null;
    });
  });
  setGrid(newGrid);
  setPathfindingLength(0);
  setShortestPathLength(0);
  setDescription("Select an Algorithm to Visualize");
};
