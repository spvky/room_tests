package main

import "core:fmt"
import "core:testing"


@(test)
test_grid_iter :: proc(t: ^testing.T) {

	cell := make_cell([12][12]u8{
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
			{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
	})

	fmt.println("Finished building Cell")

	iter := tile_make_iter_ray(cell,{5,1},.South)
	fmt.println("Finished building Iter")
	val, cond := iter_tiles_until(&iter, .Wall)
	fmt.printfln("CONDITION: %v", cond)
	fmt.printfln("RELATIVE_POSITION: %v", val.relative_position)

	testing.expect(t, val.relative_position == [2]i8{5,8})
	
}

