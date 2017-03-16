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

class LaffMatrix < DoubleMDArray
  include_package "ucar.ma2"

  attr_accessor :nrows
  attr_accessor :ncolumns
  attr_reader :pfunction

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def initialize(shape, storage = nil, layout = :row)

    # Java-NetCDF creates an ArrayObject when given type string.  It should create an
    # ArrayString instead.  Some string methods in Java-NetCDF expect an ArrayObject
    # instead of an ArrayString, however, other libraries actually expect an ArrayString,
    # so we know have two type: "string" stores internally the data as an ArrayObject, 
    # "rstring" stores data internally as an ArrayString
    dtype = DataType::DOUBLE
    jshape = shape.to_java :int

    if (storage)
      jstorage = storage.to_java :double
      nc_array = Java::UcarMa2.Array.factory(dtype, jshape, jstorage)
    else
      nc_array = Java::UcarMa2.Array.factory(dtype, jshape)
    end

    super("double", nc_array)
    
    @nrows = shape[0]
    @ncolumns = shape[1]
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def partition_function=(name)
    @pfunction = method(name)
  end
  
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

require_relative 'util/partitions'
require_relative 'base/vecvec'
require_relative 'base/matrixvec'
