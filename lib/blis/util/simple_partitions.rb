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

class MDArray
  
  #------------------------------------------------------------------------------------
  # Partitions the matrix by columns from left to right.  Assumes that all parameters
  # are correct and does not do any error checking.
  #------------------------------------------------------------------------------------
  
  def part_by_column_lr(part_size:, filter: 0b11)

    part = []

    # left part - A single column indexed as part_size with all elements of the column
    # from 0 to shape[0]
    ((filter & 0b10) > 0) &&
      part << region(origin: [0, part_size], size: [shape[0], 1], stride: [1, 1])      

    # right part - All columns from the right of the above column indexed from
    # part_size to shape[1] - part_size
    ((filter & 0b01) > 0) &&
      part << region(origin: [0, part_size + 1],
                     size: [shape[0], shape[1] - part_size - 1],
                     stride: [1, 1])

    part
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def part_by_column_lr_last(part_size:, filter: 0b11)

    part = []
    
    # left part - A single column indexed as part_size with all elements of the column
    # from 0 to shape[0]
    ((filter & 0b10) > 0) &&
      part << region(origin: [0, part_size], size: [shape[0], 1], stride: [1, 1])      

    ((filter & 0b01) != 0) && part << @empty

    part
    
  end

  #------------------------------------------------------------------------------------
  # Partitions an array by columns from left to right.  Assumes that all parameters
  # are correct and does not do any checking.
  #------------------------------------------------------------------------------------

  def part_by_column_rl(part_size:, filter: 0b11)

    part = []

    # left part - All columns to the left of the column indexed as shape[1] - part_size
    ((filter & 0b10) != 0) &&
      part << region(origin: [0, 0], size: [shape[0], shape[1] - part_size - 1],
                     stride: [1, 1])
    
    # right part - A single column indexed as shape[1] - part_size 
    ((filter & 0b01) != 0) &&
      part << region(origin: [0, shape[1] - part_size - 1], size: [shape[0], 1],
                     stride: [1, 1])
    
    part

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def part_by_column_rl_last(part_size:, filter: 0b11)

    part = []
    
    # left part - A single column indexed as part_size with all elements of the column
    # from 0 to shape[0]
    ((filter & 0b10) != 0) && part << @empty
    
    # right part - A single column indexed as shape[1] - part_size 
    ((filter & 0b01) != 0) &&
      part << region(origin: [0, shape[1] - part_size - 1], size: [shape[0], 1],
                     stride: [1, 1])

    part

  end

  #------------------------------------------------------------------------------------
  # Partitions an array by rows from top to bottom.  Assumes that all parameters
  # are correct and does not do any checking.
  #------------------------------------------------------------------------------------
  
  def part_by_row_tb(part_size:, filter: 0b11)

    part = []

    # top part - A single row indexed as part_size, with all the elements of the row
    # indexed from 0 to shape[1]
    ((filter & 0b10) != 0) &&
      part << region(origin: [part_size, 0], size: [1, shape[1]], stride: [1, 1])

    # bottom part - All remaining rows bellow the row indexed as part_size
    ((filter & 0b01) != 0) &&
      part << region(origin: [part_size + 1, 0],
                     size: [shape[0] - part_size - 1, shape[1]],
                     stride: [1, 1])
    
    part
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def part_by_row_tb_last(part_size:, filter: 0b11)

    part = []

    # top part - A single row indexed as part_size, with all the elements of the row
    # indexed from 0 to shape[1]
    ((filter & 0b10) != 0) &&
      part << region(origin: [part_size, 0], size: [1, shape[1]], stride: [1, 1])

    ((filter & 0b01) != 0) && part << @empty

    part
    
  end

  #------------------------------------------------------------------------------------
  # Partitions an array by rows from bottom to top.  Assumes that all parameters
  # are correct and does not do any checking.
  #------------------------------------------------------------------------------------
  
  def part_by_row_bt(part_size:, filter: 0b11)

    part = []

    # top part - All rows from the top to row indexed as part_size
    ((filter & 0b10) != 0) &&
      part << region(origin: [0, 0], size: [shape[0] - part_size - 1, shape[1]],
                     stride: [1, 1])

    # bottom part - A single row indexed as part_size
    ((filter & 0b01) != 0) &&
      part << region(origin: [shape[0] - part_size - 1, 0], size: [1, shape[1]],
                     stride: [1, 1])

    part
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def part_by_row_bt_last(part_size:, filter: 0b11)

    part = []

    # left part - A single column indexed as part_size with all elements of the column
    # from 0 to shape[0]
    ((filter & 0b10) != 0) && part << @empty
    
    # bottom part - A single row indexed as part_size
    ((filter & 0b01) != 0) &&
      part << region(origin: [shape[0] - part_size - 1, 0], size: [1, shape[1]],
                     stride: [1, 1])

    part

  end

end
