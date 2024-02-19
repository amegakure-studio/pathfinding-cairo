mod min_heap {
    use pathfinding::data_structures::min_heap::{MinHeap, MinHeapTrait};
    #[test]
    fn test_min_heap_custom() {
        let mut heap = MinHeapTrait::<u64>::new();
        heap.add(0, 5);
        heap.add(1, 7);
        heap.add(2, 4);
        heap.add(3, 12);
        heap.add(4, 1);

        let (grid_id, value) = heap.poll().unwrap();
        assert(grid_id == 4, 'wrong 1st pool grid id');
        assert(value == 1, 'wrong 1st pool value');

        let (grid_id, value) = heap.poll().unwrap();
        assert(grid_id == 2, 'wrong 2nd pool grid id');
        assert(value == 4, 'wrong 2nd pool value');

        let (grid_id, value) = heap.poll().unwrap();
        assert(grid_id == 0, 'wrong 3th pool grid id');
        assert(value == 5, 'wrong 3th pool value');

        let (grid_id, value) = heap.poll().unwrap();
        assert(grid_id == 1, 'wrong 4th pool grid id');
        assert(value == 7, 'wrong 4th pool value');

        let (grid_id, value) = heap.poll().unwrap();
        assert(grid_id == 3, 'wrong 5th pool grid id');
        assert(value == 12, 'wrong 5th pool value');

        assert(heap.poll().is_none(), 'wrong 6th value');
    }
}
