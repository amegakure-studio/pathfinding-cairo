use core::array::SpanTrait;
use core::dict::Felt252DictTrait;
use core::nullable::{Nullable, NullableTrait, match_nullable, FromNullableResult};
use core::option::OptionTrait;
use pathfinding::algorithms::jps::{InfoKey, TilesInfo, TilesInfoTrait};
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

trait AStarTrait {
    fn find_path(map: Map, start: (u64, u64), goal: (u64, u64)) -> Span<(u64, u64)>;
}

impl AStarDiagOneObstacle of AStarTrait {
    fn find_path(map: Map, start: (u64, u64), goal: (u64, u64)) -> Span<(u64, u64)> {
        let (sx, sy) = start;
        let (gx, gy) = goal;
        let mut tiles_info = TilesInfoTrait::new();
        let mut open_list: MinHeap<u64> = MinHeapTrait::new();

        let goal_id = convert_position_to_idx(map.width, gx, gy);
        let start_id = convert_position_to_idx(map.width, sx, sy);
        tiles_info.write(start_id, InfoKey::STATUS, OPENED);
        tiles_info.write(start_id, InfoKey::ESTIMATIVE_TOTAL_COST, 0);
        open_list.add(start_id, 0);

        let mut goal_flag = false;
        let mut node_id_flag = 0;

        loop {
            if open_list.len == 0 || goal_flag {
                break;
            }

            let (node_id, node_value) = open_list.poll().unwrap(); // nodo con menor costo de F
            let (node_x, node_y) = convert_idx_to_position(map.width, node_id);
            tiles_info.write(node_id, InfoKey::STATUS, CLOSED);

            if goal_id == node_id {
                goal_flag = true;
                node_id_flag = node_id;
                break;
            }

            let neighbours = map.get_neighbours(ref tiles_info, node_id);
            let mut i = 0;
            loop {
                if neighbours.len() == i {
                    break;
                }
                let n_id = *neighbours.at(i);
                let (nx, ny) = convert_idx_to_position(map.width, n_id);
                let n_status = tiles_info.read(n_id, InfoKey::STATUS);
                let n_status_is_null = match match_nullable(n_status) {
                    FromNullableResult::Null => true,
                    FromNullableResult::NotNull(val) => false,
                };

                let inx = IntegerTrait::<i64>::new(nx, false);
                let iny = IntegerTrait::<i64>::new(ny, false);
                if (!n_status_is_null && n_status.deref() == CLOSED)
                    || !map.is_walkable_at(inx, iny) {
                    i += 1;
                    continue;
                }

                let nh = manhattan(
                    (IntegerTrait::<i64>::new(nx, false) - IntegerTrait::<i64>::new(sx, false)).mag,
                    (IntegerTrait::<i64>::new(ny, false) - IntegerTrait::<i64>::new(sy, false)).mag
                );
                let ng = manhattan(
                    (IntegerTrait::<i64>::new(nx, false) - IntegerTrait::<i64>::new(gx, false)).mag,
                    (IntegerTrait::<i64>::new(ny, false) - IntegerTrait::<i64>::new(gy, false)).mag
                );
                let new_nf = nh + ng;
                let nf = tiles_info.read(n_id, InfoKey::ESTIMATIVE_TOTAL_COST);
                let nf_int = match match_nullable(nf) {
                    FromNullableResult::Null => 0,
                    FromNullableResult::NotNull(val) => nf.deref(),
                };
                if new_nf < nf_int || (n_status_is_null || n_status.deref() == CLOSED) {
                    
                    tiles_info.write(n_id, InfoKey::ESTIMATIVE_TOTAL_COST, new_nf);
                    tiles_info.write(n_id, InfoKey::PARENT, node_id);

                    if n_status_is_null || n_status.deref() == CLOSED {

                        open_list.add(n_id, new_nf);
                        tiles_info.write(n_id, InfoKey::STATUS, OPENED);
                    }
                }
                i += 1;
            }
        };

        if goal_flag {
            let (node_x, node_y) = convert_idx_to_position(map.width, node_id_flag);
            return build_reverse_path_from(map, ref tiles_info, node_id_flag);
        } else {
            array![].span()
        }
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

fn print_span(span: Span<u64>) { // let mut i = 0;s
}
