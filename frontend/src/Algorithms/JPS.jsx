import { getNeighbors } from "./algoFunctions.jsx";


import { RpcProvider, shortString, Contract, cairo, CallData } from "starknet";

async function jps(grid, startCell, endCell) {
    
    const height = grid.length;
    const witdh = grid[0].length;

    let tiles = [];
    for (let col = 0; col < grid.length; col++) {
      for (let row = 0; row < grid[col].length; row++) {
          const tile = {id: row * witdh + col, x: col, y: row, is_walkable: !grid[col][row].wall};
          tiles.push(tile);
      }
    }

    const provider = new RpcProvider({ nodeUrl: "https://starknet-testnet.public.blastapi.io" }); // only for starknet-devnet-rs

    const response = await fetch("./src/ABI/abi_jps.json");
    const ABIjps = await response.json();

    const jpsContract = new Contract(ABIjps, "0x039fa849bd88d0a87b0df6b65ae8fbf423f20fed5eae6cabbd326216dd2b070b", provider);
    const callData = new CallData(ABIjps);

    const myCallData = callData.compile("jps", {
        tiles: tiles,
        map_width: witdh,
        map_height: height,
        start: cairo.tuple(startCell.col, startCell.row),
        goal: cairo.tuple( endCell.col, endCell.row)
    });
    const path = await jpsContract.call("jps", myCallData);
    
    const jumpPoints = [];

    path.forEach(obj => {
      const col = cairo.uint256(obj[0]);
      const row = cairo.uint256(obj[1]);
      const cell = {
          row: row.low,
          col: col.low,
          start: false,
          end: false
      };
      jumpPoints.push(cell);
    });

    // Completa el camino con los puntos intermedios
    const completedPath = [];
    for (let i = 0; i < jumpPoints.length - 1; i++) {
        const currentCell = jumpPoints[i] ;
        const nextCell = jumpPoints[i + 1];
        
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
            completedPath.push({ col: x, row: y, start: false, end: false });
        }
    }
    // Agrega la celda final al camino compSletado
    completedPath.push(path[path.length - 1]);
    return completedPath;
}

export default jps;
