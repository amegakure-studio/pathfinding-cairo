use core::nullable::{Nullable, FromNullableResult};
use pathfinding::algorithms::jps::{InfoKey, TilesInfo, TilesInfoTrait};
use pathfinding::data_structures::tile::Tile;
use pathfinding::numbers::i64::i64;
use pathfinding::numbers::integer_trait::IntegerTrait;
use pathfinding::utils::movement::get_movement_direction_coords;

#[derive(Copy, Drop, Serde)]
struct Map {
    height: u64,
    width: u64,
    tiles: Span<Tile>,
}

trait MapTrait {
    fn new(height: u64, width: u64, tiles: Span<Tile>) -> Map;
    fn is_walkable_at(self: @Map, x: i64, y: i64) -> bool;
    fn is_inside(self: @Map, x: i64, y: i64) -> bool;
    fn get_neighbours(self: @Map, ref tiles_info: TilesInfo, grid_id: u64) -> Span<u64>;
}

impl MapImpl of MapTrait {
    fn new(height: u64, width: u64, tiles: Span<Tile>) -> Map {
        Map { height, width, tiles }
    }

    fn is_walkable_at(self: @Map, x: i64, y: i64) -> bool {
        self.is_inside(x, y)
            && *(*self.tiles)
                .at(convert_position_to_idx(*self.width, x.mag, y.mag).try_into().unwrap())
                .is_walkable
    }

    fn is_inside(self: @Map, x: i64, y: i64) -> bool {
        if x.sign || y.sign {
            return false;
        }
        x.mag < (*self.width).into() && y.mag < (*self.height).into()
    }

    fn get_neighbours(self: @Map, ref tiles_info: TilesInfo, grid_id: u64) -> Span<u64> {
        let mut relevant_neighbours = array![];
        let parent_grid_id = tiles_info.read(grid_id, InfoKey::PARENT);

        if !parent_grid_id.is_null() {
            let (px, py) = convert_idx_to_position(*self.width, parent_grid_id.deref());
            let (x, y) = convert_idx_to_position(*self.width, grid_id);
            let (dx, dy) = get_movement_direction_coords(x, y, px, py);

            let ix = IntegerTrait::<i64>::new(x, false);
            let iy = IntegerTrait::<i64>::new(y, false);
            let one = IntegerTrait::<i64>::new(1, false);

            if dx.is_non_zero() && dy.is_non_zero() {
                if self.is_walkable_at(ix, iy + dy) {
                    relevant_neighbours
                        .append(convert_position_to_idx(*self.width, x, (iy + dy).mag));
                }
                if self.is_walkable_at(ix + dx, iy) {
                    relevant_neighbours
                        .append(convert_position_to_idx(*self.width, (ix + dx).mag, y));
                }
                if self.is_walkable_at(ix, iy + dy) || self.is_walkable_at(ix + dx, iy) {
                    relevant_neighbours
                        .append(convert_position_to_idx(*self.width, (ix + dx).mag, (iy + dy).mag));
                }
                if !self.is_walkable_at(ix - dx, iy) && self.is_walkable_at(ix, iy + dy) {
                    relevant_neighbours
                        .append(convert_position_to_idx(*self.width, (ix - dx).mag, (iy + dy).mag));
                }
                if !self.is_walkable_at(ix, iy - dy) && self.is_walkable_at(ix + dx, iy) {
                    relevant_neighbours
                        .append(convert_position_to_idx(*self.width, (ix + dx).mag, (iy - dy).mag));
                }
            } else {
                if dx.is_zero() {
                    if self.is_walkable_at(ix, iy + dy) {
                        relevant_neighbours
                            .append(convert_position_to_idx(*self.width, x, (iy + dy).mag));
                        if !self.is_walkable_at(ix + one, iy) {
                            relevant_neighbours
                                .append(convert_position_to_idx(*self.width, x + 1, (iy + dy).mag));
                        }
                        if x != 0 && !self.is_walkable_at(ix - one, iy) {
                            relevant_neighbours
                                .append(convert_position_to_idx(*self.width, x - 1, (iy + dy).mag));
                        }
                    }
                } else {
                    if self.is_walkable_at(ix + dx, iy) {
                        relevant_neighbours
                            .append(convert_position_to_idx(*self.width, (ix + dx).mag, y));
                        if !self.is_walkable_at(ix, iy + one) {
                            relevant_neighbours
                                .append(convert_position_to_idx(*self.width, (ix + dx).mag, y + 1));
                        }
                        if y != 0 && !self.is_walkable_at(ix, iy - one) {
                            relevant_neighbours
                                .append(convert_position_to_idx(*self.width, (ix + dx).mag, y - 1));
                        }
                    }
                }
            }
        } else {
            let (x, y) = convert_idx_to_position(*self.width, grid_id);
            return _get_neighbours(self, x, y);
        }
        relevant_neighbours.span()
    }
}

fn _get_neighbours(map: @Map, x: u64, y: u64) -> Span<u64> {
    let mut neighbours = array![];
    let mut s0 = false;
    let mut s1 = false;
    let mut s2 = false;
    let mut s3 = false;

    let iy = IntegerTrait::<i64>::new(y, false);
    let ix = IntegerTrait::<i64>::new(x, false);
    let one = IntegerTrait::<i64>::new(1, false);

    // ↑
    if map.is_walkable_at(ix, iy - one) {
        neighbours.append(convert_position_to_idx(*map.width, x, y - 1));
        s0 = true;
    }

    // →
    if map.is_walkable_at(ix + one, iy) {
        neighbours.append(convert_position_to_idx(*map.width, x + 1, y));
        s1 = true;
    }
    // ↓
    if map.is_walkable_at(ix, iy + one) {
        neighbours.append(convert_position_to_idx(*map.width, x, y + 1));
        s2 = true;
    }
    // ←
    if map.is_walkable_at(ix - one, iy) {
        neighbours.append(convert_position_to_idx(*map.width, x - 1, y));
        s3 = true;
    }

    let d0 = s3 || s0;
    let d1 = s0 || s1;
    let d2 = s1 || s2;
    let d3 = s2 || s3;

    // ↖
    if d0 && map.is_walkable_at(ix - one, iy - one) {
        neighbours.append(convert_position_to_idx(*map.width, x - 1, y - 1));
    }
    // ↗
    if d1 && map.is_walkable_at(ix + one, iy - one) {
        neighbours.append(convert_position_to_idx(*map.width, x + 1, y - 1));
    }
    // ↘
    if d2 && map.is_walkable_at(ix + one, iy + one) {
        neighbours.append(convert_position_to_idx(*map.width, x + 1, y + 1));
    }
    // ↙
    if d3 && map.is_walkable_at(ix - one, iy + one) {
        neighbours.append(convert_position_to_idx(*map.width, x - 1, y + 1));
    }
    neighbours.span()
}

fn convert_position_to_idx(width: u64, x: u64, y: u64) -> u64 {
    (y * width) + x
}

fn convert_idx_to_position(width: u64, idx: u64) -> (u64, u64) {
    let (q, r) = integer::u64_safe_divmod(idx, integer::u64_as_non_zero(width));
    (r, q)
}
