import xml.etree.ElementTree as et
import matplotlib.pyplot as plt
import numpy as np
from svg.path import Path, Line, CubicBezier, parse_path

def norm2(arr):
	''' This function finds the 2-norm of a line which is defined as a list of
	tuples where arr[0] is the start point tuple of (x,y) and arr[1] is the end
	point.'''
	normalized = np.subtract(zip(arr[1]),zip(arr[0]));
	return np.sqrt(np.sum(np.multiply(normalized,normalized)));

def ddx(arr):
	''' This function finds the range and value change (rise and run) of a line
	which is defined as a list of tuples where arr[0] is the start point tuple
	of (x,y) and arr[1] is the end point.'''
	normalized = np.subtract(zip(arr[1]),zip(arr[0]));
	return (normalized[1],normalized[0]);

# set some variables
scale = 1.0/100.0;
param = 0.01;
h = param/scale;

# parse our svg file
tree = et.parse('square_with_hole.svg')
root = tree.getroot()

# Find a bounding box (the svg page)
bbox_width = scale * float(root.attrib['width']);
bbox_height = scale * float(root.attrib['height']);

# Find if there's been a transform defined in the group
for child in root.iter('{http://www.w3.org/2000/svg}g'):
	transform_str = child.attrib['transform'];
	transform_str = transform_str.strip('translate(').strip(')');
	transform_x = float(transform_str.split(',')[0]);
	transform_y = float(transform_str.split(',')[1]);

# Find the path by all elements tagged path (with xmlnamespace)
for child in root.iter('{http://www.w3.org/2000/svg}path'):
	# our d string is now the actions for the shape
	d_string = child.attrib['d'];
	# iterate over the string until it is empty
	ret = parse_path(d_string);
	path = ret
	for child in path:
		# assert that the path is closed
		pass;
		# get the elements types and endpoints and controls for them
		if type(child) is CubicBezier:
			cntrl1_x = np.real(child.control1) + transform_x;
			cntrl1_y = np.imag(child.control1) + transform_y;
			cntrl2_x = np.real(child.control2) + transform_x;
			cntrl2_y = np.imag(child.control2) + transform_y;
		start_x = np.real(child.start) + transform_x;
		start_y = np.imag(child.start) + transform_y;
		end_x = np.real(child.end) + transform_x;
		end_y = np.imag(child.end) + transform_y;
		# calculate path length
		if type(child) is Line:
			length = child.length();  #norm2([(start_x,start_y),(end_x,end_y)]);
		elif type(child) is CubicBezier:
			length = child.length(error=1.0E-5);
		else:
			print 'something else entirely!';
		# iterate along the path with size close to h and generate points
		if length > 0.0:
			pts = np.linspace(0.0,1.0,float(int(length/h)));
			x = np.zeros_like(pts);
			y = x.copy();
			x[0] = start_x;
			y[0] = start_y;
			for i in range(1,len(pts)):
				pt = child.point(pts[i]);
				x[i] = np.real(pt) + transform_x;
				y[i] = np.imag(pt) + transform_y;
			# plot this to a figure to ensure that geometry import worked
			square_with_hole = plt.plot(x,y,'k.');
			plt.savefig('square_with_hole');
			# return an object of type that we created
			pass;

