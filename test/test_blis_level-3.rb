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

    should "do matrix matrix multiplication based on dotv" do

      yvec = MDArray.double([3, 1], [1, 1, 1])
      r1 = MDArray.double([3, 3],
                          [0.3, 0.25, 0.25,
                           0.4, 0.45, 0.4,
                           0.3, 0.3, 0.35])
      
      p "matrix matrix"
      res = MDArray.double([3, 3])
      Blis.gemm_mvdot(1, @m1, @m1, 1, res)
      # assert_equal(true, r1.identical(res))
      res.pp
      r1.pp

      r2 = MDArray.double([4, 4],
                          [5, 2, 5, 2,
                           -2, 0, -2, 0,
                           3, 4, 3, 4, 
                           -1, 0, -1, 0])
      
      res = MDArray.double([4, 4])
      Blis.gemm_mvdot(1, @m2, @m3, 1, res)
      assert_equal(true, r2.identical(res))
      
      r3 = MDArray.double([3, 3],
                          [4, 8, 5, 
                           -2, 2, 1,
                           3, 3, 2])

      res = MDArray.double([3, 3])
      Blis.gemm_mvdot(1, @m3, @m2, 1, res)
      assert_equal(true, r3.identical(res))
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do matrix matrix multiplication based on axpy" do

      p "matrix matrix"
      res = MDArray.double([3, 3])
      Blis.gemm_mvaxpy(1, @m1, @m1, 1, res)
      res.pp

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do matrix matrix multiplication by row based on gemm_mvdot" do

      p "matrix matrix"
      res = MDArray.double([3, 3])
      Blis.gemm_vmdot(1, @m1, @m1, 1, res)
      res.pp

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do matrix matrix multiplication using rank-1 updates" do

      p "matrix matrix"
      res = MDArray.double([3, 3])
      Blis.gemm_ger(1, @m1, @m1, 1, res)
      res.pp
      
    end
    
  end
  
end
