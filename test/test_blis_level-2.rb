# -*- coding: utf-8 -*-

##########################################################################################
# Copyright © 2016 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
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


class BlisMatrixTest < Test::Unit::TestCase

  context "Blis" do

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    setup do 

      @matrix = MDArray.double([4, 4],
                               [1, 2, 3, 4,
                                5, 6, 7, 8,
                                9, 10,11, 12,
                                13, 14, 15, 16])

      @m2 = MDArray.double([5, 5],
                           [1, -1, 3, 2, -2,
                            2, -2, 1, 0, -1,
                            0, -4, 3, 2, 1,
                            3, 1, -2, 1, 0,
                            -1, 2, 1, -1, -2])
      
      @vec = MDArray.double([5, 1], [-1, 0, 2, -1, 1])

      # upper triangular matrix
      @u = MDArray.double([5, 5],
                          [-1, 2, 4, 1, 0,
                           0, 0, -1, -2, 1,
                           0, 0, 3, 1, 2,
                           0, 0, 0, 4, 3,
                           0, 0, 0, 0, 2])

      @uvec = MDArray.double([5, 1], [1, 2, 3, 4, 5])
      @r_vec = MDArray.double([1, 5], [1, 2, 3, 4, 5])
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do outer product between two vectors" do

      outer = MDArray.double([5, 5])
      res = MDArray.double([5, 5],
                           [1.00, 2.00, 3.00, 4.00, 5.00,
                            2.00, 4.00, 6.00, 8.00, 10.00,
                            3.00, 6.00, 9.00, 12.00, 15.00,
                            4.00, 8.00, 12.00, 16.00, 20.00,
                            5.00, 10.00, 15.00, 20.00, 25.00])
      
      Blis.ger(1, outer, @uvec, @r_vec)
      assert_equal(true, res.identical(outer))
      
    end
    

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "multiply matrix by vector" do

      yvec = MDArray.double([5, 1])
      zvec = MDArray.double([5, 1])
      wvec = MDArray.double([5, 1])
      kvec = MDArray.double([5, 1])

      res = MDArray.double([5, 1],
                           [1.00, -1.00, 5.00, -8.00, 2.00])

      Blis.gemv_dot(1, @m2, @vec, 1, zvec)
      assert_equal(true, res.identical(zvec))
      
      Blis.gemv_axpy(1, @m2, @vec, 1, kvec)
      assert_equal(true, res.identical(kvec))

      Blis.gemv_6part_dot(1, @m2, @vec, 1, yvec)
      assert_equal(true, res.identical(yvec))

      Blis.gemv_6part_axpy(1, @m2, @vec, 1, wvec)
      assert_equal(true, res.identical(wvec))
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "multiply transpose matrix by vector" do

      zvec = MDArray.double([5, 1])
      kvec = MDArray.double([5, 1])

      res = MDArray.double([5, 1],
                           [-5.00, -6.00, 6.00, 0.00, 2.00])

      Blis.getmv_dot(1, @m2, @vec, 1, zvec)
      assert_equal(true, res.identical(zvec))

      Blis.getmv_axpy(1, @m2, @vec, 1, kvec)
      assert_equal(true, res.identical(kvec))
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "multiply upper triangular matrix by vector" do

      yvec = MDArray.double([5, 1])
      zvec = MDArray.double([5, 1])

      p "upper triangular matrix multiply"
      Blis.gemv_6part_dot(1, @u, @uvec, 1, yvec)
      yvec.pp
      
      Blis.geutriangmv_6part_dot(1, @u, @uvec, 1, zvec)
      zvec.pp

    end

  end
  
end


=begin

      p "square a matrix"
      t = MDArray.double([5, 5])
      Blis.gemm_dot(t, @m2, @m2)
      t.pp

      mt = MDMatrix.from_mdarray(@m2)
      mt.print
      res = mt.mult(mt)
      res.print 
=end      
