# Triangulating A Star-Shaped Polygon with Known Kernel
Max Goldstein

## Traingulatize a what with a what?

A polygon is **star-shaped** if one point inside the polygon can see every
other point on the polygon. The region containing those points is called the
**kernel**. A **traingulation** of a polygon divides the interior space into
triangles. Every polygon admits a triangulation but finding it on a general
polygon in linear time is extremely complicated. But if you know the polygon is
star-shaped and you have a point on the kernel, it's much easier.

##A nd that algorithm is?

Start by drawing lines from the kernel to every vertex to create triangles
inside the polygon. Because *the kernel isn't in the final triangulation*, we
have to eliminate these lines. We do this by "flipping" to the other diagonal
of the quadrilateral.

We walk the boundary of the untriangulated polygon and work inward. When we
encounter a convex vertex, we know it forms a convex quadrilateral and can
"flip" to the other diagonal, which *is* in the triangulation. Those one other
proviso is that the triangle of this vertex and its neighbors must not contain
the kernel. If it's okay to flip, we're now done with the vertex and can shrink
the chain.

Eventually we wind up with a triangle containing the kernel, so then we just
get rid of those last three temporary lines and we're done.

## So this repo is...?

A demonstration of the algorithm. Start by clicking to add points of the
polygon. When you're done, they're sorted in radial order as seen by the kernel
to create a star-shaped polygon. Then watch the alogrithm unfold.

For best results, avoid placing points in too close an arc from the central
kernel, and putting three points on a line.

The code is written in Processing, a graphics wrapper around Java. Thanks to
processing.js, you can see a
[demonstration](http://www.eecs.tufts.edu/~mgolds07/triangulate/) run in your
webbrowser.

## And you did this why?
As a project for my class in Computational Geometry at Tufts University, in spring 2013.
