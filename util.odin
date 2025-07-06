package main

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
