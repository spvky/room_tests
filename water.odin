package main

import "core:fmt"
import "core:math"
import sa "core:container/small_array"

Water_Path :: struct {
	origin: [2]i8,
	direction: Direction,
	should_skip: bool
}

Water_Endpoint :: struct {
	position: [2]i8,
	value: Tile_Value
}

Water_Boundary_Pair :: struct {
	endpoints: [2]Water_Endpoint,
	initialized: bool
}

Water_Volume :: struct {
	min: [2]i8,
	max: [2]i8,
}

water_volumes_from_end_points_pairs :: proc(cell: Cell, endpoints: [dynamic]Water_Endpoint) {
	pairs := make([dynamic]Water_Boundary_Pair,0,8)
	open_pair: Water_Boundary_Pair

	for we in endpoints {
		if !open_pair.initialized {
			open_pair.endpoints[0] = we
			open_pair.initialized = true
		} else {
			if we.position.y == open_pair.endpoints[0].position.y {
				open_pair.endpoints[1] = we
				append(&pairs, open_pair)
				open_pair = Water_Boundary_Pair {}
			}
		}
	}

	water_volumes := make([dynamic]Water_Volume, 0, 8)

	for pair in pairs {
		volume: Water_Volume

		volume.max.y = pair.endpoints[0].position.y
		volume.max.x = math.max(pair.endpoints[0].position.x, pair.endpoints[1].position.x) - 1
		volume.max.x = math.min(pair.endpoints[0].position.x, pair.endpoints[1].position.x) + 1

		limit := 4
		height: i8

		i0 := tile_make_iter_ray(cell, pair.endpoints[0].position, .North)
		i1 := tile_make_iter_ray(cell, pair.endpoints[1].position, .North)
		outer_loop: for i in 0..<limit {
			for t in iter_tiles(&i0) {
				#partial switch t.value {
					case .Empty:
						break outer_loop
				}
			}
			for t in iter_tiles(&i1) {
				#partial switch t.value {
					case .Empty:
						break outer_loop
				}
				height = t.relative_position.y
			}
		}
		volume.min.y = height
		append(&water_volumes, volume)
	}
}

water_bake :: proc(cell: Cell, origin: [2]i8) -> map[[2]i8]Tile_Value {// [dynamic]WaterEndpoint {
	still_baking := true
	end_points := make(map[[2]i8]Tile_Value, 8, allocator = context.temp_allocator)
	paths_to_execute: [dynamic]Water_Path
	skips: int
	iter_count: int

	initial_iter := tile_make_iter_ray(cell, origin, .South)
	initial_loop: for tile in iter_tiles(&initial_iter) {
		#partial switch tile.value {
			case .Empty:
				continue
			case .Wall:
				left_path := Water_Path {
					origin = tile.relative_position,
					direction = .West,
				}
				right_path := Water_Path {
					origin = tile.relative_position,
					direction = .East,
				}
				paths_to_execute = make([dynamic]Water_Path, 0, 8, allocator = context.temp_allocator)
				append_elems(&paths_to_execute,left_path, right_path)
				break initial_loop
			case .Exit:
				end_points[tile.relative_position] = tile.value
				still_baking = false
				break initial_loop
		}
	}
	baking_loop: for still_baking {
		length := len(paths_to_execute)
		paths_loop: for &path,i in paths_to_execute {
			if path.should_skip {
				paths_length := len(paths_to_execute)
				if skips ==  paths_length{
					still_baking = false
					break paths_loop
				}
				continue paths_loop
			}
			#partial switch path.direction {
				case .West:
					iter := fat_tile_make_iter_ray(cell,path.origin, path.direction)
					if sa.len(iter.fat_tiles) == 10 {
					}
					west_fat_loop: for ft in iter_fat_tiles(&iter) {
						top := ft.top
						bot := ft.bottom
						switch true {
							case bot.value == .Empty && top.value == .Empty:
								path.should_skip = true
								skips += 1
								append(&paths_to_execute, Water_Path {
									origin = top.relative_position,
									direction = .South,
								})
								continue paths_loop
							case bot.value == .Wall && top.value == .Empty:
							case bot.value == .Wall && top.value == .Wall:
				end_points[bot.relative_position] = bot.value
								path.should_skip = true
								skips += 1
								continue paths_loop
						}
					}
				case .East:
					iter := fat_tile_make_iter_ray(cell,path.origin, path.direction)
					if sa.len(iter.fat_tiles) == 10 {
					}
					east_fat_loop: for ft in iter_fat_tiles(&iter) {
						top := ft.top
						bot := ft.bottom
						switch true {
							case bot.value == .Empty && top.value == .Empty:
								path.should_skip = true
								skips += 1
								append(&paths_to_execute, Water_Path {
									origin = top.relative_position,
									direction = .South,
								})
								continue paths_loop
							case bot.value == .Wall && top.value == .Empty:
							case bot.value == .Wall && top.value == .Wall:
				end_points[bot.relative_position] = bot.value
								path.should_skip = true
								skips += 1
								continue paths_loop
						}
					}
				case .South:
					iter := tile_make_iter_ray(cell,path.origin, .South)
					thin_loop: for tile in  iter_tiles(&iter) {
						#partial switch tile.value {
							case .Empty:
								end_of_cell := tile.relative_position.y == 11
								if end_of_cell {
									path.should_skip = true
									skips += 1
				end_points[tile.relative_position] = tile.value
									break thin_loop
								} else {
								}
							case .Wall:
								left_path := Water_Path {
									origin = tile.relative_position,
									direction = .West,
								}
								right_path := Water_Path {
									origin = tile.relative_position,
									direction = .East,
								}
								path.should_skip = true
								skips += 1
								append_elems(&paths_to_execute,left_path, right_path)
								break thin_loop
							case .Exit:
								path.should_skip = true
				end_points[tile.relative_position] = tile.value
								break thin_loop
						}
					}
			}
		}
	}
	return end_points
}
