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
  # Returns four specific vectors from a Matrix based on an element of the Matrix.  The
  # first partition only has two vectors, the other two vectors are empty.
  #------------------------------------------------------------------------------------

  def part_by_four_vecs_lr_tb_first_part(filter: 0b1111, empty: EmptyArray.new(nil))

    part = []

    # first vector: top vector is empty
    ((filter & 0b1000) != 0) && part << empty

    # second vector: bottom vector
    ((filter & 0b0100) != 0) &&
      part << region(origin: [1, 0], size: [shape[0] - 1, 1], stride: [1, 1])

    # third vector: left vector is empty
    ((filter & 0b0010) != 0) && part << empty

    # fourth vector: right vector
    ((filter & 0b0001) != 0) &&
      part << region(origin: [0, 1], size: [1, shape[1] - 1], stride: [1, 1])

    part

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def part_by_four_vecs_lr_tb(part_size:, filter: 0b1111)

    part = []

    # first vector: top vector
    ((filter & 0b1000) != 0) &&
      part << region(origin: [0, part_size], size: [part_size, 1], stride: [1, 1])

    # second vector: bottom vector
    ((filter & 0b0100) != 0) &&
      part << region(origin: [part_size+1, part_size], size: [shape[0] - (part_size+1), 1],
                     stride: [1, 1])

    # third vector: left vector
    ((filter & 0b0010) != 0) && 
      part << region(origin: [part_size, 0], size: [1, part_size], stride: [1, 1])
    
    # fourth vector: right vector
    ((filter & 0b0001) != 0) &&
      part << region(origin: [part_size, part_size+1], size: [1, shape[1] - (part_size+1)],
                     stride: [1, 1])

    part
    
  end
  
  #------------------------------------------------------------------------------------
  # Returns four specific vectors from a Matrix based on an element of the Matrix.
  #------------------------------------------------------------------------------------

  def part_by_four_vecs_lr_tb_last_part(filter: 0b1111, empty: EmptyArray.new(nil))

    part = []
    part_size ||= shape.min - 1

    # first vector: top vector
    ((filter & 0b1000) != 0) &&
      part << region(origin: [0, part_size], size: [part_size, 1], stride: [1, 1])

    # second vector: bottom vector is empty
    ((filter & 0b0100) != 0) && part << empty

    # third vector: left vector
    ((filter & 0b0010) != 0) && 
      part << region(origin: [part_size, 0], size: [1, part_size], stride: [1, 1])
    
    # fourth vector: right vector is empty
    ((filter & 0b0001) != 0) && part << empty

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
                     size: [row_size, shape[1] - column_size],
                     stride: [1, 1])

    # third quadrant
    ((filter & 0b0010) != 0) &&
      part << region(origin: [row_size, 0],
                     size: [shape[0] - row_size, column_size],
                     stride: [1, 1])
    
    # fourth quadrant
    ((filter & 0b0001) != 0) &&
      part << region(origin: [row_size, column_size],
                     size: [shape[0] - row_size, shape[1] - column_size],
                     stride: [1, 1])

    part
    
  end

end
