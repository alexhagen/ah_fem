import numpy as np

class geo(object):
	def __init__(filename):
		self.filename = filename;
		if '.x3d' is in self.filename:
			# we have a 3d shape if we have an x3d file
			self.dim = 3;
			self.import_3d();
		elif '.svg' is in self.filename:
			# we have a 2d shape if we have an svg file
			self.dim = 2;
			self.import_2d();
		else:
			## add a filename error here
			pass;
			
	def import_2d():
		# for 2d meshes, we have points and edges.  we use a dict so that we can
		# name some edges (for boundary conditions later);
		self.points = [];
		self.edges = {};
		# iterate through svg structure finding points
		# iterate through svg structure finding connectivity between points
	def import_3d():
		# for 3d meshes, we have points and faces.  we use a dict so that we can
		# name some faces (for boundary conditions later);
		self.points = [];
		self.faces = {};