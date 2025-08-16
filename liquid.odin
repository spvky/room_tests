package main

// Will actually be less of a headache to do the full tile map at once,
// 1. Find the bounding box of the full map
// 2. create a 2d dynamic array that can hold all tiles
// 3. Map baking logic
//	a. Determine screens based on the map
//	b. Determine liquid paths
//	c. Determine liquid volumes
//	d. Determine other room features
//	
//	Something interesting to consider: write something to produce all valid room configurations, bake them, cache that, add it to the binary, so that baking becomes as fast as pulling a config into memory
//

// make a cell into a single screen, i think its 4 screens per cell atm, I can't think of a good reason to keep it that way, it will simplify camera movement too

// for the camera system, "greedy mesh" the rectangles, each one will function as a rail for the camera determining bounds, this should make scrolling the camera + room transitions easier to conceptualize

// TODO: 08-16
// 1. Bounding box and global map
// 2. Camera stuff and some basic movemnt
// 3. Liquids rewrite
// 4. Add some boxes to float in water

// procs to write
// -- calculate_map_bounding_box
// -- add cell tiles to global map
// -- first baking step: liquid resolution
// -- second baking step: set camera anchors
complete_liquid_path()
