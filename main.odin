package main

import "core:fmt"
import rl "vendor:raylib"
import sa "core:container/small_array"

Vec2 :: [2]f32

Direction :: enum {
	North,
	South,
	East,
	West
}

CELL_SIZE :: [2]f32{32,32}

main :: proc() {
	// cell := make_cell([12][12]u8{
	// 		{0,0,0,0,0,0,0,0,0,0,0,0},
	// 		{0,0,0,0,0,0,0,0,0,0,0,0},
	// 		{0,0,0,0,0,0,0,0,0,0,0,0},
	// 		{0,0,0,0,1,1,1,1,0,0,0,0},
	// 		{0,0,0,0,0,0,0,0,0,0,0,0},
	// 		{0,0,0,0,0,0,0,0,0,0,0,0},
	// 		{0,0,0,0,0,0,0,0,0,0,0,0},
	// 		{1,0,0,0,0,0,0,0,0,0,0,1},
	// 		{1,0,0,1,1,1,1,0,0,0,0,1},
	// 		{1,0,0,0,0,0,0,0,0,0,0,1},
	// 		{1,0,0,0,0,0,0,0,0,0,0,1},
	// 		{1,1,1,1,1,1,1,1,1,1,1,1},
	// })
	
	// terminus := water_bake(cell,{5,1})
	// length := len(terminus)
	// fmt.printfln("Terminus Length: %v", length)
	// for k,v in terminus {
	// 	fmt.printfln("Position: %v", k)
	// 	fmt.printfln("Value: %v", v)
	// }
// }
	a := read_room(.A)
	mouse_pos: [2]f32
	map_a := Cursor_Room {room_ptr = &a, rotation = 1}

	rl.InitWindow(1600,900,"rooms")

	for !rl.WindowShouldClose() {
		mouse_pos += rl.GetMouseDelta()

		if rl.IsKeyPressed(.R) {
			new_rot := map_a.rotation + 1
			if new_rot > 3 do new_rot = 0
			map_a.rotation = new_rot
		}

		// Draw
		rl.BeginDrawing()
		rl.ClearBackground({100,20,30,255})
		draw_cursor_room(map_a, mouse_pos)
		rl.EndDrawing()
	}

}

