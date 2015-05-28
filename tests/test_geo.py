import xml.etree.ElementTree as et

# set some variables
scale = 1.0/100.0;

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
	d_string = child.attrib['d']