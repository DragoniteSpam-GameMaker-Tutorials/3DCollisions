Version 1.1

 - A bunch of optimizations
 - Removed the Matrix classes in favor of just using the GameMaker 16-element array matrices, because those were confusing and using them added more overhead that I really like
 - ColWorld now takes an Octree, Quadtree, or Spatial Hash as its preferred acceleration structure instead of creating one for you
 - Added COL_MIN_TREE_DENSITY to set the object threshold for when a tree structure is subdivided, which can speed them up by a fair amount

Version 1.0

 - Initial release