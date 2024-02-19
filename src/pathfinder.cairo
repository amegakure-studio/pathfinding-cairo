use pathfinding::data_structures::map::Map;
use pathfinding::data_structures::tile::Tile;
use starknet::ContractAddress;

#[starknet::interface]
trait IPathfinder<TContractState> {
    fn jps(
        self: @TContractState,
        tiles: Span<Tile>,
        map_width: u64,
        map_height: u64,
        start: (u64, u64),
        goal: (u64, u64)
    ) -> Span<(u64, u64)>;
}

#[starknet::contract]
mod Pathfinder {
    use pathfinding::algorithms::{jps::JPSTrait};
    use pathfinding::data_structures::{map::{Map, MapTrait}, tile::Tile,};
    use super::IPathfinder;

    #[storage]
    struct Storage {}

    #[external(v0)]
    impl PathfinderImpl of IPathfinder<ContractState> {
        fn jps(
            self: @ContractState,
            tiles: Span<Tile>,
            map_width: u64,
            map_height: u64,
            start: (u64, u64),
            goal: (u64, u64)
        ) -> Span<(u64, u64)> {
            let map = MapTrait::new(map_width, map_height, tiles);
            JPSTrait::find_path(map, start, goal)
        }
    }
}
