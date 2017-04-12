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


class LaffMatrixTest < Test::Unit::TestCase

  context "Blis" do

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    setup do 

      # a vector is an MDArray with one of it´s dimension equal to 1
      # this is a row vector with 4 rows and 1 column
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
      
      @u = MDArray.double([5, 5],
                          [-1, 2, 4, 1, 0,
                           0, 0, -1, -2, 1,
                           0, 0, 3, 1, 2,
                           0, 0, 0, 4, 3,
                           0, 0, 0, 0, 2])

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition an array by columns from left to right" do

      @matrix.part_by(:column, row_dir: :lr)
      
      @matrix.each_part do |left, right|
        p "new partition============"
        left.pp
        right.pp
      end
      
    end
    
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition an array by rows from top to bottom" do

      @matrix.part_by(:row, column_dir: :tb)
      
      @matrix.each_part do |top, bottom|
        p "new partition============"
        top.pp
        bottom.pp
      end
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------
=begin
    should "part generalized" do

      @m2.empty = MDArray::EmptyArray.new(0)
      part = @m2.part_by_six_lr_tb(rowi: 4, columni: 4)
      
      part[0].pp
      part[1].pp
      part[2].pp
      part[3].pp
      part[4].pp
      part[5].pp

      vpart = @vec.part_by_three_columns_tb(rowi: 2)
      vpart[0].pp
      vpart[1].pp
      vpart[2].pp
      
      
    end
=end    
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------
=begin
    should "slice an array returning 5 vectors left/right, top/bottom" do

      @matrix.pp
      
      @matrix.part_by(:five_vecs, row_dir: :lr, column_dir: :tb)
      
      fp = @matrix.part_by_five_vecs_lr_tb_first
      fp[0].pp
      fp[1].pp
      fp[2].pp
      fp[3].pp
      fp[4].pp

      p "part_size: 1"
      fp = @matrix.part_by_five_vecs_lr_tb(part_size: 1)
      fp[0].pp
      fp[1].pp
      fp[2].pp
      fp[3].pp
      fp[4].pp

      p "part_size: 2"
      fp = @matrix.part_by_five_vecs_lr_tb(part_size: 2)
      fp[0].pp
      fp[1].pp
      fp[2].pp
      fp[3].pp
      fp[4].pp
      
      p "part_size: last"
      fp = @matrix.part_by_five_vecs_lr_tb_last(part_size: 3)
      fp[0].pp
      fp[1].pp
      fp[2].pp
      fp[3].pp
      fp[4].pp

    end
       
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition the matrix in 5 vectors" do

      @matrix.part_by(:five_vecs, row_dir: :lr, column_dir: :tb)
      
      @matrix.each_part do |elmt, tl, tr, bl, br|
        p "==========================="
        elmt.pp
        tl.pp
        tr.pp
        bl.pp
        br.pp
      end

    end
    
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "implement dot product with different algo" do

      @m2.part_by(:five_vecs, row_dir: :lr, column_dir: :tb, filter: 0b10011)
      @vec.part_by(:row, column_dir: :tb)

      mpart = @m2.each_part
      vpart = @vec.each_part
      
      loop do
        p "======= elements for multiply======"
        melmt, left, right = mpart.next
        top, bottom = vpart.next
        p "first"
        melmt.pp
        top.pp
        p "second"
        left.pp
        right.pp
        bottom.pp
      end

      
    end
=end    

  end
  
end
