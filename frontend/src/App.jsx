import React, { createContext, useState, useCallback} from "react";
import Grid from "./Grid/Grid";
import Info from "./Info&Stats/Info";
import NavBar from "./NavBar/NavBar";
import { createBlankGrid, start, end, setSize } from "./Grid/gridFunctions.jsx";
import "./app.scss";

export const GridContext = createContext();

const App = () => {
  const [description, setDescription] = useState("Select an Algorithm to Visualize");
  const [isAnimating, setIsAnimating] = useState(false);
  const [startPosition, setStartPosition] = useState(useCallback(() => start()), []); //Default start position
  const [endPosition, setEndPosition] = useState(useCallback(() => end()), []); //Default end position
  const [grid, setGrid] = useState(useCallback(() => createBlankGrid(startPosition, endPosition)), []); // Initialize Grid
  const [pathfindingAnimation, setPathfindingAnimation] = useState(new Set()); //list of cells for animation 1
  const [shortestPathAnimation, setShortestPathAnimation] = useState(new Set()); //list of cells for animation 2
  const [pathfindingLength, setPathfindingLength] = useState(0);
  const [shortestPathLength, setShortestPathLength] = useState(0);

  return (
    <GridContext.Provider
      value={{
        grid,
        setGrid,
        description,
        setDescription,
        isAnimating,
        setIsAnimating,
        startPosition,
        setStartPosition,
        endPosition,
        setEndPosition,
        pathfindingAnimation,
        setPathfindingAnimation,
        shortestPathAnimation,
        setShortestPathAnimation,
        pathfindingLength,
        setPathfindingLength,
        shortestPathLength,
        setShortestPathLength,
        setSize
      }}
    >
      <div className="mainContainer">
        <NavBar />
        <Grid />
        <Info />
      </div>
    </GridContext.Provider>
  );
};

export default App;
