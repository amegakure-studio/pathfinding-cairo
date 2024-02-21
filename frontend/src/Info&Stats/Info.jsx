import { useContext } from "react";
import { GridContext } from "../App.jsx";
import "./info.scss";


const Info = () => {
  const { pathfindingLength, shortestPathLength } = useContext(GridContext);

  const legendItems = [
    { label: "Start", icon: "S", color: "#00ccf2" },
    { label: "Goal", icon: "G", color: "#ff5d7d" },
    { label: "Wall", color: "#545454" },
    { label: "Path", color: "#6577ff" },
  ];

  return (
    <div className="info-container">
      <div className="legend">
      {legendItems.map((item, index) => {
          return (
            <div key={index} className="item">
              <span className="icon">
                {<div className="box" style={{ paddingLeft: '0.7vw', fontSize: '1.5vw' ,backgroundColor: item.color }}>{item.icon}</div>}
              </span>
              <span className="label">{item.label}</span>
            </div>
          );
        })}
      </div>
      <div className="stats">
        {/* <span>Path Length: {pathfindingLength ? (pathfindingLength + 1) : "-"}</span> */}
      </div>
    </div>
  );
};

export default Info;
