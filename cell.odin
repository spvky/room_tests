package main

import sa "core:container/small_array"

Cell :: struct {
	relative_position: [2]i16,
	tiles: [12][12]Tile,
}

CellIter :: struct {
	cells: sa.Small_Array(20,Cell),
	rotation: int,
	index: int
}

cell_make_iter :: proc(cells: sa.Small_Array(20, Cell)) -> CellIter {
	return CellIter {cells = cells}
}

iter_cells :: proc(iter: ^CellIter) -> (val: Cell, cond: bool) {
	length := sa.len(iter.cells)
	in_range := iter.index < length

	for in_range {
		val, cond = sa.get_safe(iter.cells, iter.index)
		iter.index += 1
		return
	}
	return
}

// rotate_cell_tiles :: proc(cell: ^Cell) {
// 		tile := &cell.tiles
//     for i in 0..<12 {
//         for j in i+1..<12 {
//           tiles[i][j], tiles[j][i] = tiles[j][i], tiles[i][j]
//         }
//     }
//     for i in 0..<12 {
// 			start, end := 0,11
// 			for start < end {
// 					tiles[i][start], tiles[i][end] = tiles[i][end], tiles[i][start]
// 				start += 1
// 				end -= 1
// 			}
// 		}
// 		// update inner tile position
// 		for i in 0..<12 {
// 			for j in 0..<12 {
// 				tiles[j][i].relative_position = {i8(i),i8(j)}
// 			}
// 		}
// }
