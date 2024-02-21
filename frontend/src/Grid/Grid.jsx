import React, { useState, useEffect, useContext, useMemo } from "react";
import { GridContext } from "../App.jsx";
import Cell from "./Cell.jsx";
import "./Grid.scss";
import { algos } from "../utils.jsx";
import { getShortestPath } from "../Algorithms/algoFunctions.jsx";

function Grid() {
  const {
    grid,
    setGrid,
    description,
    setDescription,
    isAnimating,
    startPosition,
    setStartPosition,
    endPosition,
    setEndPosition,
    setPathfindingLength,
    setShortestPathLength,
    setPathfindingAnimation,
    setShortestPathAnimation,
    setSize
  } = useContext(GridContext);

  const [mousePressed, setMousePressed] = useState(false);
  const [dragCell, setDragCell] = useState({
    type: null,
    row: null,
    col: null,
  });

  useEffect(() => {
    const handleMouseUpWindow = () => {
      if (mousePressed) {
        setMousePressed(false);
      }
    };
    window.addEventListener("mouseup", handleMouseUpWindow);

    return () => {
      window.removeEventListener("mouseup", handleMouseUpWindow);
    };
  }, [mousePressed]);

  useEffect(() => {
    if (
      description !== "Select an Algorithm to Visualize" &&
      description !== "Random Maze" &&
      description !== "Recursive Division" &&
      description !== "Prim's Algorithm" &&
      description !== "Recursive Backtracking" &&
      description !== "Binary Tree"
    ) {
      updatePathfinding();
    }
  }, [dragCell]);

  const handleMouseDown = (row, col) => {
    if (isAnimating) return; //if animation in-prog, dont do anything
    setMousePressed(true);
    const cell = grid[row][col];
    const cellType = cell.start ? "start" : cell.end ? "end" : "wall";
    setDragCell({ type: cellType, row, col });
    if (cellType === "wall") updateCell(row, col, cellType);
  };

  const handleMouseOver = (row, col) => {
    if (isAnimating) return;
    if (
      !mousePressed ||
      !dragCell.type ||
      (dragCell.row === row && dragCell.col === col)
    )
      return;
    if (
      (dragCell.type === "start" || dragCell.type === "end") &&
      (grid[row][col].start || grid[row][col].end)
    )
      return;
    updateCell(row, col, dragCell.type);
    setDragCell({ ...dragCell, row, col });
    if (dragCell.type === "start") setStartPosition([row, col]);
    if (dragCell.type === "end") setEndPosition([row, col]);
  };

  const handleMouseUp = () => {
    if (isAnimating) return;
    setMousePressed(false);
    setDragCell({ type: null, row: null, col: null });
  };

  const eventHandlers = {
    onMouseDown: handleMouseDown,
    onMouseOver: handleMouseOver,
    onMouseUp: handleMouseUp,
  };

  const updateCell = (cellRow, cellCol, cellType) => {
    setGrid((currGrid) => {
      const newGrid = currGrid.map((row, rowIndex) => {
        return row.map((cell, colIndex) => {
          //make prev start/end cell false
          if (
            cell[cellType] === true &&
            (cellType === "start" || cellType === "end")
          )
            return { ...cell, [cellType]: false };
          //update correct cell to be opposite of what it originally was
          if (rowIndex === cellRow && colIndex === cellCol) {
            if (
              (cellType === "start" || cellType === "end") &&
              currGrid[cellRow][cellCol].wall
            )
              return { ...cell, [cellType]: !cell[cellType], wall: false };
            return { ...cell, [cellType]: !cell[cellType] };
          }
          //return cell if neither condition is true
          return cell;
        });
      });
      return newGrid;
    });
  };

  const updatePathfinding = () => {
    const algoToRun = description;
    let newGrid = [...grid];
    newGrid.forEach((row) => {
      row.forEach((cell) => {
        cell.visited = false;
        cell.inList = false;
        cell.prevCell = null;
      });
    });
    const startCell = grid[startPosition[0]][startPosition[1]];
    const endCell = grid[endPosition[0]][endPosition[1]];
    const allCellsInOrder = algos[algoToRun](newGrid, startCell, endCell);
    
    if (algoToRun === "Bidirectional Search") {
      const { path, finalPath } = allCellsInOrder;
      if(!path) return;
      setDescription(algoToRun);
      const updatedPathfinding = new Set();
      const updatedShortest = new Set();
      path.forEach((cell) => {
        updatedPathfinding.add(`cell-${cell.row}-${cell.col}`);
      });
      setPathfindingAnimation(updatedPathfinding);
      setPathfindingLength(path.length - 1);
      if (!finalPath)  {
        setShortestPathAnimation(new Set());
        setShortestPathLength("n/a");
        return;
      }
      finalPath.forEach((cell) => {
        updatedShortest.add(`cell-${cell.row}-${cell.col}`);
      });
      setShortestPathAnimation(updatedShortest);
      if(finalPath.length === 0) {
        setShortestPathLength(0);
        return;
      }
      setShortestPathLength(finalPath.length - 1);
      return;
    }
    const shortestPath = getShortestPath(
      allCellsInOrder[allCellsInOrder.length - 1]
    );

    //Update the animation state
    const updatedPathfinding = new Set();
    const updatedShortest = new Set();
    allCellsInOrder.forEach((cell) => {
      updatedPathfinding.add(`cell-${cell.row}-${cell.col}`);
    });
    shortestPath.forEach((cell) => {
      updatedShortest.add(`cell-${cell.row}-${cell.col}`);
    });
    setPathfindingAnimation(updatedPathfinding);
    setShortestPathAnimation(updatedShortest);

    //Set distance traveled for path
    setDescription(algoToRun);
    setPathfindingLength(allCellsInOrder.length - 1);
    if(shortestPath.length === 0) {
      setShortestPathLength(0);
      return;
    }
    setShortestPathLength(shortestPath.length - 1);
  };

  return (
    <div className="grid">
      {grid.map((row, rowIndex) => {
        return (
          <div key={`row-${rowIndex}`}>
            {row.map((cell, cellIndex) => {
              return (
                <Cell
                  key={`cell-${rowIndex}-${cellIndex}`}
                  cellInfo={cell}
                  eventHandlers={eventHandlers}
                ></Cell>
              );
            })}
          </div>
        );
      })}
    </div>
  );
};
Grid = React.memo(Grid)

export default Grid;
