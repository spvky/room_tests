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
			{1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1},
			{1,	0,	0,	1,	1,	1,	1,	0,	0,	0,	0,	1},
			{1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1},
			{1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1},
			{1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1},
	})

	// iter := tile_make_iter_ray(cell,{5,1},.South)
	// if val, valid := iter_tiles_until(&iter, .Wall); valid {
	// 	testing.expect(t, val.relative_position == [2]i8{5,8})
	// }
	terminus := water_bake(cell,{5,1})
	for k,v in terminus {
		fmt.printfln("Position: %v", k)
		fmt.printfln("Value: %v", v)
	}
}

