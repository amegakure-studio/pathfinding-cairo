use core::array::SpanTrait;
use pathfinding::algorithms::jps::{TilesInfo, TilesInfoTrait, InfoKey};
use pathfinding::data_structures::map::{Map, MapTrait, convert_position_to_idx};
use pathfinding::data_structures::tile::{Tile, TileTrait};

// A: actual node, no parent.
// O O O
// O A O
// O O O
// #[test]
// fn test_get_neighbours_center_no_obstacles() {
//     let map_tiles = array!['O','O','O',
//                            'O','O','O',
//                            'O','O','O'];
//     let map = build_map(3, 3, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let mut expected = array![0, 1, 2,
//                               3,    5,
//                               6, 7, 8].span();

//     let mut result = map.get_neighbours(ref tiles_info, 4);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, no parent.
// // A O O
// // O O O
// // O O O
// #[test]
// fn test_get_neighbours_up_left_corner_no_obstacles() {
//     let map_tiles = array!['O','O','O',
//                            'O','O','O',
//                            'O','O','O'];
//     let map = build_map(3, 3, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let mut expected = array![   1,
//                               3, 4,
//                               ].span();

//     let mut result = map.get_neighbours(ref tiles_info, 0);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, no parent.
// // O A O
// // O O O
// // O O O
// #[test]
// fn test_get_neighbours_middle_up_no_obstacles() {
//     let map_tiles = array!['O','O','O',
//                            'O','O','O',
//                            'O','O','O'];
//     let map = build_map(3, 3, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let mut expected = array![0,    2,
//                               3, 4, 5,
//                               ].span();

//     let mut result = map.get_neighbours(ref tiles_info, 1);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, no parent.
// // O O A
// // O O O
// // O O O
// #[test]
// fn test_get_neighbours_up_right_corner_no_obstacles() {
//     let map_tiles = array!['O','O','O',
//                            'O','O','O',
//                            'O','O','O'];
//     let map = build_map(3, 3, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let mut expected = array![   1, 
//                                  4, 5,
//                               ].span();

//     let mut result = map.get_neighbours(ref tiles_info, 2);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, no parent.
// // O O O
// // O O O
// // O O A
// #[test]
// fn test_get_neighbours_down_right_corner_no_obstacles() {
//     let map_tiles = array!['O','O','O',
//                            'O','O','O',
//                            'O','O','O'];
//     let map = build_map(3, 3, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let mut expected = array![
//                                 4, 5,
//                                 7,  ].span();

//     let mut result = map.get_neighbours(ref tiles_info, 8);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, no parent.
// // O O O
// // O O O
// // O A O
// #[test]
// fn test_get_neighbours_middle_down_no_obstacles() {
//     let map_tiles = array!['O','O','O',
//                            'O','O','O',
//                            'O','O','O'];
//     let map = build_map(3, 3, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let mut expected = array![
//                               3, 4, 5,
//                               6,    8].span();

//     let mut result = map.get_neighbours(ref tiles_info, 7);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, no parent.
// // O O O
// // O O O
// // A O O
// #[test]
// fn test_get_neighbours_down_left_corner_no_obstacles() {
//     let map_tiles = array!['O','O','O',
//                            'O','O','O',
//                            'O','O','O'];
//     let map = build_map(3, 3, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let mut expected = array![
//                               3, 4,
//                                  7,].span();

//     let mut result = map.get_neighbours(ref tiles_info, 6);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, no parent.
// // X A X
// // O X O 
// // O O O
// #[test]
// fn test_get_neighbours_middle_blocked_by_obstacles() {
//     let map_tiles = array!['X','O','X',
//                            'O','X','O',
//                            'O','O','O'];
//     let map = build_map(3, 3, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let mut expected = array![].span();

//     let mut result = map.get_neighbours(ref tiles_info, 1);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, no parent.
// // O A X
// // O X O 
// // O O O
// #[test]
// fn test_get_neighbours_middle_with_one_way() {
//     let map_tiles = array!['O','O','X',
//                            'O','X','O',
//                            'O','O','O'];
//     let map = build_map(3, 3, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let mut expected = array![0, 
//                               3,    
//                                     ].span();

//     let mut result = map.get_neighbours(ref tiles_info, 1);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, P: parent
// // X O X O
// // P A O O 
// // O O O O 
// // O O O O
// // dx = 1, dy = 0
// #[test]
// fn test_get_neighbours_with_parent_horizontal_right_direction() {
//     let map_tiles = array!['X','O','X','O',
//                            'O','O','O','O',
//                            'O','O','O','O',
//                            'O','O','O','O',];
//     let map = build_map(4, 4, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let parent_id = convert_position_to_idx(map.width, 0, 1);
//     let grid_id = 5;
//     tiles_info.write(grid_id, InfoKey::PARENT, parent_id);

//     let mut expected = array![6].span();

//     let mut result = map.get_neighbours(ref tiles_info, grid_id);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, P: parent
// // X O X O
// // O A P O 
// // O O O O 
// // O O O O
// // dx = -1, dy = 0
// #[test]
// fn test_get_neighbours_with_parent_horizontal_left_direction() {
//     let map_tiles = array!['X','O','X','O',
//                            'O','O','O','O',
//                            'O','O','O','O',
//                            'O','O','O','O',];
//     let map = build_map(4, 4, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let parent_id = convert_position_to_idx(map.width, 2, 1);
//     let grid_id = 5;
//     tiles_info.write(grid_id, InfoKey::PARENT, parent_id);

//     let mut expected = array![4].span();

//     let mut result = map.get_neighbours(ref tiles_info, grid_id);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, P: parent
// // X O X O
// // O A O O 
// // O P O O 
// // O O O O
// // dx = 0, dy = -1
// #[test]
// fn test_get_neighbours_with_parent_vertical_up_direction() {
//     let map_tiles = array!['X','O','X','O',
//                            'O','O','O','O',
//                            'O','O','O','O',
//                            'O','O','O','O',];
//     let map = build_map(4, 4, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let parent_id = convert_position_to_idx(map.width, 1, 2);
//     let grid_id = 5;
//     tiles_info.write(grid_id, InfoKey::PARENT, parent_id);

//     let mut expected = array![1].span();

//     let mut result = map.get_neighbours(ref tiles_info, grid_id);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// // A: actual node, P: parent
// // X O X O
// // O P O O 
// // O X A O 
// // O O O O
// // dx = 1, dy = 1
// #[test]
// fn test_get_neighbours_with_parent_diagonal_right_down_direction() {
//     let map_tiles = array!['X','O','X','O',
//                            'O','O','O','O',
//                            'O','X','O','O',
//                            'O','O','O','O',];
//     let map = build_map(4, 4, map_tiles);
//     let mut tiles_info = TilesInfoTrait::new();

//     let parent_id = convert_position_to_idx(map.width, 1, 1);
//     let grid_id = 10;
//     tiles_info.write(grid_id, InfoKey::PARENT, parent_id);

//     let mut expected = array![11, 13, 14, 15].span();

//     let mut result = map.get_neighbours(ref tiles_info, grid_id);
//     assert(result.len() == expected.len(), 'wrong neighbours len');
//     assert(contains_all(ref result, ref expected), 'wrong values');
// }

// A: actual node, P: parent
// X O X O
// O P O O 
// A X O O 
// O O O O
// dx = -1, dy = 1
#[test]
fn test_get_neighbours_with_parent_diagonal_left_down_direction_in_border() {
    let map_tiles = array![
        'X', 'O', 'X', 'O', 'O', 'O', 'O', 'O', 'O', 'X', 'O', 'O', 'O', 'O', 'O', 'O',
    ];
    let map = build_map(4, 4, map_tiles);
    let mut tiles_info = TilesInfoTrait::new();

    let parent_id = convert_position_to_idx(map.width, 1, 1);
    let grid_id = 8;
    tiles_info.write(grid_id, InfoKey::PARENT, parent_id);

    let mut expected = array![12, 13].span();

    let mut result = map.get_neighbours(ref tiles_info, grid_id);

    print(ref result);
    print(ref expected);

    assert(result.len() == expected.len(), 'wrong neighbours len');
    assert(contains_all(ref result, ref expected), 'wrong values');
}

fn contains_all(ref s1: Span<u64>, ref s2: Span<u64>) -> bool {
    if s1.len() != s2.len() {
        return false;
    }
    let mut i = 0;
    let mut flag = true;
    loop {
        if s1.len() == i {
            break;
        }
        let obj = *(s1.at(i));
        flag = flag && contains(s2, obj);
        i += 1;
    };
    flag
}

fn contains(s: Span<u64>, v: u64) -> bool {
    let mut i = 0;
    let mut flag = false;
    loop {
        if s.len() == i {
            break;
        }
        let elem = *s.at(i);
        if elem == v {
            flag = true;
            break;
        }
        i += 1;
    };
    flag
}

fn build_map(width: u64, height: u64, tiles: Array<felt252>) -> Map {
    let mut map_tiles = array![];
    let mut x = 0;
    let mut y = 0;

    loop {
        let id = (y * width + x).into();
        if id == tiles.len() {
            break;
        }
        if x == width {
            y += 1;
            x = 0;
        }
        if *tiles.at(id) == 'O' {
            map_tiles.append(TileTrait::new(id.into(), x.into(), y.into(), true));
        } else {
            map_tiles.append(TileTrait::new(id.into(), x.into(), y.into(), false));
        }
        x += 1;
    };
    MapTrait::new(width, height, map_tiles.span())
}
