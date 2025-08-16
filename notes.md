Current approach is "cute" but a bit unwieldy

Building rays of tiles, from a given cell, traversing the ray until we hit a certain tile, and then making a new ray

This doesn't cover paths of water, will probably be better to just use simple arena dynamics while baking, chart the entire path of water and volumes in a single proc
then add this final result to a permanent collection
