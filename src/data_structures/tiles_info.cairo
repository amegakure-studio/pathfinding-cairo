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
