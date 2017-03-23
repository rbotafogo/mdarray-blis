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

  context "LaffMatrix" do

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

    should "slice an array returning 4 vectors left/right, top/bottom" do

      p "first part"
      first_part = @matrix.part_by_four_vecs_lr_tb_first_part
      first_part[0].pp
      first_part[1].pp
      first_part[2].pp
      first_part[3].pp

      p "body part"
      part = @matrix.part_by_four_vecs_lr_tb(part_size: 2)
      part[0].pp
      part[1].pp
      part[2].pp
      part[3].pp

      p "last part"
      last_part = @matrix.part_by_four_vecs_lr_tb_last_part
      last_part[0].pp
      last_part[1].pp
      last_part[2].pp
      last_part[3].pp
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition the matrix in 4 vectors" do

      @matrix.part_by(:four_vecs, row_dir: :lr, column_dir: :tb)
      
      @matrix.each_part do |tl, tr, bl, br|
        p "==========================="
        tl.pp
        tr.pp
        bl.pp
        br.pp
      end

    end

  end
  
end
