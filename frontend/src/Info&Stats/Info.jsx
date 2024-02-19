import { useContext } from "react";
import { GridContext } from "../App.jsx";
import "./info.scss";


const Info = () => {
  const { pathfindingLength, shortestPathLength } = useContext(GridContext);

  const legendItems = [
    { label: "Start", icon: "🛸" },
    { label: "Target", icon: "🪐" },
    { label: "Wall", color: "#36454f" },
    { label: "Visited", color: "#d3d3d3" },
    { label: "Shortest-Path", color: "#ffd700" },
  ];

  return (
    <div className="info-container">
      <div className="legend">
      {legendItems.map((item, index) => {
          return (
            <div key={index} className="item">
              <span className="icon">
                {item.icon ? item.icon : <div className="box" style={{ backgroundColor: item.color }}></div>}
              </span>
              <span className="label">{item.label}</span>
            </div>
          );
        })}
      </div>
      <div className="stats">
        <span>Visited Cells: {pathfindingLength}</span>
        <span>Path Length: {shortestPathLength}</span>
      </div>
    </div>
  );
};

export default Info;
