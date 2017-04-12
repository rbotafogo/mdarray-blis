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


module BlisMatrix

  #====================================================================================
  #
  #====================================================================================

  attr_reader :pfunction
  attr_reader :part_to
  attr_reader :empty
  attr_reader :blis_conjugate
  attr_reader :blis_uplo

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def part_by(type, row_dir: nil, column_dir: nil, filter: false)

    raise "Only rank 2 MDArray can be partitioned by part_by" if rank != 2
    
    # an array can only be partitioned in one way.  If we call part_by on one array and
    # then pass this array to another method that needs to part the array we need to
    # duplicate the array.
    if (@pfunction != nil)
      duplicate = self.dup
      duplicate.set_duplicate
      return duplicate.part_by(type, row_dir: row_dir, column_dir: column_dir, filter: filter)
      # return duplicate.enum_for(:each_part)
    end
    
    raise "Partition type unknown #{type}" if ((type != :column) && (type != :row) &&
                                               (type != :six) && (type != :quadrants) &&
                                               (type != :three_columns))
    raise "Wrong row direction #{row_dir}" if (row_dir != nil && row_dir != :lr &&
                                               row_dir != :rl)
    raise "Wrong column direction #{column_dir}" if (column_dir != nil &&
                                                     column_dir != :tb &&
                                                     column_dir != :bt)
    @empty = MDArray.double(nil)
    
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
    when :three_columns
      raise "Column direction should be either :tb or :bt" if (column_dir == nil ||
                                                               (column_dir != :tb &&
                                                                column_dir != :bt))
      direction = column_dir.to_s
      @part_to = shape[0]
      @filter = filter || 0b111111
    when :quadrants
      raise "Row direction should be either :lr or :rl" if (row_dir == nil || (row_dir != :lr &&
                                                                               row_dir != :rl))
      raise "Column direction should be either :tb or :bt" if (column_dir == nil ||
                                                               (column_dir != :tb &&
                                                                column_dir != :bt))
      direction = "#{row_dir.to_s}_#{column_dir.to_s}"
      @filter = filter || 0b1111
    when :six
      raise "Row direction should be either :lr or :rl" if (row_dir == nil || (row_dir != :lr &&
                                                                               row_dir != :rl))
      raise "Column direction should be either :tb or :bt" if (column_dir == nil ||
                                                               (column_dir != :tb &&
                                                                column_dir != :bt))
      direction = "#{row_dir.to_s}_#{column_dir.to_s}"
      @filter = filter || 0b111111
      @part_to = shape.min
    end

    @pfunction = method("part_by_#{type.to_s }_#{direction}".to_sym)

    enum_for(:each_part)
    
  end
  
  #------------------------------------------------------------------------------------
  # Gets every partition of a vector or matrix from 1 to n - 1
  #------------------------------------------------------------------------------------

  def each_part

    return enum_for(:each_part) unless block_given? # Sparkling magic!      

    # Executes all partitions
    (0..@part_to - 1).each do |part_size|
      yield *(@pfunction.call(part_size: part_size, filter: @filter))
    end

  end

  # private

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def set_duplicate
    @pfunction = nil
  end

  #------------------------------------------------------------------------------------
  # is stored in (and will be accessed only from) the lower triangle.
  #------------------------------------------------------------------------------------

  def set_lower
    @blis_uplo = :blis_lower
  end
  
  #------------------------------------------------------------------------------------
  # is stored in (and will be accessed only from) the upper triangle.
  #------------------------------------------------------------------------------------

  def set_upper
    @blis_uplo = :blis_upper
  end
  
  #------------------------------------------------------------------------------------
  # is stored as a full matrix (ie: in both triangles).
  #------------------------------------------------------------------------------------

  def set_dense
    @blis_uplo = :blis_dense
  end

end

class MDArray
  include BlisMatrix
end

require_relative 'util/simple_partitions'
require_relative 'util/generalized_partitions'

require_relative 'base/level-1v'
#require_relative 'base/level-1d'
#require_relative 'base/level-1m'
#require_relative 'base/level-1f'
require_relative 'base/level-2'
require_relative 'base/level-3'
