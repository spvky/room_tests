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

	//for j in 0..<11 {
	//	for i in 0..<11 {
	//		tile := tiles[j][i]
	//		//fmt.printfln("[%v,%v] {\nRelative_Position: %v\nValue: %v\n}", j,i,tile.relative_position, tile.value)
	//	}
	// }
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

iter_tiles_until :: proc(iter: ^TileIter, value: TileValue) -> (val: Tile, cond: bool) {
	length := sa.len(iter.tiles)

	in_range := iter.index < length - 1
	iter_count := 0
	for in_range && iter_count != length {
		tile := sa.get(iter.tiles, iter.index)
		fmt.printfln("Index: %v\n Value: %v\nPosition: %v", iter.index, tile.value, tile.relative_position)
		if tile.value != value {
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

iter_tiles_until_not :: proc(iter: ^TileIter, value: TileValue) -> (val: Tile, cond: bool) {
	length := sa.len(iter.tiles)

	in_range := iter.index < length - 1
	iter_count := 0
	for in_range && iter_count != length {
		tile := sa.get(iter.tiles, iter.index)
		fmt.printfln("Index: %v\n Value: %v\nPosition: %v", iter.index, tile.value, tile.relative_position)
		if tile.value != value {
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
