package main

import sa "core:container/small_array"

Room :: struct {
	cell_origin: [2]i16,
	tag: Room_Tag,
	cells: sa.Small_Array(20,Cell)
}

Room_Tag :: enum { A,B,C,D,E,F }
