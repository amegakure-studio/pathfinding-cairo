import { getNeighbors } from "./algoFunctions.jsx";


import { RpcProvider, shortString, Contract, cairo, CallData } from "starknet";

async function a_star(grid, startCell, endCell) {
    
    const height = grid.length;
    const witdh = grid[0].length;

    let tiles = [];
    for (let col = 0; col < grid.length; col++) {
      for (let row = 0; row < grid[col].length; row++) {
          const tile = {id: row * witdh + col, x: col, y: row, is_walkable: !grid[col][row].wall};
          tiles.push(tile);
      }
    }

    const provider = new RpcProvider({ nodeUrl: "https://starknet-sepolia.public.blastapi.io/rpc/v0_6" }); // only for starknet-devnet-rs

    const JPSClassAt = await provider.getClassAt("0x07921148721b727726ff737f9c65e411c730ab7dd9667f323dd449067daa0c8f");

    const jpsContract = new Contract(JPSClassAt.abi, "0x07921148721b727726ff737f9c65e411c730ab7dd9667f323dd449067daa0c8f", provider);
    const callData = new CallData(JPSClassAt.abi);

    const myCallData = callData.compile("a_star", {
        tiles: tiles,
        map_width: witdh,
        map_height: height,
        start: cairo.tuple(startCell.col, startCell.row),
        goal: cairo.tuple( endCell.col, endCell.row)
    });

    let path;
    try {
      path = await jpsContract.call("jps", myCallData);
    } catch(error) {
      throw new Error('Contract error: No remaining steps available.');
    }

    console.log("path", path);
    if (path.length == 0) {
      throw new Error('Could not find a valid path on the provided map.');
    }
    
    const parsedJumpPoints = [];
    path.forEach(obj => {
      const col = cairo.uint256(obj[0]);
      const row = cairo.uint256(obj[1]);
      const cell = {
          row: row.low,
          col: col.low,
          start: false,
          end: false,
          jumpPoint: true
      };
      parsedJumpPoints.push(cell);
    });

    // Completa el camino con los puntos intermedios
    const completedPath = [];
    for (let i = 0; i < parsedJumpPoints.length - 1; i++) {
        const currentCell = parsedJumpPoints[i] ;
        const nextCell = parsedJumpPoints[i + 1];
        
        // Agrega el punto actual al camino completado
        completedPath.push(currentCell);
        
        // Calcula los puntos intermedios en línea recta entre las celdas actual y siguiente
        const deltaX = nextCell.col - currentCell.col;
        const deltaY = nextCell.row - currentCell.row;
        const distance = Math.max(Math.abs(deltaX), Math.abs(deltaY));
        
        for (let j = 1; j < distance; j++) {
          const col = parseInt(currentCell.col, 10);
          const row = parseInt(currentCell.row, 10);
          
            const x = Math.floor(col + deltaX * (j / distance)).toString();
            const y = Math.floor(row + deltaY * (j / distance)).toString();
            completedPath.push({ col: x, row: y, start: false, end: false, jumpPoint: false });
        }
    }
    // Agrega la celda final al camino compSletado
    completedPath.push(parsedJumpPoints[parsedJumpPoints.length - 1]);
    return completedPath;
}

export default a_star;
