import { getNeighbors } from "./algoFunctions.jsx";

const bds = (grid, start, end) => {
  const path = [start, end];
  const visitedStart = new Set();
  const visitedEnd = new Set();
  const frontierStart = [start];
  const frontierEnd = [end];

  visitedStart.add(start);
  visitedEnd.add(end);

  while (frontierStart.length && frontierEnd.length) {
    const currStart = frontierStart.shift();
    const neighborsStart = getNeighbors(grid, currStart);
    for (const neighbor of neighborsStart) {
      if (visitedEnd.has(neighbor)) {
        const finalPath = reconstructPath(
          neighbor,
          currStart,
          "fromStart",
          start,
          end
        );
        return { path, finalPath };
      }
      if (!visitedStart.has(neighbor) && !neighbor.wall) {
        neighbor.prevCell = currStart;
        visitedStart.add(neighbor);
        frontierStart.push(neighbor);
        path.push(neighbor);
      }
    }
    const currEnd = frontierEnd.shift();
    const neighborsEnd = getNeighbors(grid, currEnd);
    for (const neighbor of neighborsEnd) {
      if (visitedStart.has(neighbor)) {
        const finalPath = reconstructPath(
          neighbor,
          currEnd,
          "fromEnd",
          start,
          end
        );
        return { path, finalPath };
      }
      if (!visitedEnd.has(neighbor) && !neighbor.wall) {
        neighbor.prevCell = currEnd;
        visitedEnd.add(neighbor);
        frontierEnd.push(neighbor);
        path.push(neighbor);
      }
    }
  }
  return {path}
};
const reconstructPath = (meetingCell, lastCell, direction, start, end) => {
  const pathFromStartToMeeting = [];
  const pathFromMeetingToEnd = [];

  let curr = meetingCell;
  if (direction === "fromStart") {
    while (curr && !curr.end) {
      pathFromMeetingToEnd.push(curr);
      curr = curr.prevCell;
    }
    pathFromMeetingToEnd.push(end);
    curr = lastCell;
    while (curr && !curr.start) {
      pathFromStartToMeeting.unshift(curr);
      curr = curr.prevCell;
    }
    pathFromStartToMeeting.unshift(start);
  } else {
    while (curr && !curr.start) {
      pathFromStartToMeeting.unshift(curr);
      curr = curr.prevCell;
    }
    pathFromStartToMeeting.unshift(start);
    curr = lastCell;
    while (curr && !curr.end) {
      pathFromMeetingToEnd.push(curr);
      curr = curr.prevCell;
    }
    pathFromMeetingToEnd.push(end);
  }
  return pathFromStartToMeeting.concat(pathFromMeetingToEnd);
};

export default bds;
