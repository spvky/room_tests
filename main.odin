package main

import "core:fmt"
import sa "core:container/small_array"

Vec2 :: [2]f32

Room :: struct {
	cell_origin: [2]i16,
	tag: RoomTag,
	cells: sa.Small_Array(10,Cell)
}

RoomTag :: enum { A,B,C,D,E,F }

Cell :: struct {
	tiles: [12][12]Tile
}

make_cell :: proc (values: [12][12]u8) -> Cell {
	tiles: [12][12]Tile

	for j in 0..<11 {
		for i in 0..<11 {
			tiles[j][i].value = TileValue(values[j][i])
			tiles[j][i].relative_position = [2]i8{i8(i),i8(j)}
		}
	}
	return Cell {tiles = tiles}
}

Direction ::enum {
	North,
	South,
	East,
	West
}

Tile :: struct {
	relative_position: [2]i8,
	value: TileValue
}

TileValue :: enum {
	Empty,
	Wall,
	Exit,
	Box,
	Pipe,
	Fan
}

TileIter :: struct {
	tiles: sa.Small_Array(12, Tile),
	index: int,
}

// Create an iterator for a cell, pointing in a direction from a starting point
tile_make_iter_ray :: proc(cell: Cell, origin: [2]i8, direction: Direction) -> TileIter {
	tiles: sa.Small_Array(12, Tile)
	switch direction {
		case .North:
			origin_column := origin.x
			origin_start := origin.y
			i := origin_start
			for i >= 0 {
				sa.append(&tiles, cell.tiles[i][origin_column])
				i -= 1
			}
		case .South:
			origin_column := origin.x
			origin_start := origin.y
			i := origin_start
			for i < 11 {
				sa.append(&tiles, cell.tiles[i][origin_column])
				i += 1
			}
		case .East:
			origin_row := origin.y
			origin_start := origin.x
			i := origin_start
			for i < 11 {
				sa.append(&tiles, cell.tiles[origin_row][i])
				i += 1
			}
		case .West:
			origin_row := origin.y
			origin_start := origin.x
			i := origin_start
			for i >= 0 {
				sa.append(&tiles, cell.tiles[origin_row][i])
				i -= 1
			}
	}
	return TileIter {tiles = tiles}
}

tile_make_iter :: proc(tiles: sa.Small_Array(12, Tile)) -> TileIter {
	return TileIter {tiles = tiles}
}

iter_tiles :: proc(iter: ^TileIter) -> (val: Tile, cond: bool) {
	length := sa.len(iter.tiles)

	in_range := iter.index < length - 1

	for in_range {
		val,cond = sa.get_safe(iter.tiles,iter.index)
		iter.index += 1
		return
	}
	return
}

iter_tiles_ptr :: proc(iter: ^TileIter) -> (val: ^Tile, cond: bool) {
	length := sa.len(iter.tiles)

	in_range := iter.index < length - 1

	for in_range {
		val,cond = sa.get_ptr_safe(&iter.tiles,iter.index)
		iter.index += 1
		return
	}
	return
}

// Consumes an iterator, moving along the tiles until we find one with the given value
iter_tiles_until :: proc(iter: ^TileIter, values: ..TileValue) -> (val: Tile, cond: bool) {
	length := sa.len(iter.tiles)

	in_range := iter.index < length - 1
	iter_count := 0
	outer: for in_range && iter_count != length {
		tile := sa.get(iter.tiles, iter.index)
		for v in values {
			if tile.value == v {
				val = tile
				cond = true
				break outer
			}
		}
		iter.index += 1
		iter_count += 1
	}
	return
}

// Consumes an iterator, moving along the tiles until we find one that DOES not have the given value
iter_tiles_until_not :: proc(iter: ^TileIter, value: TileValue) -> (val: Tile, cond: bool) {
	length := sa.len(iter.tiles)

	in_range := iter.index < length - 1
	iter_count := 0
	for in_range && iter_count != length {
		tile := sa.get(iter.tiles, iter.index)
		if tile.value == value {
			iter.index += 1
			iter_count += 1
		} else {
			val = tile
			cond = true
			break
		}
	}
	return
}

main :: proc() {
}

WaterBakeResults :: struct {
	
}


WaterCondition :: enum {
	Until,
	UntilNot
}

WaterPath :: struct {
	origin: [2]i8,
	direction: Direction,
	condition: WaterCondition,
}

WaterEndpoint :: struct {
	position: [2]i8,
	value: TileValue
}

water_bake :: proc(cell: Cell, origin: [2]i8) {
	still_baking: bool
	end_points := make([dynamic]WaterEndpoint, 8, allocator = context.temp_allocator)
	paths_to_execute := make([dynamic]WaterPath, 8, allocator = context.temp_allocator)

	// current_iter := tile_make_iter_ray(cell, current_origin, .South)
	// if val, valid := iter_tiles_until(&current_iter, .Exit); valid {
		
	// }
	initial_iter := tile_make_iter_ray(cell, origin, .South)
	if val, valid := iter_tiles_until(&initial_iter, .Wall, .Exit); valid {
		#partial switch val.value {
			case .Wall:
				left_path := WaterPath {
					origin = val.relative_position,
					direction = .West,
					condition = .UntilNot
				}
				right_path := WaterPath {
					origin = val.relative_position,
					direction = .East,
					condition = .UntilNot
				}
				append_elems(&paths_to_execute,left_path, right_path)
			case .Exit:
				append(&end_points, WaterEndpoint {position = val.relative_position, value = val.value})
		}
	}
	for still_baking {
		for path,i in paths_to_execute {
			iter := tile_make_iter_ray(cell, path.origin, path.direction)
			if val, valid := iter_tiles_until(&iter, .Wall, .Exit); valid {
				#partial switch val.value {
					case .Wall:
						if path.direction == .South {
						}
					case .Exit:
						append(&end_points, WaterEndpoint {position = val.relative_position, value = val.value})
				}
			}
		}
		if len(paths_to_execute) == 0 {
			// We have explored all possible paths and we can terminate
		}
	}



}
