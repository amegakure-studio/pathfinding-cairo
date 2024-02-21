use core::array::SpanTrait;
use core::dict::Felt252DictTrait;
use core::nullable::{Nullable, NullableTrait, match_nullable, FromNullableResult};
use core::option::OptionTrait;
use pathfinding::data_structures::{
    map::{Map, MapTrait, convert_position_to_idx, convert_idx_to_position},
    min_heap::{MinHeap, MinHeapTrait},
};
use pathfinding::numbers::i64::i64;
use pathfinding::numbers::integer_trait::IntegerTrait;
use pathfinding::utils::constants::{
    PARENT_KEY, STATUS_KEY, DISTANCE_KEY, DISTANCE_TO_GOAL_KEY, ESTIMATED_TOTAL_PATH_DISTANCE_KEY
};
use pathfinding::utils::heuristics::manhattan;
use pathfinding::utils::movement::get_movement_direction_coords;

const OPENED: u64 = 1;
const CLOSED: u64 = 2;

trait JPSTrait {
    fn find_path(map: Map, start: (u64, u64), goal: (u64, u64)) -> Span<(u64, u64)>;
}

#[derive(Destruct, Default)]
struct TilesInfo {
    status: Felt252Dict<Nullable<u64>>,
    parent: Felt252Dict<Nullable<u64>>,
    distance_to_goal: Felt252Dict<Nullable<u64>>,
    cumulative_path_distance: Felt252Dict<Nullable<u64>>,
    total_cost: Felt252Dict<Nullable<u64>>,
}

#[derive(Serde, Copy, Drop, PartialEq)]
enum InfoKey {
    PARENT,
    STATUS,
    DISTANCE_TO_GOAL,
    CUMULATIVE_PATH_DISTANCE,
    ESTIMATIVE_TOTAL_COST
}

trait TilesInfoTrait {
    fn new() -> TilesInfo;
    fn write(ref self: TilesInfo, grid_id: u64, key: InfoKey, value: u64);
    fn read(ref self: TilesInfo, grid_id: u64, key: InfoKey) -> Nullable<u64>;
    fn print(ref self: TilesInfo, grid_id: u64);
}

impl TilesInfoImpl of TilesInfoTrait {
    fn new() -> TilesInfo {
        TilesInfo {
            parent: Default::default(),
            status: Default::default(),
            distance_to_goal: Default::default(),
            cumulative_path_distance: Default::default(),
            total_cost: Default::default(),
        }
    }

    fn write(ref self: TilesInfo, grid_id: u64, key: InfoKey, value: u64) {
        match key {
            InfoKey::PARENT => { self.parent.insert(grid_id.into(), NullableTrait::new(value)); },
            InfoKey::STATUS => { self.status.insert(grid_id.into(), NullableTrait::new(value)); },
            InfoKey::DISTANCE_TO_GOAL => {
                self.distance_to_goal.insert(grid_id.into(), NullableTrait::new(value));
            },
            InfoKey::CUMULATIVE_PATH_DISTANCE => {
                self.cumulative_path_distance.insert(grid_id.into(), NullableTrait::new(value));
            },
            InfoKey::ESTIMATIVE_TOTAL_COST => {
                self.total_cost.insert(grid_id.into(), NullableTrait::new(value));
            },
        }
    }

    fn read(ref self: TilesInfo, grid_id: u64, key: InfoKey) -> Nullable<u64> {
        match key {
            InfoKey::PARENT => self.parent.get(grid_id.into()),
            InfoKey::STATUS => self.status.get(grid_id.into()),
            InfoKey::DISTANCE_TO_GOAL => self.distance_to_goal.get(grid_id.into()),
            InfoKey::CUMULATIVE_PATH_DISTANCE => self.cumulative_path_distance.get(grid_id.into()),
            InfoKey::ESTIMATIVE_TOTAL_COST => self.total_cost.get(grid_id.into()),
        }
    }

    fn print(ref self: TilesInfo, grid_id: u64) {
        let parent = self.read(grid_id, InfoKey::PARENT);
        let status = self.read(grid_id, InfoKey::STATUS);
        let h = self.read(grid_id, InfoKey::DISTANCE_TO_GOAL);
        let g = self.read(grid_id, InfoKey::CUMULATIVE_PATH_DISTANCE);
        let f = self.read(grid_id, InfoKey::ESTIMATIVE_TOTAL_COST);
        print!("TilesInfo {{");
        if !parent.is_null() {
            print!(" parent: {},", parent.deref());
        }
        if !status.is_null() {
            print!(" status: {},", status.deref());
        }
        if !h.is_null() {
            print!(" h: {},", h.deref());
        }
        if !g.is_null() {
            print!(" g: {},", g.deref());
        }
        if !f.is_null() {
            print!(" f: {},", f.deref());
        }
        println!(" }}");
    }
}

impl JPSDiagOneObstacle of JPSTrait {
    fn find_path(map: Map, start: (u64, u64), goal: (u64, u64)) -> Span<(u64, u64)> {
        let (sx, sy) = start;
        let (gx, gy) = goal;
        let mut tiles_info = TilesInfoTrait::new();
        let mut open_list: MinHeap<u64> = MinHeapTrait::new();

        let goal_id = convert_position_to_idx(map.width, gx, gy);
        let start_id = convert_position_to_idx(map.width, sx, sy);
        tiles_info.write(start_id, InfoKey::STATUS, OPENED);
        tiles_info.write(start_id, InfoKey::ESTIMATIVE_TOTAL_COST, 0);
        tiles_info.write(start_id, InfoKey::CUMULATIVE_PATH_DISTANCE, 0);
        open_list.add(start_id, 0);

        let mut goal_flag = false;
        let mut node_id_flag = 0;
        loop {
            if open_list.len == 0 || goal_flag {
                break;
            }
            let (node_id, node_value) = open_list.poll().unwrap();
            let (node_x, node_y) = convert_idx_to_position(map.width, node_id);
            tiles_info.write(node_id, InfoKey::STATUS, CLOSED);

            if goal_id == node_id {
                goal_flag = true;
                node_id_flag = node_id;
                break;
            }
            identify_successors(
                map, ref tiles_info, ref open_list, node_id, node_x, node_y, gx, gy
            );
        };

        if goal_flag {
            let (node_x, node_y) = convert_idx_to_position(map.width, node_id_flag);
            return build_reverse_path_from(map, ref tiles_info, node_id_flag);
        } else {
            array![].span()
        }
    }
}

fn identify_successors(
    map: Map,
    ref tiles_info: TilesInfo,
    ref open_list: MinHeap<u64>,
    node_id: u64,
    node_x: u64,
    node_y: u64,
    goal_x: u64,
    goal_y: u64
) {
    let neighbours = map.get_neighbours(ref tiles_info, node_id);
    print_span(neighbours);
    let mut i = 0;
    loop {
        if neighbours.len() == i {
            break;
        }
        let (nx, ny) = convert_idx_to_position(map.width, *neighbours.at(i));
        let opt_jump_point = jump(map, nx, ny, node_x, node_y, goal_x, goal_y);

        if opt_jump_point.is_some() {
            let jump_point = opt_jump_point.unwrap();
            let (jx, jy) = convert_idx_to_position(map.width, jump_point);
            let jp_status = tiles_info.read(jump_point, InfoKey::STATUS);
            let jp_status_is_null = match match_nullable(jp_status) {
                FromNullableResult::Null => true,
                FromNullableResult::NotNull(val) => false,
            };
            if !jp_status_is_null && jp_status.deref() == CLOSED {
                i += 1;
                continue;
            }

            let jd = manhattan(
                (IntegerTrait::<i64>::new(jx, false) - IntegerTrait::<i64>::new(node_x, false)).mag,
                (IntegerTrait::<i64>::new(jy, false) - IntegerTrait::<i64>::new(node_y, false)).mag
            );
            let ng = tiles_info.read(node_id, InfoKey::CUMULATIVE_PATH_DISTANCE).deref() + jd;

            let jp_g = tiles_info.read(jump_point, InfoKey::CUMULATIVE_PATH_DISTANCE);
            let jp_g_is_null = match match_nullable(jp_g) {
                FromNullableResult::Null => true,
                FromNullableResult::NotNull(val) => false,
            };
            if jp_status_is_null
                || (!jp_status_is_null && jp_status.deref() != OPENED)
                || jp_g_is_null
                || (!jp_g_is_null && ng < jp_g.deref()) {
                tiles_info.write(jump_point, InfoKey::CUMULATIVE_PATH_DISTANCE, ng);

                let jp_h = tiles_info.read(jump_point, InfoKey::DISTANCE_TO_GOAL);
                let jp_h_is_null = match match_nullable(jp_h) {
                    FromNullableResult::Null => true,
                    FromNullableResult::NotNull(val) => false,
                };
                if jp_h_is_null {
                    let jp_h_estimated = manhattan(
                        (IntegerTrait::<i64>::new(jx, false)
                            - IntegerTrait::<i64>::new(goal_x, false))
                            .mag,
                        (IntegerTrait::<i64>::new(jy, false)
                            - IntegerTrait::<i64>::new(goal_y, false))
                            .mag
                    );
                    tiles_info.write(jump_point, InfoKey::DISTANCE_TO_GOAL, jp_h_estimated);
                }
                let jp_g = tiles_info.read(jump_point, InfoKey::CUMULATIVE_PATH_DISTANCE).deref();
                let jp_f = jp_g + tiles_info.read(jump_point, InfoKey::DISTANCE_TO_GOAL).deref();

                tiles_info.write(jump_point, InfoKey::ESTIMATIVE_TOTAL_COST, jp_f);
                tiles_info.write(jump_point, InfoKey::PARENT, node_id);

                if jp_status_is_null || (!jp_status_is_null && jp_status.deref() != OPENED) {
                    open_list.add(jump_point, jp_f);
                    tiles_info.write(jump_point, InfoKey::STATUS, OPENED);
                }
            }
        }
        i += 1;
    }
}

fn jump(
    map: Map, x: u64, y: u64, parent_x: u64, parent_y: u64, goal_x: u64, goal_y: u64
) -> Option<u64> {
    let iy = IntegerTrait::<i64>::new(y, false);
    let ix = IntegerTrait::<i64>::new(x, false);
    let one = IntegerTrait::<i64>::new(1, false);
    let is_walkable = map.is_walkable_at(ix, iy);

    if !is_walkable {
        return Option::None(());
    }

    if x == goal_x && y == goal_y {
        return Option::Some(convert_position_to_idx(map.width, x, y));
    }
    let dx = ix - IntegerTrait::<i64>::new(parent_x, false);
    let dy = iy - IntegerTrait::<i64>::new(parent_y, false);
    if dx.is_non_zero() && dy.is_non_zero() {
        let p1 = map.is_walkable_at(ix - dx, iy + dy);
        let p2 = map.is_walkable_at(ix - dx, iy);
        let p3 = map.is_walkable_at(ix + dx, iy - dy);
        let p4 = map.is_walkable_at(ix, iy - dy);

        if (p1 && !p2) || (p3 && !p4) {
            return Option::Some(convert_position_to_idx(map.width, x, y));
        }

        if (jump(map, (ix + dx).mag, y, x, y, goal_x, goal_y).is_some()
            || jump(map, x, (iy + dy).mag, x, y, goal_x, goal_y).is_some()) {
            return Option::Some(convert_position_to_idx(map.width, x, y));
        }
    } else {
        if dx.is_non_zero() {
            let p1 = map.is_walkable_at(ix + dx, iy + one);
            let p2 = map.is_walkable_at(ix, iy + one);
            let p3 = map.is_walkable_at(ix + dx, iy - one);
            let p4 = map.is_walkable_at(ix, iy - one);

            if (p1 && !p2) || (p3 && !p4) {
                return Option::Some(convert_position_to_idx(map.width, x, y));
            }
        } else {
            let p1 = map.is_walkable_at(ix + one, iy + dy);
            let p2 = map.is_walkable_at(ix + one, iy);
            let p3 = map.is_walkable_at(ix - one, iy + dy);
            let p4 = map.is_walkable_at(ix - one, iy);

            if (p1 && !p2) || (p3 && !p4) {
                return Option::Some(convert_position_to_idx(map.width, x, y));
            }
        }
    }
    if map.is_walkable_at(ix + dx, iy) || map.is_walkable_at(ix, iy + dy) {
        return jump(map, (ix + dx).mag, (iy + dy).mag, x, y, goal_x, goal_y);
    } else {
        return Option::None(());
    }
}

fn build_reverse_path_from(map: Map, ref tiles_info: TilesInfo, grid_id: u64) -> Span<(u64, u64)> {
    let (x, y) = convert_idx_to_position(map.width, grid_id);
    let mut res = array![grid_id];

    let mut parent_id = grid_id;
    loop {
        let p = tiles_info.read(parent_id, InfoKey::PARENT);
        let p_is_null = match match_nullable(p) {
            FromNullableResult::Null => true,
            FromNullableResult::NotNull(val) => false,
        };
        if p_is_null {
            break;
        }
        res.append(p.deref());
        parent_id = p.deref();
    };

    let mut i = res.len() - 1;
    let mut reverse = array![];
    loop {
        reverse.append(convert_idx_to_position(map.width, *res.at(i)));
        if i == 0 {
            break;
        }
        i -= 1;
    };
    reverse.span()
}

fn print_span(span: Span<u64>) {// let mut i = 0;s
}
