package main

import sa "core:container/small_array"
import "core:fmt"
import rl "vendor:raylib"

Vec2 :: [2]f32

Direction :: enum {
	North,
	South,
	East,
	West,
}

CELL_SIZE :: [2]f32{32, 32}

main :: proc() {
	cell := make_cell(
		[12][12]u8 {
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
			{1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1},
			{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
			{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
			{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		},
	)

	terminus := water_bake(cell, {5, 1})
	length := len(terminus)
	fmt.printfln("Terminus Length: %v", length)
	endpoints := make([dynamic]Water_Endpoint, 0, 8)
	for k, v in terminus {
		fmt.printfln("Position: %v", k)
		fmt.printfln("Value: %v", v)
		append(&endpoints, Water_Endpoint{position = k, value = v})
	}
	volumes := water_volumes_from_end_points_pairs(cell, endpoints)
	// }
	for volume in volumes {
		fmt.printfln("Volume: %v", volume)
	}
	a := read_room(.A)
	mouse_pos: [2]f32
	map_a := Cursor_Room {
		room_ptr = &a,
		rotation = 1,
	}

	rl.InitWindow(1600, 900, "rooms")

	for !rl.WindowShouldClose() {
		mouse_pos += rl.GetMouseDelta()

		if rl.IsKeyPressed(.R) {
			new_rot := map_a.rotation + 1
			if new_rot > 3 do new_rot = 0
			map_a.rotation = new_rot
		}

		// Draw
		rl.BeginDrawing()
		rl.ClearBackground({100, 20, 30, 255})
		// draw_cursor_room(map_a, mouse_pos)
		for y in 0 ..< 12 {
			for x in 0 ..< 12 {
				tile := cell.tiles[y][x]
				if tile.value == .Wall {
					position := [2]f32{f32(x) * 16, f32(y) * 16}
					rl.DrawRectangleV(position, {16, 16}, rl.BLACK)
				}
			}
		}

		for volume in volumes {
			center: Vec2 = {
				(f32(volume.min.x) + f32(volume.max.x) / 2) * 16,
				(f32(volume.min.y) + f32(volume.max.y) / 2) * 16,
			}
			size: Vec2 = {
				(f32(volume.max.x) - f32(volume.min.x)) * 16,
				(f32(volume.max.y) - f32(volume.min.y)) * 16,
			}

			rl.DrawRectangleV(center, size, rl.BLUE)
		}
		rl.EndDrawing()
	}

}
