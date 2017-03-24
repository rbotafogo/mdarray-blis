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
require 'mdarray-laff'


class MDArrayLaffTest < Test::Unit::TestCase

  context "Blis" do

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    setup do 

      # a vector is an MDArray with one of it´s dimension equal to 1
      # this is a row vector with 4 rows and 1 column
      @r_vec = MDArray.double([1, 4], [1, 2, 3, 4])
      @r_vec2 = MDArray.double([1, 4], [1, 2, 3, 5])
      @c_vec = MDArray.double([4, 1], [1, 2, 3, 4])
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition a vector by rows top to bottom" do

      at, ab = @c_vec.part_by_row_tb(part_size: 0)
      assert_equal(true, MDArray.double([1, 1], [1]).identical(at))
      assert_equal(true, MDArray.double([3, 1], [2, 3, 4]).identical(ab))

      # partitions the array with the top part with 1 row and the bottom part
      # with the rest of the rows
      # al, ar = Laff.part_by_row_tb
      at, ab = @c_vec.part_by_row_tb(part_size: 1)
      assert_equal(true, MDArray.double([1, 1], [2]).identical(at))
      assert_equal(true, MDArray.double([2, 1], [3, 4]).identical(ab))

      # filter the results returning only the right vector
      ret = @c_vec.part_by_row_tb(part_size: 2, filter: 0b01)
      assert_equal(true, MDArray.double([1, 1], [4]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = @c_vec.part_by_row_tb(part_size: 2, filter: 0b10)
      assert_equal(true, MDArray.double([1, 1], [3]).identical(ret[0]))

      # filter the results returning only the top vector
      ret = @c_vec.part_by_row_tb(part_size: 3, filter: 0b10)
      assert_equal(true, MDArray.double([1, 1], [4]).identical(ret[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition a vector by rows bottom to top" do

      at, ab = @c_vec.part_by_row_bt(part_size: 0)
      assert_equal(true, MDArray.double([3, 1], [1, 2, 3]).identical(at))
      assert_equal(true, MDArray.double([1, 1], [4]).identical(ab))

      # partitions the array with the left part with 2 columns and the right part
      # with the rest of the columns
      # al, ar = Laff.part_by_row_bt
      at, ab = @c_vec.part_by_row_bt(part_size: 1)
      assert_equal(true, MDArray.double([2, 1], [1, 2]).identical(at))
      assert_equal(true, MDArray.double([1, 1], [3]).identical(ab))

      # filter the results returning only the bottom vector
      ret = @c_vec.part_by_row_bt(part_size: 2, filter: 0b01)
      assert_equal(true, MDArray.double([1, 1], [2]).identical(ret[0]))

      # filter the results returning only the top vector
      ret = @c_vec.part_by_row_bt(part_size: 2, filter: 0b10)
      assert_equal(true, MDArray.double([1, 1], [1]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = @c_vec.part_by_row_bt(part_size: 3, filter: 0b01)
      assert_equal(true, MDArray.double([1, 1], [1]).identical(ret[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition a vector by columns left to right" do

      al, ar = @r_vec.part_by_column_lr(part_size: 0)
      assert_equal(true, MDArray.double([1, 1],[1]).identical(al))
      assert_equal(true, MDArray.double([1, 3], [2, 3, 4]).identical(ar))

      # partitions the array with the left part with 2 columns and the right part
      # with the rest of the columns
      # al, ar = Laff.part_by_column_lr
      al, ar = @r_vec.part_by_column_lr(part_size: 1)
      assert_equal(true, MDArray.double([1, 1],[2]).identical(al))
      assert_equal(true, MDArray.double([1, 2], [3, 4]).identical(ar))

      # filter the results returning only the right vector
      ret = @r_vec.part_by_column_lr(part_size: 2, filter: 0b01)
      assert_equal(true, MDArray.double([1, 1], [4]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = @r_vec.part_by_column_lr(part_size: 2, filter: 0b10)
      assert_equal(true, MDArray.double([1, 1], [3]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = @r_vec.part_by_column_lr(part_size: 3, filter: 0b10)
      assert_equal(true, MDArray.double([1, 1], [4]).identical(ret[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition a vector by columns right to left" do

      # partitions the array with the left part with 2 columns and the right part
      # with the rest of the columns
      # al, ar = Laff.part_by_column_rl
      al, ar = @r_vec.part_by_column_rl(part_size: 0)
      assert_equal(true, MDArray.double([1, 3], [1, 2, 3]).identical(al))
      assert_equal(true, MDArray.double([1, 1], [4]).identical(ar))

      # partitions the array with the left part with 2 columns and the right part
      # with the rest of the columns
      # al, ar = Laff.part_by_column_rl
      al, ar = @r_vec.part_by_column_rl(part_size: 1)
      assert_equal(true, MDArray.double([1, 2], [1, 2]).identical(al))
      assert_equal(true, MDArray.double([1, 1], [3]).identical(ar))

      # filter the results returning only the right vector
      ret = @r_vec.part_by_column_rl(part_size: 2, filter: 0b01)

      assert_equal(true, MDArray.double([1, 1], [2]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = @r_vec.part_by_column_rl(part_size: 2, filter: 0b10)
      assert_equal(true, MDArray.double([1, 1], [1]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = @r_vec.part_by_column_rl(part_size: 3, filter: 0b01)
      assert_equal(true, MDArray.double([1, 1], [1]).identical(ret[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition an array by columns left to right" do
    
      array = MDArray.double([2, 3], [1, 2, 3, 4, 5, 6])

      al, ar = array.part_by_column_lr(part_size: 0)
      assert_equal(true, MDArray.double([2, 1], [1, 4]).identical(al))
      assert_equal(true, MDArray.double([2, 2], [2, 3, 5, 6]).identical(ar))

      al, ar = array.part_by_column_lr(part_size: 1)
      assert_equal(true, MDArray.double([2, 1], [2, 5]).identical(al))
      assert_equal(true, MDArray.double([2, 1], [3, 6]).identical(ar))

      # get only the left side.  The returned value is an array of size 1
      al = array.part_by_column_lr(part_size: 1, filter: 0b10)
      assert_equal(true, MDArray.double([2, 1], [2, 5]).identical(al[0]))

      # get only the right side.  The returned value is an array of size 1
      ar = array.part_by_column_lr(part_size: 2, filter: 0b10)
      assert_equal(true, MDArray.double([2, 1], [3, 6]).identical(ar[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition an array by columns right to left" do
    
      array = MDArray.double([2, 3], [1, 2, 3, 4, 5, 6])

      al, ar = array.part_by_column_rl(part_size: 0)
      assert_equal(true, MDArray.double([2, 2], [1, 2, 4, 5]).identical(al))
      assert_equal(true, MDArray.double([2, 1], [3, 6]).identical(ar))

      al, ar = array.part_by_column_rl(part_size: 1)
      assert_equal(true, MDArray.double([2, 1], [1, 4]).identical(al))
      assert_equal(true, MDArray.double([2, 1], [2, 5]).identical(ar))

      # get only the left side.  The returned value is an array of size 1
      al = array.part_by_column_rl(part_size: 1, filter: 0b10)
      assert_equal(true, MDArray.double([2, 1], [1, 4]).identical(al[0]))

      # get only the right side.  The returned value is an array of size 1
      ar = array.part_by_column_rl(part_size: 2, filter: 0b01)
      assert_equal(true, MDArray.double([2, 1], [1, 4]).identical(ar[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "get every partition from a vector" do

      @r_vec.part_by(:column, row_dir: :lr)
      i = 0
      partitions = []
      @r_vec.each_part do |left, right|
        partitions[i] = [left, right]
        i += 1
      end

      assert_equal(true, MDArray.double([1,1], [1]).identical(partitions[0][0]))
      assert_equal(true, MDArray.double([1,3], [2, 3, 4]).identical(partitions[0][1]))
      
      # Last partition is the EmptyArray
      assert_equal(true, partitions[i-1][1].empty?)

      @c_vec.part_by(:row, column_dir: :bt)
      @c_vec.each_part do |top, bottom|
        p "===== new partition ====="
        top.pp
        bottom.pp
      end      
      
    end
=begin 
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------
    
    should "get every partition from a vector as enumerator" do

      p "=================enumerator====================="
      @r_vec.part_by(:column, row_dir: :lr)
      
      part = @r_vec.each_part
      left, right = part.next
      left.pp
      right.pp

      left, right = part.next
      left.pp
      right.pp
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition two vectors synchronized" do

      # @r_vec = MDArray.double([1, 4], [1, 2, 3, 4])
      # @c_vec = MDArray.double([4, 1], [1, 2, 3, 4])

      # partition the row vector from left to right
      @r_vec.part_by(:column, row_dir: :lr)
      
      # partition the column vector from top to bottom
      @c_vec.part_by(:row, column_dir: :tb)

      p "==============partition synchronized==========="

      rvec = @r_vec.each_part
      cvec = @c_vec.each_part

      loop do
        rl, rr = rvec.next
        ct, cb = cvec.next
        rl.pp
        rr.pp
        ct.pp
        cb.pp
      end
      

      # call part_synchronized until the number of columns minus one of the row vec
      @r_vec.part_synchronized(@c_vec) do |vec1_l, vec1_r, vec2_t, vec2_b|
        p "======================"
        vec1_l.pp
        vec1_r.pp
        vec2_t.pp
        vec2_b.pp
      end

      @r_vec.part_synchronized(@c_vec,
                               filter1: 0b01,
                               filter2: 0b01) do |vec1_r, vec2_b|
        p "======== filtered ========"
        vec1_r.pp
        vec2_b.pp
      end

    end

=end

  end
  
end
