require_relative '../config'
require 'mdarray-blis'

a = MDArray.double([4, 3], [2, 0, 1,
                            -1, 1, 0,
                            1, 3, 1,
                            -1, 1, 1])

b = MDArray.double([3, 4], [2, 1, 2, 1,
                            0, 1, 0, 1,
                            1, 0, 1, 0])

at_a = MDArray.double([3, 3])
a_at = MDArray.double([4, 4])
a_b = MDArray.double([4, 4])
at_bt = MDArray.double([3, 3]) 
bt_at = MDArray.double([4, 4])
                    
at = a.transpose(0, 1)
bt = b.transpose(0, 1)

Blis.gemm_dot(at_a, at, a)
at_a.pp

Blis.gemm_dot(a_at, a, at)
a_at.pp

Blis.gemm_dot(a_b, a, b)
a_b.transpose(0, 1).pp

Blis.gemm_dot(at_bt, at, bt)
at_bt.pp

Blis.gemm_dot(bt_at, bt, at)
bt_at.pp




