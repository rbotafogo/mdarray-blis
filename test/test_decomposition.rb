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

      @b = MDArray.double([3, 3],
                          [1, -2, 2,
                           5, -15, 8,
                           -2, -11, -11])

      @c = MDArray.double([3, 3],
                          [-2, 1, 2,
                           4, -1, -5,
                           2, -3, -1])

      @d = MDArray.double([3, 3],
                          [-1, 2, -3,
                           -2, 2, -8,
                           2, -6, 6])
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "LU decompose a matrix" do
=begin
      MDArray::LinAlg.lu(@a)
      @a.pp

      MDArray::LinAlg.lu(@b)
      @b.pp

      MDArray::LinAlg.lu(@c)
      @c.pp

      b = MDArray.double([3, 1], [0, 4, -6])
      MDArray::LinAlg.forward_solve(@c, b)
      b.pp

      p "d"
      MDArray::LinAlg.lu(@d)
      @d.pp

      b = MDArray.double([3, 1], [2, 10, -2])
      MDArray::LinAlg.forward_solve(@d, b)
      b.pp
=end

      MDArray::LinAlg.lu(@c)
      @c.pp

      b = MDArray.double([3, 1], [2, 10, -2])
      MDArray::LinAlg.back_substitution(@c, b)
      
    end
    
  end

end
