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
  # Partitions m1 matrix by columns from left to right.  Assumes that all parameters
  # are correct and does not do any checking.  Assumes that @m1_rows and @m1_columns
  # have been properly set before calling this method.
  #------------------------------------------------------------------------------------
  
  def part_by_column_lr(part_size:, filter: 0b11)

    part = []

    # left part
    ((filter & 0b10) > 0) &&
      # part << region(origin: [0, 0], size: [shape[0], part_size], stride: [1, 1])
      part << region(origin: [0, part_size], size: [shape[0], 1], stride: [1, 1])      

    # right part
    ((filter & 0b01) > 0) &&
      part << region(origin: [0, part_size], size: [shape[0], shape[1]-part_size],
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
      part << region(origin: [0, 0], size: [shape[0], shape[1] - part_size],
                     stride: [1, 1])
    
    # right part
    ((filter & 0b01) != 0) &&
      part << region(origin: [0, shape[1] - part_size],
                     size: [shape[0], part_size],
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
      # part << region(origin: [0, 0], size: [part_size, shape[1]], stride: [1, 1])
      part << region(origin: [part_size, 0], size: [1, shape[1]], stride: [1, 1])

    # bottom part
    ((filter & 0b01) != 0) &&
      part << region(origin: [part_size, 0],
                     size: [shape[0] - part_size, shape[1]],
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
                     size: [shape[0] - part_size, shape[1]],
                     stride: [1, 1])

    # bottom part
    ((filter & 0b01) != 0) &&
      part << region(origin: [shape[0] - part_size, 0],
                     size: [part_size, shape[1]],
                     stride: [1, 1])
    
    part
    
  end

end
