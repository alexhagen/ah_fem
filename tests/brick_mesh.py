from meshpy.triangle import MeshInfo, build

mesh_info = MeshInfo()
mesh_info.set_points([
    (0,0), (2,0), (2,2), (0,2),
    ])
mesh_info.set_facets([
    [0,1],
    [1,2],
    [2,3],
    [3,0],
    ])
mesh = build(mesh_info)
print "Mesh Points:"
for i, p in enumerate(mesh.points):
    print i, p
print "Point numbers in tetrahedra:"
for i, t in enumerate(mesh.elements):
    print i, t
mesh.write_vtk("test.vtk")