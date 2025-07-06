package main

import "core:fmt"
import "core:encoding/csv"
import "core:os"
import "core:strconv"
import sa "core:container/small_array"



read_room :: proc(tag: RoomTag) -> Room {
	filename := room_tag_as_filepath(tag, .CSV)
	r: csv.Reader
	r.trim_leading_space  = true
	defer csv.reader_destroy(&r)

	cell_array: sa.Small_Array(20, Cell)

	csv_data, ok := os.read_entire_file(filename)
	if ok {
		csv.reader_init_with_string(&r, string(csv_data))
	} else {
		fmt.printfln("Unable to open file: %v", filename)
		return Room{}
	}
	defer delete(csv_data)

	records, err := csv.read_all(&r)
	if err != nil do fmt.printfln("Failed to parse CSV file for %v\nErr: %v", filename, err)

	defer {
		for rec in records {
			delete(rec)
		}
		delete(records)
	}
	width:= len(records[0]) / 12
	height:= len(records) / 12

	
	rooms: [10][10]Cell

	for r, i in records {
		for f, j in r {
			x: i16 = i16(j) / 12 //X and Y inform which room cell we are populating
			y: i16 = i16(i) / 12 //X and Y inform which room cell we are populating
			ix:= i8(j) - i8(x * 12)
			iy:= i8(i) - i8(y * 12)
			current_cell := &rooms[x][y]
			current_cell.relative_position = {x,y}
			if field, ok := strconv.parse_uint(f); ok {
				current_cell.tiles[iy][ix] = Tile{ value = TileValue(field), relative_position = {ix,iy}}
			}
		}
	}

	for i in 0..<10 {
		for j in 0..<10 {
			validity:= is_valid_room_cell(rooms[j][i])
			if validity {
				sa.append(&cell_array,rooms[j][i])
			}
		}
	}
	return  Room {cells=cell_array, tag = tag}
}

room_tag_as_filepath :: proc(tag: RoomTag, extension: enum{CSV, PNG}) -> string {
	switch extension {
		case .CSV:
			return fmt.tprintf("%v.csv", tag)
		case .PNG:
			return fmt.tprintf("ldtk/samples/simplified/%v/Main.png", tag)
	}
	return ""
}

is_valid_room_cell :: proc(cell: Cell) -> bool {
	for i in 0..<12 {
		for j in 0..<12 {
			value: = cell.tiles[i][j].value
			if value != .Empty {
				return true
			}
		}
	}
	return false
}

