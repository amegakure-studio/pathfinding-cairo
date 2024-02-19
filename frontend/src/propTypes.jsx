import PropTypes from "prop-types";

export const cellInfoPropTypes = PropTypes.shape({
  row: PropTypes.number.isRequired,
  col: PropTypes.number.isRequired,
  start: PropTypes.bool.isRequired,
  end: PropTypes.bool.isRequired,
  wall: PropTypes.bool.isRequired,
});

export const cellEventPropTypes = PropTypes.shape({
    onMouseDown: PropTypes.func.isRequired,
    onMouseOver: PropTypes.func.isRequired,
    onMouseUp: PropTypes.func.isRequired
});
