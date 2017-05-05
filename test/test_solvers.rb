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

  context "LinAlg" do

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    setup do
      
      @a = MDArray.double([4, 4],
                          [2, 0, 1, 2,
                           -2, -1, 1, -1,
                           4, -1, 5, 4,
                           -4, 1, -3, -8])

      @b = MDArray.double([4, 1], [2, 10, -2, 5])

      
      @c = MDArray.double([4, 4],
                          [2, 0, 1, 2,
                           -2, -1, 1, -1,
                           4, -1, 5, 4,
                           -4, 1, -3, -8])

      @b_orig = MDArray.double([4, 1], [2, 10, -2, 5])
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "forward solve an equation " do

      # perform LU factorization of a
      MDArray::LinAlg.lu(@a)

      a_b = MDArray.double([4, 1], [2, 12, -18, 39])
      back_sub = MDArray.double([4, 1], [39.25, -106.5, -37.5, -19.5])

      MDArray::LinAlg.forward_solve(@a, @b)
      assert_equal(true, a_b.identical(@b))

      MDArray::LinAlg.back_substitution(@a, @b)
      assert_equal(true, back_sub.identical(@b))

      vy = MDArray.double([4, 1])
      # def self.gemv_dot(alpha, mA, vx, beta, vy)
      Blis.gemv_dot(1, @c, @b, 1, vy)
      assert_equal(true, @b_orig.identical(vy))

    end
    
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "solve an equation " do

      MDArray::LinAlg.back_substitution(
        @a, MDArray::LinAlg.forward_solve(
          MDArray::LinAlg.lu(@a), @b))

    end
    
  end

end
