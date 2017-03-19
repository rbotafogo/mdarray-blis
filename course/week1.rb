require_relative '../config'
require 'mdarray-laff'
# require the vecvec operations from the course
require_relative 'vecvec'

# row vector
r_vec = MDArray.double([1, 5], [2, -1, 4, 2, 1])
# column vector
c_vec = MDArray.double([5, 1], [1, -2, 2, 3, -1])

p Course.dotv(r_vec, c_vec)

v1 = MDArray.double([1, 5], [2, -1, 4, 2, 1])
v2 = MDArray.double([5, 1], [1, -2, 2, 3, -1])

Course.axpyv(-1, v1, v2)
v1.pp
