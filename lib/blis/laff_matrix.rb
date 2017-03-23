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
  attr_reader :first_part
  attr_reader :last_part

  attr_reader :part_to
  attr_reader :all_values

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def part_by(type, row_dir: nil, column_dir: nil, filter: false)

    raise "Partition type unknown #{type}" if ((type != :column) && (type != :row) &&
                                               (type != :four_vecs) && (type != :quadrants))
    raise "Wrong row direction #{row_dir}" if (row_dir != nil && row_dir != :lr &&
                                               row_dir != :rl)
    raise "Wrong column direction #{column_dir}" if (column_dir != nil &&
                                                     column_dir != :tb &&
                                                     column_dir != :bt)
    case type
    when :column
      raise "Direction should be either :lr or :rl" if (row_dir == nil || (row_dir != :lr &&
                                                                           row_dir != :rl))
      direction = row_dir.to_s
      @part_to = shape[1]
      @filter = filter || 0b11
    when :row
      raise "Direction should be either :tb or :bt" if (column_dir == nil ||
                                                        (column_dir != :tb &&
                                                         column_dir != :bt))
      direction = column_dir.to_s
      @part_to = shape[0]
      @filter = filter || 0b11
    when :four_vecs || :quadrants
      raise "Row direction should be either :lr or :rl" if (row_dir == nil || (row_dir != :lr &&
                                                                               row_dir != :rl))
      raise "Column direction should be either :tb or :bt" if (column_dir == nil ||
                                                               (column_dir != :tb &&
                                                                column_dir != :bt))
      direction = "#{row_dir.to_s}_#{column_dir.to_s}"
      @part_to = shape.min - 1
      @filter = filter || 0b1111
    end

    @pfunction = method("part_by_#{type.to_s }_#{direction}".to_sym)
    
  end
  
  #------------------------------------------------------------------------------------
  # Gets every partition of a vector or matrix from 1 to n - 1
  #------------------------------------------------------------------------------------

  def each_part

    return enum_for(:each_part) unless block_given? # Sparkling magic!      

    (0..@part_to - 1).each do |part_size|
      yield *(@pfunction.call(part_size: part_size, filter: @filter))
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
require_relative 'base/matvec'


=begin  
  #------------------------------------------------------------------------------------
  # Partitions two arrays simultaneously.  Use 
  #------------------------------------------------------------------------------------

  def part_synchronized(other, filter1: @all_values, filter2: @all_values)

    (1..@part_to - 1).each do |part_size|
      part1 = @pfunction.call(part_size: part_size, filter: filter1)
      part2 = other.pfunction.call(part_size: part_size, filter: filter2)
      yield *part1, *part2
      
    end
    
  end
=end
