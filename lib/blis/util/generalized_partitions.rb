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
  #
  #------------------------------------------------------------------------------------
  
  def part_by_six_lr_tb(part_size:, columni: part_size, filter: 0b111111)

    rowi = part_size
    rowi_next = rowi + 1
    columni_next = columni + 1
    
    part = []

    # first vector: single element where the partition is happening
    ((filter & 0b100000) != 0) &&
      part << region(origin: [rowi, columni], size: [1, 1], stride: [1, 1])

    # second vector: top vector
    ((filter & 0b010000) != 0) &&
      part << ((rowi == 0)? @empty : 
                 region(origin: [0, columni], size: [rowi, 1], stride: [1, 1]))

    # third vector: bottom vector
    ((filter & 0b001000) != 0) &&
      part << ((rowi == shape[0] - 1)? @empty :
                 region(origin: [rowi_next, columni], size: [shape[0] - rowi_next, 1],
                        stride: [1, 1]))
    
    # fourth vector: left vector
    ((filter & 0b000100) != 0) &&
      part << ((columni == 0)? @empty :
                 region(origin: [rowi, 0], size: [1, columni], stride: [1, 1]))

    # fifth vector: right vector
    ((filter & 0b000010) != 0) &&
      part << ((columni == shape[1] - 1)? @empty :
                 region(origin: [rowi, columni_next], size: [1, shape[1] - columni_next],
                        stride: [1, 1]))

    # sith vector: remaining of the array
    ((filter & 0b000001) != 0) &&
      part << ((rowi == shape[0] - 1 || columni == shape[1] - 1)? @empty :
                 region(origin: [rowi_next, columni_next],
                        size: [shape[0] - rowi_next, shape[1] - columni_next],
                        stride: [1, 1]))

    part
    
  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def part_by_six_rl_bt(part_size:, columni: shape[1] - 1 - part_size, filter: 0b111111)

    rowi = columni
    rowi_next = rowi + 1
    columni_next = columni + 1
    
    part = []

    # first vector: single element where the partition is happening
    ((filter & 0b100000) != 0) &&
      part << region(origin: [rowi, columni], size: [1, 1], stride: [1, 1])

    # second vector: top vector
    ((filter & 0b010000) != 0) &&
      part << ((rowi == 0)? @empty : 
                 region(origin: [0, columni], size: [rowi, 1], stride: [1, 1]))

    # third vector: bottom vector
    ((filter & 0b001000) != 0) &&
      part << ((rowi == shape[0] - 1)? @empty :
                 region(origin: [rowi_next, columni], size: [shape[0] - rowi_next, 1],
                        stride: [1, 1]))
    # fourth vector: left vector
    ((filter & 0b000100) != 0) &&
      part << ((columni == 0)? @empty :
                 region(origin: [rowi, 0], size: [1, columni], stride: [1, 1]))

    # fifth vector: right vector
    ((filter & 0b000010) != 0) &&
      part << ((columni == shape[1] - 1)? @empty :
                 region(origin: [rowi, columni_next], size: [1, shape[1] - columni_next],
                        stride: [1, 1]))

    # sith vector: remaining of the array
    ((filter & 0b000001) != 0) &&
      part << ((rowi == 0 || columni == 0)? @empty :
                 region(origin: [0, 0], size: [rowi, columni],
                        stride: [1, 1]))

    part
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def part_by_three_columns_tb(part_size:, filter: 0b111)

    part = []

    # first vector: single element where the partition is happening
    ((filter & 0b100) != 0) &&
      part << region(origin: [part_size, 0], size: [1, 1], stride: [1, 1])

    # second vector: top vector
    ((filter & 0b010) != 0) &&
      part << ((part_size == 0)? @empty : 
                 region(origin: [0, 0], size: [part_size, 1], stride: [1, 1]))

    # third vector: bottom vector
    ((filter & 0b001) != 0) &&
      part << ((part_size >= shape[0] - 1 )? @empty :
                 region(origin: [part_size + 1, 0], size: [shape[0] - (part_size + 1), 1],
                        stride: [1, 1]))

    part
    
  end
  
  #------------------------------------------------------------------------------------
  # Partitions an array in four quadrants left to right and top to bottom
  #------------------------------------------------------------------------------------

  def part_by_quadrant_lr_tb(rowi:, columni:, filter: 0b1111)

    part = []

    # first quadrant
    ((filter & 0b1000) != 0) &&
      part << region(origin: [0, 0], size: [rowi, columni], stride: [1, 1])

    # second quadrant
    ((filter & 0b0100) != 0) &&
      part << region(origin: [0, columni],
                     size: [rowi, shape[1] - columni],
                     stride: [1, 1])

    # third quadrant
    ((filter & 0b0010) != 0) &&
      part << region(origin: [rowi, 0],
                     size: [shape[0] - rowi, columni],
                     stride: [1, 1])
    
    # fourth quadrant
    ((filter & 0b0001) != 0) &&
      part << region(origin: [rowi, columni],
                     size: [shape[0] - rowi, shape[1] - columni],
                     stride: [1, 1])

    part
    
  end

end
