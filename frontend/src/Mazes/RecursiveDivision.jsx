
const recursiveDivision = (grid) => {
  const width = grid[0].length;
  const height = grid.length
  let wallsInOrder = [];
  divideRecursively(grid, 0, 0, width, height, selectDirection(width, height), wallsInOrder)
  return wallsInOrder;
}
const divideRecursively = (grid, startWidth, startHeight, width, height, isHorizontal, wallsInOrder) => {
  if(width < 3 || height < 3) return;

  let divCol = startHeight + (isHorizontal ? 0 : randomInt(1, width - 2));
  let divRow = startWidth + (isHorizontal ? randomInt(1, height - 2) : 0);

  const length = isHorizontal ? width : height;
  const gapCol = divCol + (isHorizontal ? randomInt(0, width - 1) : 0);
  const gapRow = divRow + (isHorizontal ? 0 : randomInt(0, height - 1))

  const dirCol = isHorizontal ? 1 : 0;
  const dirRow = isHorizontal ? 0 : 1;

  for(let i = 0; i < length; i++) {
    const cell = grid[divRow][divCol];
    const isGap = gapCol === divCol && gapRow === divRow;
    if(!cell.start && !cell.end && !isGap) {
      wallsInOrder.push(cell)
    }
    divCol += dirCol;
    divRow += dirRow
  }
  let [nr, nc] = [startWidth, startHeight];
    let [nw, nh] = isHorizontal ? [width, divRow - startWidth + 1] : [divCol - startHeight + 1, height];
    divideRecursively(grid, nr, nc, nw, nh, selectDirection(nw, nh), wallsInOrder);

    [nc, nr] = isHorizontal ? [startHeight, divRow + 1] : [divCol + 1, startWidth];
    [nw, nh] = isHorizontal ? [width, startWidth + height - divRow - 1] : [startHeight + width - divCol - 1, height];
    divideRecursively(grid, nr, nc, nw, nh, selectDirection(nw, nh), wallsInOrder);
}

const selectDirection = (width, height) => {
  if (width < height) return true;
  if (height < width) return false;
  return Math.random() < 0.5 ? true : false;
}

const randomInt = (min, max) => {
  const minCeil = Math.ceil(min);
  const maxFloor = Math.floor(max);
  return Math.floor((Math.random() * (maxFloor - minCeil + 1)) / 2) * 2 + min;
}

export default recursiveDivision;