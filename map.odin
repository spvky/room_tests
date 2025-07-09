package main

import sa "core:container/small_array"

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
