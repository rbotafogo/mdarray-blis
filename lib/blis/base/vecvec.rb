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

class Blis
  
  #------------------------------------------------------------------------------------
  # Does axpy operation between vectors.
  # vec2 = alfa * vec1 + vec2
  #------------------------------------------------------------------------------------

  def self.axpyv(alfa, vec1, vec2)

    # iterator fast will go through every element of the arrays in canonical order
    i1 = MDArray::IteratorFastDouble.new(vec1)
    i2 = MDArray::IteratorFastDouble.new(vec2)

    while(i1.has_next?)
      i2.set_current(alfa * i1.get_next + i2.get_next)
    end
    
  end

  #------------------------------------------------------------------------------------
  # Does axpy operation between vectors non-destructively.  This is not part (I think)
  # of the blis framework
  #------------------------------------------------------------------------------------

  def self.axpy2v(alfa, vec1, vec2)

    # create a new vector to store the result, with the proper shape and fill it
    # with 0 initially
    # axpy = MDArray.init_with(:double, vec1.shape, 0)
    # By default, every array is filled with 0, so there is no need to explicitly
    # initialize it as above
    axpy = MDArray.double(vec1.shape)

    # iterator fast will go through every element of the arrays in canonical order
    itf = MDArray::IteratorFastDouble.new(axpy)
    i1 = MDArray::IteratorFastDouble.new(vec1)
    i2 = MDArray::IteratorFastDouble.new(vec2)

    while(i1.has_next?)
      itf.set_next(alfa * i1.get_next + i2.get_next)
    end
    axpy
    
  end

  #------------------------------------------------------------------------------------
  # Copies the content ov vec2 to vec1, destroying the value in vec1
  # param vec1 [MDArray] the vector to be overriden
  # param vec2 [MDArray] the vector to be copied
  #------------------------------------------------------------------------------------

  def self.copyv(vec1, vec2)
    
    # iterator fast will go through every element of the arrays in canonical order
    i1 = MDArray::IteratorFastDouble.new(vec1)
    i2 = MDArray::IteratorFastDouble.new(vec2)

    while(i1.has_next?)
      i1.set_next(i2.get_next)
    end
    
  end

  #------------------------------------------------------------------------------------
  # Performs a dotv operation between two vectors.  No error checking is done. Vectors
  # can be row or column vectors that no error will be issued.
  # @param r_vec [MDArray] an MDArray configured as a vector: dimension [x, 1] or [1, x]
  # @param c_vec [MDArray] an MDArray configured as a vector: dimension [1, x] or [x, 1]
  # @return number [Numeric] a numeric value representing the dot product between
  # r_vec and c_vec
  #------------------------------------------------------------------------------------
  
  def self.dotv(r_vec, c_vec)

    r_iterator = MDArray::IteratorFastDouble.new(r_vec)
    c_iterator = MDArray::IteratorFastDouble.new(c_vec)

    dot = 0
    while(r_iterator.has_next?)
      dot += r_iterator.get_next * c_iterator.get_next
    end
    dot
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.invertv(vec)

    iterator = MDArray::IteratorFastDouble.new(vec)
    
    while(iterator.has_next?)
      iterator.set_current(1/iterator.get_next)
    end
    
  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.setv(vec, alfa)

    iterator = MDArray::IteratorFastDouble.new(vec)
    
    while(iterator.has_next?)
      iterator.set_next(alfa)
    end
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def self.scalv(alfa, vec)
    
    # iterator fast will go through every element of the arrays in canonical order
    i1 = MDArray::IteratorFastDouble.new(vec)

    while(i1.has_next?)
      i1.set_current(alfa * i1.get_next)
    end

  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.scal2v(alfa, vec)

    # create a new vector to store the result, with the proper shape and fill it
    # with 0 initially
    # axpy = MDArray.init_with(:double, vec1.shape, 0)
    # By default, every array is filled with 0, so there is no need to explicitly
    # initialize it as above
    scal2v = MDArray.double(vec.shape)

    # iterator fast will go through every element of the arrays in canonical order
    iterator = MDArray::IteratorFastDouble.new(vec)
    i2 = MDArray::IteratorFastDouble.new(scal2v)

    while(iterator.has_next?)
      i2.set_next(alfa * iterator.get_next)
    end
    scal2v
    
  end
  
end
