# -*- coding: utf-8 -*-

##########################################################################################
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

require "test/unit"
require 'shoulda'

require '../config' if @platform == nil
require 'mdarray-blis'


class MDArrayTest < Test::Unit::TestCase

  context "Blis" do

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    setup do 

      # column vector
      @c_vec = MDArray.double([3, 1], [-1, 2, 1])
      @matrix = MDArray.double([3, 3], [-1, 0, 2,
                                        2, -1, 1,
                                        3, 1, -1])

      @m1 = MDArray.double([3, 3], [0.4, 0.3, 0.1,
                                    0.4, 0.3, 0.6,
                                    0.2, 0.4, 0.3])

      @m2 = MDArray.double([4, 3], [2, 0, 1,
                                    -1, 1, 0,
                                    1, 3, 1,
                                    -1, 1, 1])

      @m3 = MDArray.double([3, 4], [2, 1, 2, 1,
                                    0, 1, 0, 1,
                                    1, 0, 1, 0])
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do matrix vector multiplication based on dotv" do

      @matrix.pp
      @c_vec.pp
      yvec = MDArray.double([3, 1], [1, 1, 1])

      Blis.gemv_dot(2, 2, yvec, @matrix, @c_vec)
      yvec.pp

      p "matrix matrix"
      res = MDArray.double([3, 3])
      Blis.gemm_dot(res, @m1, @m1)
      res.pp

      p "m2 * m3"
      res = MDArray.double([4, 4])
      Blis.gemm_dot(res, @m2, @m3)
      res.pp
      
      p "m3 * m2"
      res = MDArray.double([3, 3])
      Blis.gemm_dot(res, @m3, @m2)
      res.pp
      
    end

  end

end
