package main

import "core:fmt"
import sa "core:container/small_array"

Vec2 :: [2]f32

Direction :: enum {
	North,
	South,
	East,
	West
}

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
	// 		{1,1,1,1,1,1,1,1,0,1,1,1},
	// })
	
	// terminus := water_bake(cell,{5,1})
	// length := len(terminus)
	// fmt.printfln("Terminus Length: %v", length)
	// for k,v in terminus {
	// 	fmt.printfln("Position: %v", k)
	// 	fmt.printfln("Value: %v", v)
	// }
	a := read_room(.A)
	fmt.printfln("%v", sa.len(a.cells))
}

