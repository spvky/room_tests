package main

import sa "core:container/small_array"

Cell :: struct {
	relative_position: [2]i16,
	tiles: [12][12]Tile
}

CellIter :: struct {
	cells: sa.Small_Array(20,Cell),
	index: int
}
