package main

import rl "vendor:raylib"
import sa "core:container/small_array"

Room :: struct {
	cell_origin: [2]i16,
	tag: RoomTag,
	cells: sa.Small_Array(20,Cell)
}

MapRoom :: struct {
	relative_position: [2]i8,
	room_ptr: ^Room,
	rotation: i8
}

CursorRoom :: struct {
	room_ptr: ^Room,
	rotation: i8
}

RoomTag :: enum { A,B,C,D,E,F }

draw_cursor_room :: proc(room: CursorRoom, mouse_pos: [2]f32) {
	iter := cell_make_iter(room.room_ptr.cells)
	for cell in iter_cells(&iter) {
		origin: [2]f32
		switch room.rotation {
			case 0:
		origin = [2]f32{f32(cell.relative_position.x) * CELL_SIZE.x, f32(cell.relative_position.y) * CELL_SIZE.y} + mouse_pos
			case 1:
				origin = [2]f32{f32(-cell.relative_position.y) * CELL_SIZE.x, f32(cell.relative_position.x) * CELL_SIZE.y} + mouse_pos
			case 2:
				origin = [2]f32{f32(-cell.relative_position.x) * CELL_SIZE.x, f32(-cell.relative_position.y) * CELL_SIZE.y} + mouse_pos
			case 3:
				origin = [2]f32{f32(cell.relative_position.y) * CELL_SIZE.x, f32(-cell.relative_position.x) * CELL_SIZE.y} + mouse_pos
		}
		rl.DrawRectangleV(origin, CELL_SIZE, rl.WHITE)
	}
}
