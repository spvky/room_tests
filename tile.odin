package main

import sa "core:container/small_array"

Tile :: struct {
	relative_position: [2]i8,
	value:             Tile_Value,
}

Tile_Value :: enum {
	Empty,
	Wall,
	Exit,
	Box,
	Pipe,
	Fan,
}

Tile_Iter :: struct {
	tiles: sa.Small_Array(12, Tile),
	index: int,
}


// Create an iterator for a cell, pointing in a direction from a starting point
tile_make_iter_ray :: proc(cell: Cell, origin: [2]i8, direction: Direction) -> Tile_Iter {
	tiles: sa.Small_Array(12, Tile)
	switch direction {
	case .North:
		origin_column := origin.x
		origin_start := origin.y
		i := origin_start
		for i >= 0 {
			tile := cell.tiles[i][origin_column]
			sa.append(&tiles, tile)
			i -= 1
		}
	case .South:
		origin_column := origin.x
		origin_start := origin.y
		i := origin_start
		for i < 12 {
			tile := cell.tiles[i][origin_column]
			sa.append(&tiles, tile)
			i += 1
		}
	case .East:
		origin_row := origin.y
		origin_start := origin.x
		i := origin_start
		for i < 12 {
			tile := cell.tiles[origin_row][i]
			sa.append(&tiles, tile)
			i += 1
		}
	case .West:
		origin_row := origin.y
		origin_start := origin.x
		i := origin_start
		for i >= 0 {
			tile := cell.tiles[origin_row][i]
			sa.append(&tiles, tile)
			i -= 1
		}
	}
	return Tile_Iter{tiles = tiles}
}

tile_make_iter :: proc(tiles: sa.Small_Array(12, Tile)) -> Tile_Iter {
	return Tile_Iter{tiles = tiles}
}

iter_tiles :: proc(iter: ^Tile_Iter) -> (val: Tile, cond: bool) {
	length := sa.len(iter.tiles)
	in_range := iter.index < length
	for in_range {
		val, cond = sa.get_safe(iter.tiles, iter.index)
		iter.index += 1
		return
	}
	return
}


Tile_Ray :: struct {
	tiles: [dynamic]Tile,
}

Fat_Tile :: struct {
	top:    Tile,
	bottom: Tile,
}

Fat_Tile_Iter :: struct {
	fat_tiles: sa.Small_Array(12, Fat_Tile),
	index:     int,
}

tile_ray

fat_tile_make_iter_ray :: proc(cell: Cell, origin: [2]i8, direction: Direction) -> Fat_Tile_Iter {
	// Fat tile iters cannot be created on the top row, and they cannot travel vertically
	assert(origin.y > 0 && (direction == .West || direction == .East))
	fat_tiles: sa.Small_Array(12, Fat_Tile)
	#partial switch direction {
	case .East:
		origin_row := origin.y
		origin_start := origin.x
		i := origin_start
		for i < 12 {
			fat_tile := Fat_Tile {
				top    = cell.tiles[origin_row - 1][i],
				bottom = cell.tiles[origin_row][i],
			}
			sa.append(&fat_tiles, fat_tile)
			i += 1
		}
	case .West:
		origin_row := origin.y
		origin_start := origin.x
		i := origin_start
		for i >= 0 {
			fat_tile := Fat_Tile {
				top    = cell.tiles[origin_row - 1][i],
				bottom = cell.tiles[origin_row][i],
			}
			sa.append(&fat_tiles, fat_tile)
			i -= 1
		}
	}
	return Fat_Tile_Iter{fat_tiles = fat_tiles}
}

iter_fat_tiles :: proc(iter: ^Fat_Tile_Iter) -> (val: Fat_Tile, cond: bool) {
	length := sa.len(iter.fat_tiles)

	in_range := iter.index < length

	for in_range {
		val, cond = sa.get_safe(iter.fat_tiles, iter.index)
		iter.index += 1
		return
	}
	return
}
