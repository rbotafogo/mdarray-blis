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
require 'mdarray-laff'


class MDArrayTest < Test::Unit::TestCase

  context "Laff" do

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    setup do 

      # row vector
      @r_vec = LaffMatrix.new([1, 5], [2, -1, 4, 2, 1])
      # column vector
      @c_vec = LaffMatrix.new([5, 1], [1, -2, 2, 3, -1])
      
    end


    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do dot product between two vectors using Laff library (no error checking)" do

      assert_equal(17, Laff.dotv(@r_vec, @c_vec))
      # does not do any error checking, so a colum vector dot a row vector works fine.
      assert_equal(17, Laff.dotv(@c_vec, @r_vec))
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do dot product between two vectors using ruby interface" do

      assert_equal(17, @r_vec.dotv(@c_vec))

      # Will raise an error, since dotv expects a row vector as first operand
      assert_raise (RuntimeError) { @c_vec.dotv(@r_vec) }
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do axpy between two vectors using Laff library (no error checking)" do

      v1 = MDArray.double([5, 1], [2, -1, 4, 2, 1])
      v2 = MDArray.double([5, 1], [1, -2, 2, 3, -1])

      # do axpy creating a new vector
      Laff.axpy2v(-1, v1, v2).pp
      # now destroy the first vector with the result
      Laff.axpyv(-1, v1, v2)
      v1.pp
      
    end

  end

end
