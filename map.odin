package main

import sa "core:container/small_array"
import rl "vendor:raylib"

Cursor_Mode :: enum {
	Placement,
	Selection
}

Map_Cursor :: struct {
	mode: Cursor_Mode,
	room_ptr: ^Room,
	room_rotation: i8,
	
}

Cursor_Room :: struct {
	room_ptr: ^Room,
	rotation: i8
}

Map_Room :: struct {
	relative_position: [2]i8,
	room_ptr: ^Room,
	rotation: i8
}

Map :: struct {
	occupied_tiles: map[[2]i8] struct {},
	rooms: sa.Small_Array(20, Map_Room),
	dirty: bool
}

draw_cursor_room :: proc(room: Cursor_Room, mouse_pos: [2]f32) {
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
