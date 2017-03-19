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


module LaffMatrix

  attr_reader :pfunction
  attr_reader :part_to

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def part_by(type, direction)
    case type
    when :column
      @part_to = shape[1]
      case direction
      when :lr
        @pfunction = method(:part_by_column_lr)
      when :rl
        @pfunction = method(:part_by_column_rl)
      else
        raise "Wrong direction #{direction}, should be either :lr or :rl"
      end
    when :row
      @part_to = shape[0]
      case direction
      when :tb
        @pfunction = method(:part_by_row_tb)
      when :bt
        @pfunction = method(:part_by_row_bt)
      else
        raise "Wrong direction #{direction}, should be either :tb or :bt"
      end
    end
    
  end
  
end

class MDArray
  include LaffMatrix

  #====================================================================================
  #
  #====================================================================================
  
  class EmptyArray
    
    attr_reader :default
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize(default)
      @default = default
    end
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def rank
      0
    end
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def size
      0
    end
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def pp
      ""
    end
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def [](*index)
      @default
    end
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def +(other)
      other
    end
    
  end

end

require_relative 'util/vec_partitions'
require_relative 'util/matrix_partitions'
require_relative 'base/vecvec'
require_relative 'base/matrixvec'
