use pathfinding::algorithms::jps::{jump, JPSTrait};
use pathfinding::algorithms::a_star::{AStarTrait};
use pathfinding::data_structures::map::{
    Map, MapTrait, convert_position_to_idx, convert_idx_to_position
};
use pathfinding::data_structures::tile::{Tile, TileTrait};
use pathfinding::pathfinder::{IPathfinder, IPathfinderDispatcher, IPathfinderDispatcherTrait};
use snforge_std::{declare, ContractClassTrait};
use starknet::ContractAddress;

fn deploy_contract(name: felt252) -> ContractAddress {
    let contract = declare(name);
    contract.deploy(@ArrayTrait::new()).unwrap()
}

const UNRECHEABLE: u64 = 999999;
const X: felt252 = 'X';
const O: felt252 = 'O';

// Giving parent (P) and actual (G) 
// When actual is the goal and call jump()
// Then method will return actual node as jump point
// Map:
// O O O 
// O P G 
// O O O 
// #[test]
// fn test_jump_actual_node_is_the_goal() {
//     let map_tiles = array![O,O,O,
//                            O,O,O,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 2;
//     let y = 1;
//     let parent_x = 1;
//     let parent_y = 1;
//     let goal_x = 2;
//     let goal_y = 1;

//     let result = jump(map, x, y, parent_x, parent_y, goal_x, goal_y);
//     assert(result.unwrap() == 5, 'jump point should be 5');
// }

// // Giving parent (P) and actual (A) has an obstacle in (y + 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O O O
// // P A O
// // O X O 
// #[test]
// fn test_jump_with_horizontal_right_obstacle_in_y_plus_1() {
//     let map_tiles = array![O,O,O,
//                            O,O,O,
//                            O,X,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 0;
//     let parent_y = 1;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 5');
// }

// // Giving parent (P) and actual (A) has an obstacle in (y - 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O X O 
// // P A O 
// // O O O 
// #[test]
// fn test_jump_with_horizontal_right_obstacle_in_y_minus_1() {
//     let map_tiles = array![O,X,O,
//                            O,O,O,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 0;
//     let parent_y = 1;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

// // Giving parent (P) and actual (A) has an obstacle in (y - 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O X O
// // O A P
// // O O O
// #[test]
// fn test_jump_with_horizontal_left_obstacle_in_y_minus_1() {
//     let map_tiles = array![O,X,O,
//                            O,O,O,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 2;
//     let parent_y = 1;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

// // Giving parent (P) and actual (A) has an obstacle in (y + 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O O O
// // O A P
// // O X O
// #[test]
// fn test_jump_with_horizontal_left_obstacle_in_y_plus_1() {
//     let map_tiles = array![O,O,O,
//                            O,O,O,
//                            O,X,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 2;
//     let parent_y = 1;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

// // Giving parent (P) and actual (A) has an obstacle in (x + 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O P O 
// // O A X 
// // O O O 
// #[test]
// fn test_jump_with_vertical_down_obstacle_in_x_plus_1() {
//     let map_tiles = array![O,O,O,
//                            O,O,X,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 1;
//     let parent_y = 0;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

// // Giving parent (P) and actual (A) has an obstacle in (x - 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O P O 
// // X A O 
// // O O O 
// #[test]
// fn test_jump_with_vertical_down_obstacle_in_x_minus_1() {
//     let map_tiles = array![O,O,O,
//                            X,O,O,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 1;
//     let parent_y = 0;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

// // Giving parent (P) and actual (A) has an obstacle in (x - 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O O O 
// // O A X 
// // O P O 
// #[test]
// fn test_jump_with_vertical_up_obstacle_in_x_plus_1() {
//     let map_tiles = array![O,O,O,
//                            O,O,X,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 1;
//     let parent_y = 2;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

// // Giving parent (P) and actual (A) has an obstacle in (x - 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O O O 
// // X A O 
// // O P O 
// #[test]
// fn test_jump_with_vertical_up_obstacle_in_x_minus_1() {
//     let map_tiles = array![O,O,O,
//                            X,O,O,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 1;
//     let parent_y = 2;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

// // Giving parent (P) and actual (A) has an obstacle in (x - 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O O O 
// // O X A 
// // O P O 
// #[test]
// fn test_jump_with_diagonal_up_right_obstacle_in_x_minus_1() {
//     let map_tiles = array![O,O,O,
//                            O,X,O,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 2;
//     let y = 1;
//     let parent_x = 1;
//     let parent_y = 2;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 5, 'jump point should be 5');
// }

// // Giving parent (P) and actual (A) has an obstacle in (y + 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O O O 
// // O A O  
// // P X O 
// #[test]
// fn test_jump_with_diagonal_up_right_obstacle_in_y_plus_1() {
//     let map_tiles = array![O,O,O,
//                            O,O,O,
//                            O,X,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 0;
//     let parent_y = 2;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

// // Giving parent (P) and actual (A) has an obstacle in (x - 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O P O
// // O X A 
// // O O O 
// #[test]
// fn test_jump_with_diagonal_down_right_obstacle_in_x_minus_1() {
//     let map_tiles = array![O,O,O,
//                            O,X,O,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 2;
//     let y = 1;
//     let parent_x = 1;
//     let parent_y = 0;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 5, 'jump point should be 5');
// }

// // Giving parent (P) and actual (A) has an obstacle in (y - 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O O O
// // P X O 
// // O A O 
// #[test]
// fn test_jump_with_diagonal_down_right_obstacle_in_y_minus_1() {
//     let map_tiles = array![O,O,O,
//                            O,X,O,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 2;
//     let parent_x = 0;
//     let parent_y = 1;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 7, 'jump point should be 7');
// }

// // Giving parent (P) and actual (A) has an obstacle in (x - 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O P O
// // O X A 
// // O O O 
// #[test]
// fn test_jump_with_diagonal_up_left_obstacle_in_x_plus_1() {
//     let map_tiles = array![O,O,O,
//                            O,X,O,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 0;
//     let y = 1;
//     let parent_x = 1;
//     let parent_y = 2;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 3, 'jump point should be 3');
// }

// // Giving parent (P) and actual (A) has an obstacle in (y + 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O O O
// // O A O 
// // O X P 
// #[test]
// fn test_jump_with_diagonal_up_left_obstacle_in_y_plus_1() {
//     let map_tiles = array![O,O,O,
//                            O,O,O,
//                            O,X,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 2;
//     let parent_y = 2;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

// // Giving parent (P) and actual (A) has an obstacle in (x + 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O O P
// // O A X 
// // O O O 
// #[test]
// fn test_jump_with_diagonal_down_left_obstacle_in_x_plus_1() {
//     let map_tiles = array![O,O,O,
//                            O,O,X,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 2;
//     let parent_y = 0;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

// // Giving parent (P) and actual (A) has an obstacle in (y - 1) position
// // When call jump()
// // Then method will return actual node as jump point
// // Map:
// // O X P 
// // O A O 
// // O O O 
// #[test]
// fn test_jump_with_diagonal_down_left_obstacle_in_y_minus_1() {
//     let map_tiles = array![O,X,O,
//                            O,O,O,
//                            O,O,O];

//     let map = build_map(3, 3, map_tiles);

//     let x = 1;
//     let y = 1;
//     let parent_x = 2;
//     let parent_y = 0;

//     let result = jump(map, x, y, parent_x, parent_y, UNRECHEABLE, UNRECHEABLE);
//     assert(result.unwrap() == 4, 'jump point should be 4');
// }

//   0 1 2 3 4 5  
// 0 O O O O X O  
// 1 O S O X G O  
// 2 O O O X X O  
// 3 O O X O O O  
// 4 O O O X O X  
// 5 O X O O O X  
// S: Start, G: Goal
// Map width = 6, height = 6
// #[test]
// fn test_find_path_with_small_map() {
//     let map_tiles = array![O,O,O,O,X,O,
//                            O,O,O,X,O,O,
//                            O,O,O,X,X,O,
//                            O,O,X,O,O,O,
//                            O,O,O,X,O,X,
//                            O,X,O,O,O,X,
//     ];

//     let map = build_map(6, 6, map_tiles);

//     let start = (1, 1);
//     let goal = (4, 1);

//     let mut result = JPSTrait::find_path(map, start: start, goal: goal);
//     // println!("------------------");
//     // print(map.width, result);
//     assert(result.len() == 8, 'wrong jps');
// }

//   0 1 2 3 4 5  
// 0 O O O O X O  
// 1 O S O X G O  
// 2 O O O X X O  
// 3 O O X O O O  
// 4 O O O X O X  
// 5 O X O X O X  
// S: Start, G: Goal
// Map width = 6, height = 6
// #[test]
// fn test_find_path_with_small_map_non_solution() {
//     let map_tiles = array![
//         O,
//         O,
//         O,
//         O,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         O,
//         O,
//         O,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         X,
//         X,
//         X,
//         X,
//         O,
//         O,
//         O,
//         X,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         O,
//         O,
//         X,
//         X,
//         O,
//         O,
//         X,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         O,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         O,
//         O,
//         X,
//         X,
//         X,
//         O,
//         X,
//         O,
//         O,
//         X,
//         X,
//         O,
//         O,
//         O,
//         O,
//         X,
//         O,
//         X,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         O,
//         X,
//         O,
//         O,
//         X,
//         O,
//         O,
//         X,
//         O,
//         O,
//         X,
//         O,
//         O,
//         O,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         X,
//         O,
//         O,
//         X,
//         X,
//         O,
//         O,
//         X,
//         O,
//         O,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         X,
//         O,
//         O,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         O,
//         X,
//         O
//     ];

//     let map = build_map(30, 10, map_tiles);

//     let start = (1, 2);
//     let goal = (29, 9);

//     let mut result = JPSTrait::find_path(map, start: start, goal: goal);
//     println!("------------------");
//     print(30, result);
// }

#[test]
#[available_gas(1000000000000000)]
// fn test_find_path_with_big_map() {
fn test_a_star() {
    let map_tiles = array![O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,O,X,O,O,O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,X,X,X,X,X,O,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,O,X,O,O,X,X,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,O,O,O,O,O,O,O,X,O,X,X,X,X,X,X,X,X,X,X,X,X,X,O,O,X,X,X,
                           O,X,O,O,X,X,O,O,O,O,X,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,X,O,O,X,O,O,X,O,O,X,O,O,O,X,X,X,X,X,X,X,X,X,X,O,O,O,O,
                           O,X,X,O,O,X,X,O,O,X,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,X,X,O,O,
                           X,O,O,O,O,O,O,O,O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,X,O,
                           O,O,O,O,O,X,X,O,O,O,O,O,X,O,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,X,
                           O,O,X,X,O,O,X,O,O,O,O,X,O,O,O,X,O,O,X,X,X,X,X,X,X,X,X,O,O,X,
                           O,O,X,X,O,O,X,O,X,O,O,X,X,X,X,O,X,X,O,X,X,O,O,O,O,O,O,O,O,X,
                           O,O,X,X,X,O,X,O,X,O,O,O,O,O,O,O,X,X,O,X,O,O,O,O,O,X,O,O,O,X,
                           O,O,O,O,O,O,X,O,X,O,O,O,O,O,O,O,O,O,O,X,X,O,O,X,X,X,X,X,X,X,
                           O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,O,X,O,O,O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,X,X,X,X,X,O,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,O,X,O,O,X,X,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,O,O,O,O,O,O,O,X,O,X,X,X,X,X,X,X,X,X,X,X,X,X,O,O,X,X,X,
                           O,X,O,O,X,X,O,O,O,O,X,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,X,O,O,X,O,O,X,O,O,X,O,O,O,X,X,X,X,X,X,X,X,X,X,O,O,O,O,
                           O,X,X,O,O,X,X,O,O,X,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           X,O,O,O,O,O,O,O,O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,X,O,
                           O,O,O,O,O,X,X,O,O,O,O,O,X,O,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,X,
                           O,O,X,X,O,O,X,O,O,O,O,X,O,O,O,X,O,O,X,X,X,X,X,X,X,X,O,O,O,X,
                           O,O,X,X,O,O,X,O,X,O,O,X,X,X,X,O,X,X,O,X,X,O,O,O,O,O,O,O,O,X,
                           O,O,X,X,X,O,X,O,X,O,O,O,O,O,O,O,X,X,O,X,O,O,O,O,O,X,O,O,O,X,
                           O,O,O,O,O,O,X,O,X,O,O,O,O,O,O,O,O,O,O,X,X,O,O,X,X,X,X,X,X,X,
                           O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,O,X,O,O,O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,X,X,X,X,X,O,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,O,X,O,O,X,X,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,O,O,O,O,O,O,O,X,O,X,X,X,X,X,X,X,X,X,X,X,X,X,O,O,X,X,X,
                           O,X,O,O,X,X,O,O,O,O,X,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,X,O,O,X,O,O,X,O,O,X,O,O,O,X,X,X,X,X,X,X,X,X,X,O,O,O,O,
                           O,X,X,O,O,X,X,O,O,X,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,X,X,O,O,
                           X,O,O,O,O,O,O,O,O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,X,O,
                           O,O,O,O,O,X,X,O,O,O,O,O,X,O,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,X,
                           O,O,X,X,O,O,X,O,O,O,O,X,O,O,O,X,O,O,X,X,X,X,X,X,X,X,X,O,O,X,
                           O,O,X,X,O,O,X,O,X,O,O,X,X,X,X,O,X,X,O,X,X,O,O,O,O,O,O,O,O,X,
                           O,O,X,X,X,O,X,O,X,O,O,O,O,O,O,O,X,X,O,X,O,O,O,O,O,X,O,O,O,X,
                           O,O,O,O,O,O,X,O,X,O,O,O,O,O,O,O,O,O,O,X,X,O,O,X,X,X,X,X,X,X,
                           O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,O,X,O,O,O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,X,X,X,X,X,O,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,O,O,O,O,X,O,O,X,X,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,O,O,O,O,O,O,O,X,O,X,X,X,X,X,X,X,X,X,X,X,X,X,O,O,X,X,X,
                           O,X,O,O,X,X,O,O,O,O,X,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           O,X,O,X,O,O,X,O,O,X,O,O,X,O,O,O,X,X,X,X,X,X,X,X,X,X,O,O,O,O,
                           O,X,X,O,O,X,X,O,O,X,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
                           X,O,O,O,O,O,O,O,O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,X,O,
                           O,O,O,O,O,X,X,O,O,O,O,O,X,O,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,X,
                           O,O,X,X,O,O,X,O,O,O,O,X,O,O,O,X,O,O,X,X,X,X,X,X,X,X,O,O,O,X,
                           O,O,X,X,O,O,X,O,X,O,O,X,X,X,X,O,X,X,O,X,X,O,O,O,O,O,O,O,O,X,
                           O,O,X,X,X,O,X,O,X,O,O,O,O,O,O,O,X,X,O,X,O,O,O,O,O,X,O,O,O,X,
                           O,O,O,O,O,O,X,O,X,O,O,O,O,O,O,O,O,O,O,X,X,O,O,X,X,X,X,X,X,X,];

    let map = build_map(30, 60, map_tiles);

    let start = (1, 2);
    let goal = (20, 55);

    let mut result = JPSTrait::find_path(map, start: start, goal: goal);
    // println!("len a_star: {}", result.len());
    print(map.width, result);
}

// @external
// func test_find_path_with_big_map{pedersen_ptr: HashBuiltin*, range_check_ptr}() {
//     alloc_locals;
//     let point_attribute: DictAccess* = create_attribute_dict();
//     let heap: DictAccess* = heap_create();
//     tempvar map_grids: felt* = cast(new(O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
//                                         O,X,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
//                                         O,O,O,O,O,X,O,O,O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
//                                         O,O,O,O,X,X,X,X,X,O,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
//                                         O,O,O,O,O,X,O,O,X,X,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
//                                         O,X,O,O,O,O,O,O,O,O,X,O,X,X,X,X,X,X,X,X,X,X,X,X,X,O,O,X,X,X,
//                                         O,X,O,O,X,X,O,O,O,O,X,O,X,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,
//                                         O,X,O,X,O,O,X,O,O,X,O,O,X,O,O,O,X,X,X,X,X,X,X,X,X,X,O,O,O,O,
//                                         O,X,X,O,O,X,X,O,O,X,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,X,X,O,O,
//                                         X,O,O,O,O,O,O,O,O,O,O,O,X,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,X,O,
//                                         O,O,O,O,O,X,X,O,O,O,O,O,X,O,O,O,X,X,O,O,O,O,O,O,O,O,O,O,O,X,
//                                         O,O,X,X,O,O,X,O,O,O,O,X,O,O,O,X,O,O,X,X,X,X,X,X,X,X,X,O,O,X,
//                                         O,O,X,X,O,O,X,O,X,O,O,X,X,X,X,O,X,X,O,X,X,O,O,O,O,O,O,O,O,X,
//                                         O,O,X,X,X,O,X,O,X,O,O,O,O,O,O,O,X,X,O,X,O,O,O,O,O,X,O,O,O,X,
//                                         O,O,O,O,O,O,X,O,X,O,O,O,O,O,O,O,O,O,O,X,X,O,O,X,X,X,X,X,X,X), felt*);
//     let map = Map(map_grids, 30, 15);

//     let start_x = 1;
//     let start_y = 2;
//     let end_x = 22;
//     let end_y = 13;
//     let (result_after_lenght: felt, result_after: Point*) = find_path{pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, point_attribute=point_attribute, heap=heap}(start_x, start_y, end_x, end_y, map);
//     return ();
// }

fn build_map(width: u64, height: u64, tiles: Array<felt252>) -> Map {
    let mut map_tiles = array![];
    let mut x = 0;
    let mut y = 0;

    loop {
        let id = (y * width + x);
        if id.try_into().unwrap() == tiles.len() {
            break;
        }
        if x == width {
            y += 1;
            x = 0;
        }
        if *tiles.at(id.try_into().unwrap()) == O {
            map_tiles.append(TileTrait::new(id, x.into(), y.into(), true));
        } else {
            map_tiles.append(TileTrait::new(id, x.into(), y.into(), false));
        }
        x += 1;
    };
    MapTrait::new(height, width, map_tiles.span())
}

fn print(width: u64, span: Span<(u64, u64)>) { 
    let mut i = 0;
    print!("ASTAR PATH: {{ len: {}, values: [ ", span.len());
    loop {
        if span.len() == i {
            break;
        }
        let (x, y) = *(span.at(i));
        if span.len() - 1 != i {
            print!("(x: {}, y: {}), ", x, y);
        } else {
            print!("(x: {}, y: {})", x, y);
        }
        i += 1;
    };
    println!(" ] }}")
}
