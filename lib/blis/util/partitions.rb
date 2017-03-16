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

class LaffMatrix

  #------------------------------------------------------------------------------------
  # Partitions m1 matrix by columns from left to right.  Assumes that all parameters
  # are correct and does not do any checking.  Assumes that @m1_rows and @m1_columns
  # have been properly set before calling this method.
  #------------------------------------------------------------------------------------
  
  def part_by_column_lr(part_size:, filter: 0b11)

    part = []

    # left part
    ((filter & 0b10) > 0) &&
      part << region(origin: [0, 0], size: [@nrows, part_size], stride: [1, 1])

    # right part
    ((filter & 0b01) > 0) &&
      part << region(origin: [0, part_size], size: [@nrows, @ncolumns-part_size],
                     stride: [1, 1])

    part
    
  end

  #------------------------------------------------------------------------------------
  # Partitions an array by columns from left to right.  Assumes that all parameters
  # are correct and does not do any checking.
  #------------------------------------------------------------------------------------

  def part_by_column_rl(part_size:, filter: 0b11)

    part = []

    # left part
    ((filter & 0b10) != 0) &&
      part << region(origin: [0, 0], size: [@nrows, @ncolumns - part_size],
                     stride: [1, 1])
    
    # right part
    ((filter & 0b01) != 0) &&
      part << region(origin: [0, @ncolumns - part_size],
                     size: [@nrows, part_size],
                     stride: [1, 1])
    
    part

  end

  #------------------------------------------------------------------------------------
  # Partitions an array by rows from top to bottom.  Assumes that all parameters
  # are correct and does not do any checking.
  #------------------------------------------------------------------------------------
  
  def part_by_row_tb(part_size:, filter: 0b11)

    part = []

    # top part
    ((filter & 0b10) != 0) &&
      part << region(origin: [0, 0], size: [part_size, @ncolumns], stride: [1, 1])

    # bottom part
    ((filter & 0b01) != 0) &&
      part << region(origin: [part_size, 0],
                     size: [@nrows - part_size, @ncolumns],
                     stride: [1, 1])
    
    part
    
  end

  #------------------------------------------------------------------------------------
  # Partitions an array by rows from bottom to top.  Assumes that all parameters
  # are correct and does not do any checking.
  #------------------------------------------------------------------------------------
  
  def part_by_row_bt(part_size:, filter: 0b11)

    part = []

    # top part
    ((filter & 0b10) != 0) &&
      part << region(origin: [0, 0],
                     size: [@nrows - part_size, @ncolumns],
                     stride: [1, 1])

    # bottom part
    ((filter & 0b01) != 0) &&
      part << region(origin: [@nrows - part_size, 0],
                     size: [part_size, @ncolumns],
                     stride: [1, 1])
    
    part
    
  end

  #------------------------------------------------------------------------------------
  # Partitions an array in four quadrants left to right and top to bottom
  #------------------------------------------------------------------------------------

  def part_4vec_lr_tb(pos:, filter: 0b1111, empty: EmptyArray.new(0))

    @rlimit ||= @nrows - 1
    @climit ||= @ncolumns - 1

    part = []

    # first vector
    ((filter & 0b1000) != 0) &&
      (pos == 0)? empty :
      part << region(origin: [0, pos], size: [pos, 1], stride: [1, 1])

    # second vector
    ((filter & 0b0100) != 0) &&
      (rows - 1 > pos)? empty : 
      part << region(origin: [pos+1, pos], size: [@nrows - (pos+1), 1],
                     stride: [1, 1])

    # third vector
    ((filter & 0b0010) != 0) && 
      part << region(origin: [pos, 0], size: [1, pos], stride: [1, 1])
    
    # fourth vector
    ((filter & 0b0001) != 0) &&
      part << region(origin: [pos, pos+1], size: [1, @ncolumns - (pos+1)],
                     stride: [1, 1])

    part
    
  end
  
  #------------------------------------------------------------------------------------
  # Partitions an array in four quadrants left to right and top to bottom
  #------------------------------------------------------------------------------------

  def part_by_quadrant_lr_tb(row_size:, column_size:, filter: 0b1111)

    part = []

    # first quadrant
    ((filter & 0b1000) != 0) &&
      part << region(origin: [0, 0], size: [row_size, column_size], stride: [1, 1])

    # second quadrant
    ((filter & 0b0100) != 0) &&
      part << region(origin: [0, column_size],
                     size: [row_size, @ncolumns - column_size],
                     stride: [1, 1])

    # third quadrant
    ((filter & 0b0010) != 0) &&
      part << region(origin: [row_size, 0],
                     size: [@nrows - row_size, column_size],
                     stride: [1, 1])
    
    # fourth quadrant
    ((filter & 0b0001) != 0) &&
      part << region(origin: [row_size, column_size],
                     size: [@nrows - row_size, @ncolumns - column_size],
                     stride: [1, 1])

    part
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def all_4vec_lr_tb(filter: 0b1111)

    # this is an m x n matrix
    @steps ||= shape.min

    (1..steps).each do |step|
      part = Laff.part_4vec_lr_tb(pos: step, filter: filter)
      yield part
    end
    
  end
  
  #------------------------------------------------------------------------------------
  # Partitions two arrays simultaneously
  #------------------------------------------------------------------------------------

  def part_synchronized(other, to:, filter1: 0b11, filter2: 0b11)

    (1..to).each do |part_size|
      part1 = @pfunction.call(part_size: part_size, filter: filter1)
      part2 = other.pfunction.call(part_size: part_size, filter: filter2)
      yield *part1, *part2
    end
    
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

end
