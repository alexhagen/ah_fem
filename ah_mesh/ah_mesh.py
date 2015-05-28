import numpy as np
import geo as gi

class ah_mesh(object):
	''' our object is either 3d or 2d and will have a definition for what type 
	of mesh it will use (quad or tri in 2d, tet or hex in 3d) '''
	def __init__(filename=filename,shape=_shape):
		self.geo = gi.file_import(filename);
		self.shape = _shape;
		
	def generate():
		# for 2d meshes, we can either use quadrilateral or triangular meshing
		if self.geo.dim == 2:
			if self.shape == 'quad':
				import quad as mesh
			elif self.shape == 'tri':
				import tri as mesh
			else:
				## add a shape error here
				pass;
				
		# for 3d meshes, we can either use tetrahedral or hexahedral meshing
		elif self.dim == 3:
			if self.shape == 'tet':
				import tet as mesh
			elif self.shape == 'hex':
				import hex as mesh
			else:
				## add a shape error here
				pass;

		# now actually generate the mesh
		mesh.generate(self.geo);