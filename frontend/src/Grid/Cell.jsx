import React, { useContext } from "react";
import { cellInfoPropTypes, cellEventPropTypes } from "../propTypes";
import "./Cell.scss";
import { GridContext } from "../App";

function Cell (props) {
  const { pathfindingAnimation, shortestPathAnimation} =
    useContext(GridContext);
  const { cellInfo, eventHandlers } = props;
  const { row, col, start, end, wall } = cellInfo;
  const { onMouseDown, onMouseOver, onMouseUp } = eventHandlers;
  const inPathfinding = pathfindingAnimation.has(`cell-${row}-${col}`); //true/false, if in pathfinding animation
  const inShortestPath = shortestPathAnimation.has(`cell-${row}-${col}`); // if in shortest path animation
  const cellType = start ? "start" : end ? "end" : wall ? "wall" : "";
  const cellClass = `cell ${cellType} ${inPathfinding ? "pathfinding" : ""} ${ inShortestPath ? "shortestPath" : "" }`;
  const content = start ? "🛸" : end ? "🪐" : ""

  return (
    <div
      id={`cell-${row}-${col}`}
      className={cellClass} //will include cell, cellType and if in pathfinding/shortestPath animation
      onMouseDown={() => onMouseDown(row, col)}
      onMouseOver={() => onMouseOver(row, col)}
      onMouseUp={onMouseUp}
      style={{ fontSize: '1.2vw' }}
    >{content}</div>
  );
};
Cell = React.memo(Cell)

Cell.propTypes = {
  cellInfo: cellInfoPropTypes,
  eventHandlers: cellEventPropTypes,
};

export default Cell;
