#[derive(Copy, Drop, Serde)]
struct Tile {
    id: u64,
    x: u64,
    y: u64,
    is_walkable: bool
}

trait TileTrait {
    fn new(id: u64, x: u64, y: u64, is_walkable: bool) -> Tile;
}

impl TileImpl of TileTrait {
    fn new(id: u64, x: u64, y: u64, is_walkable: bool) -> Tile {
        Tile { id, x, y, is_walkable }
    }
}
