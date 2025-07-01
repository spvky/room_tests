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

	iter := tile_make_iter_ray(cell,{6,1},.South)
	fmt.println("Finished building Iter")
	val, cond := iter_tiles_until(&iter, .Wall)

	testing.expect(t, val.relative_position == [2]i8{6,8})
	
}

