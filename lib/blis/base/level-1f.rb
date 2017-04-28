# -*- coding: utf-8 -*-

##########################################################################################
# @author Rodrigo Botafogo
#
# Copyright © 2017 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
# and distribute this software and its documentation, without fee and without a signed 
# licensing agreement, is hereby granted, provided that the above copyright notice, this 
# paragraph and the following two paragraphs appear in all copies, modifications, and 
# distributions.
#
# IN NO EVENT SHALL RODRIGO BOTAFOGO BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF 
# THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF RODRIGO BOTAFOGO HAS BEEN ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
#
# RODRIGO BOTAFOGO SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE 
# SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED HEREUNDER IS PROVIDED "AS IS". 
# RODRIGO BOTAFOGO HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, 
# OR MODIFICATIONS.
##########################################################################################

class Blis

  #----------------------------------------------------------------------------------------
  # y := y + alphax * conjx(x) + alphay * conjy(y)
  # where x, y, and z are vectors of length m. The kernel, if optimized, is implemented as
  # a fused pair of calls to axpyv.
  #----------------------------------------------------------------------------------------

  def self.axpy2v(alphax, alphay, vec_x, vec_y)
    
    xi = MDArray::IteratorFastDouble.new(vecx)
    yi = MDArray::IteratorFastDouble.new(vecy)

    (0...vecx.shape.max).each do
      yval = yi.get_next
      yi.set_current(yval + (alphax * xi.get_next + alphay * yval))
    end

  end
  
  #----------------------------------------------------------------------------------------
  # rho := conjxt(x^T) * conjy(y)
  # y   := y + alpha * conjx(x)
  # where x, y, and z are vectors of length m and alpha and rho are scalars. The kernel,
  # if optimized, is implemented as a fusion of calls to dotv and axpyv.
  #----------------------------------------------------------------------------------------

  def self.dotaxpyv(alpha, vecx, vecy, rho)
    
    xi = MDArray::IteratorFastDouble.new(vecx)
    yi = MDArray::IteratorFastDouble.new(vecy)

    vecxt = vecx.transpose(0, 1)

    (0...vecx.shape.max).each do
      yval = yi.get_next
      rho += xi.get_next * yval
      yi.set_current(yval + (alphax * xi.get_next + alphay * yval))
    end
    
  end

end
