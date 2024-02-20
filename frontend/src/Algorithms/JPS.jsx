import { getNeighbors } from "./algoFunctions.jsx";


import { RpcProvider, shortString, Contract, cairo, CallData } from "starknet";

async function jps(grid, startCell, endCell) {
    
    const witdh = grid.length;
    const height = grid[0].length;

    let tiles = [];
    for (let col = 0; col < grid.length; col++) {
      for (let row = 0; row < grid[col].length; row++) {
          // const tile = {id: col * witdh + row, x: row, y: col, is_walkable: !grid[row][col].wall};
          if (grid[col][row].wall) {
            console.log("grid[row][col]: ", grid[row][col]);
          }
          const tile = {id: row * witdh + col, x: col, y: row, is_walkable: !grid[col][row].wall};
          tiles.push(tile);
      }
    }

    console.log("tiles: ", tiles);

    const provider = new RpcProvider({ nodeUrl: "https://starknet-testnet.public.blastapi.io" }); // only for starknet-devnet-rs

    const response = await fetch("./src/ABI/abi_jps.json");
    const ABIjps = await response.json();

    const jpsContract = new Contract(ABIjps, "0x039fa849bd88d0a87b0df6b65ae8fbf423f20fed5eae6cabbd326216dd2b070b", provider);
    const callData = new CallData(ABIjps);

    console.log("startCell.col: ", startCell);

    const myCallData = callData.compile("jps", {
        tiles: tiles,
        map_width: witdh,
        map_height: height,
        start: cairo.tuple(startCell.col, startCell.row),
        goal: cairo.tuple( endCell.col, endCell.row)
    });
    const path = await jpsContract.call("jps", myCallData);
    
    const result = [];

    path.forEach(obj => {
      const row = cairo.uint256(obj[0]);
      const col = cairo.uint256(obj[1]);
      const cell = {
          row: row.low,
          col: col.low,
          start: false,
          end: false
      };
      result.push(cell);
    });
    return result;
}

// const jps = (grid, startCell) => {
//   const cellsInOrder = [];
//   const unvisitedCells = [startCell]; // Will act as a stack

//   while (unvisitedCells.length) {
//     const currCell = unvisitedCells.pop();
//     if (currCell.visited) continue;
//     cellsInOrder.push(currCell);
//     if (currCell.end) return cellsInOrder;
//     currCell.visited = true;
//     const neighbors = getNeighbors(grid, currCell);
//     neighbors.forEach((neighbor) => {
//       neighbor.prevCell = currCell;
//       unvisitedCells.push(neighbor);
//     });
//   }
//   return cellsInOrder;
// };

export default jps;
