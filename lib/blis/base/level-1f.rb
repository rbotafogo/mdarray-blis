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
    
    x_i = MDArray::IteratorFastDouble.new(vec_x)
    y_i = MDArray::IteratorFastDouble.new(vec_y)

    while(x_i.has_next?)
      y_val = y_i.get_next
      y_i.set_current(y_val + (alphax * x_i.get_next + alphay * y_val))
    end

  end
  
  #----------------------------------------------------------------------------------------
  # rho := conjxt(x^T) * conjy(y)
  # y   := y + alpha * conjx(x)
  # where x, y, and z are vectors of length m and alpha and rho are scalars. The kernel,
  # if optimized, is implemented as a fusion of calls to dotv and axpyv.
  #----------------------------------------------------------------------------------------

  def self.dotaxpyv(alpha, vec_x, vec_y)

  end

end
