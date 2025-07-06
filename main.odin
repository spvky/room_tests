package main

import "core:fmt"
import "core:time"
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

	for j in 0..<12 {
		for i in 0..<12 {
			tiles[j][i].value = TileValue(values[j][i])
			tiles[j][i].relative_position = [2]i8{i8(i),i8(j)}
		}
	}
	return Cell {tiles = tiles}
}

Direction :: enum {
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
	return TileIter {tiles = tiles}
}

tile_make_iter :: proc(tiles: sa.Small_Array(12, Tile)) -> TileIter {
	return TileIter {tiles = tiles}
}

iter_tiles :: proc(iter: ^TileIter) -> (val: Tile, cond: bool) {
	length := sa.len(iter.tiles)
	in_range := iter.index < length
	for in_range {
		val,cond = sa.get_safe(iter.tiles,iter.index)
		iter.index += 1
		return
	}
	return
}



FatTile :: struct {
	top: Tile,
	bottom: Tile
}

FatTileIter :: struct {
	fat_tiles: sa.Small_Array(12, FatTile),
	index: int
}

fat_tile_make_iter_ray :: proc(cell: Cell, origin: [2]i8, direction: Direction) -> FatTileIter {
	// Fat tile iters cannot be created on the top row, and they cannot travel vertically
	assert(origin.y > 0 && (direction == .West || direction == .East))
	fat_tiles: sa.Small_Array(12, FatTile)
	#partial switch direction {
		case .East:
			origin_row := origin.y
			origin_start := origin.x
			i := origin_start
			for i < 12 {
				fat_tile := FatTile {
					top = cell.tiles[origin_row - 1][i],
					bottom = cell.tiles[origin_row][i]
				}
				sa.append(&fat_tiles, fat_tile)
				i += 1
			}
		case .West:
			origin_row := origin.y
			origin_start := origin.x
			i := origin_start
			for i >= 0 {
				fat_tile := FatTile {
					top = cell.tiles[origin_row - 1][i],
					bottom = cell.tiles[origin_row][i]
				}
				sa.append(&fat_tiles, fat_tile)
				i -= 1
			}
	}
	return FatTileIter {fat_tiles = fat_tiles}
}

iter_fat_tiles :: proc(iter: ^FatTileIter) -> (val: FatTile, cond: bool) {
	length := sa.len(iter.fat_tiles)

	in_range := iter.index < length

	for in_range {
		val, cond = sa.get_safe(iter.fat_tiles, iter.index)
		iter.index += 1
		return
	}
	return
}

main :: proc() {
	cell := make_cell([12][12]u8{
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	1,	1,	1,	1,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1},
			{1,	0,	0,	1,	1,	1,	1,	0,	0,	0,	0,	1},
			{1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1},
			{1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1},
			{1,	1,	1,	1,	1,	1,	1,	1,	0,	1,	1,	1},
	})
	
	terminus := water_bake(cell,{5,1})
	length := len(terminus)
	fmt.printfln("Terminus Length: %v", length)
	for k,v in terminus {
		fmt.printfln("Position: %v", k)
		fmt.printfln("Value: %v", v)
	}
}


WaterCondition :: enum {
	Until,
	UntilNot
}

WaterPath :: struct {
	origin: [2]i8,
	direction: Direction,
	should_skip: bool
}

WaterEndpoint :: struct {
	position: [2]i8,
	value: TileValue
}

water_bake :: proc(cell: Cell, origin: [2]i8) -> map[[2]i8]TileValue {// [dynamic]WaterEndpoint {
	start := time.now()
	still_baking := true
	end_points := make(map[[2]i8]TileValue, 8, allocator = context.temp_allocator)
	paths_to_execute: [dynamic]WaterPath
	skips: int
	iter_count: int

	initial_iter := tile_make_iter_ray(cell, origin, .South)
	initial_loop: for tile in iter_tiles(&initial_iter) {
		#partial switch tile.value {
			case .Empty:
				continue
			case .Wall:
				left_path := WaterPath {
					origin = tile.relative_position,
					direction = .West,
				}
				right_path := WaterPath {
					origin = tile.relative_position,
					direction = .East,
				}
				paths_to_execute = make([dynamic]WaterPath, 0, 8, allocator = context.temp_allocator)
				append_elems(&paths_to_execute,left_path, right_path)
				break initial_loop
			case .Exit:
				end_points[tile.relative_position] = tile.value
				still_baking = false
				break initial_loop
		}
	}
	baking_loop: for still_baking {
		length := len(paths_to_execute)
		paths_loop: for &path,i in paths_to_execute {
			if path.should_skip {
				paths_length := len(paths_to_execute)
				if skips ==  paths_length{
					still_baking = false
					break paths_loop
				}
				continue paths_loop
			}
			#partial switch path.direction {
				case .West:
					iter := fat_tile_make_iter_ray(cell,path.origin, path.direction)
					if sa.len(iter.fat_tiles) == 10 {
					}
					west_fat_loop: for ft in iter_fat_tiles(&iter) {
						top := ft.top
						bot := ft.bottom
						switch true {
							case bot.value == .Empty && top.value == .Empty:
								path.should_skip = true
								skips += 1
								append(&paths_to_execute, WaterPath {
									origin = top.relative_position,
									direction = .South,
								})
								continue paths_loop
							case bot.value == .Wall && top.value == .Empty:
							case bot.value == .Wall && top.value == .Wall:
				end_points[bot.relative_position] = bot.value
								path.should_skip = true
								skips += 1
								continue paths_loop
						}
					}
				case .East:
					iter := fat_tile_make_iter_ray(cell,path.origin, path.direction)
					if sa.len(iter.fat_tiles) == 10 {
					}
					east_fat_loop: for ft in iter_fat_tiles(&iter) {
						top := ft.top
						bot := ft.bottom
						switch true {
							case bot.value == .Empty && top.value == .Empty:
								path.should_skip = true
								skips += 1
								append(&paths_to_execute, WaterPath {
									origin = top.relative_position,
									direction = .South,
								})
								continue paths_loop
							case bot.value == .Wall && top.value == .Empty:
							case bot.value == .Wall && top.value == .Wall:
				end_points[bot.relative_position] = bot.value
								path.should_skip = true
								skips += 1
								continue paths_loop
						}
					}
				case .South:
					iter := tile_make_iter_ray(cell,path.origin, .South)
					thin_loop: for tile in  iter_tiles(&iter) {
						#partial switch tile.value {
							case .Empty:
								end_of_cell := tile.relative_position.y == 11
								if end_of_cell {
									path.should_skip = true
									skips += 1
				end_points[tile.relative_position] = tile.value
									break thin_loop
								} else {
								}
							case .Wall:
								left_path := WaterPath {
									origin = tile.relative_position,
									direction = .West,
								}
								right_path := WaterPath {
									origin = tile.relative_position,
									direction = .East,
								}
								path.should_skip = true
								skips += 1
								append_elems(&paths_to_execute,left_path, right_path)
								break thin_loop
							case .Exit:
								path.should_skip = true
				end_points[tile.relative_position] = tile.value
								break thin_loop
						}
					}
			}
			// // unordered_remove(&paths_to_execute,i)
			// path.should_skip = true
			// skips += 1
		}
		// if len(paths_to_execute) == skips {
		// 	// We have explored all possible paths and we can terminate
		// 	still_baking = false
		// 	break baking_loop
		// }
	}
	end := time.now()
	diff := time.diff(start, end)
	fmt.printfln("TIME === %v", time.duration_milliseconds(diff))
	return end_points
}
