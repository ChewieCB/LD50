tool
extends TileMap

"""
This is a script to update/uplift the previous tilemap used for walls/obstacles, replacing it with
the variant with no floor so we can properly draw delivery/pickup/shop zones underneath the walls.

In future we should just build the map with the no-floor tilemap from the start, but this script
helps to convert any old maps that use the original tilemap.
"""

export (int) var new_cell_id = 2


func _ready():
	uplift_cells(new_cell_id)


func uplift_cells(new_id):
	# Get the used cells to iterate over and update
	var used_cells = self.get_used_cells()
	
	# Uplift the cell to use the new tile ID
	for cell in used_cells:
		# Get the current autotile coord so we can re-apply it
		var cell_autotile_coord = self.get_cell_autotile_coord(cell.x, cell.y)
		# Update the tile
		self.set_cellv(cell, new_id, false, false, false, cell_autotile_coord)
	
	# Update the tilemap
	self.update_dirty_quadrants()

