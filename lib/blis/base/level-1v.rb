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
  # y := y + conjx(x), where vecx and vecy are vectors of length m.
  #------------------------------------------------------------------------------------

  def self.addv(vecx, vecy)

  end

  #----------------------------------------------------------------------------------------
  # Find the element of vector x which contains the maximum absolute value. The index
  # of the element found is stored to index.
  # Note: This function attempts to mimic the algorithm for finding the element with the
  # maximum absolute value in the netlib BLAS routines i?amax().  
  #----------------------------------------------------------------------------------------

  def self.amaxv(vecx)

  end
  
  #------------------------------------------------------------------------------------
  # Does axpy operation between vectors.
  # vecy = alpha * vecx + vecy
  #------------------------------------------------------------------------------------

  def self.axpyv(alpha, vecx, vecy)

    # iterator fast will go through every element of the arrays in canonical order
    xi = MDArray::IteratorFastDouble.new(vecx)
    yi = MDArray::IteratorFastDouble.new(vecy)

    (0...vecx.shape.max).each do
      yi.set_current(alpha * xi.get_next + yi.get_next)
    end
    
  end

  #------------------------------------------------------------------------------------
  # Copies the content ov vec2 to vec1, destroying the value in vec1
  # param vec1 [MDArray] the vector to be overriden
  # param vec2 [MDArray] the vector to be copied
  #------------------------------------------------------------------------------------

  def self.copyv(vecx, vecy)
    
    # iterator fast will go through every element of the arrays in canonical order
    xi = MDArray::IteratorFastDouble.new(vecx)
    yi = MDArray::IteratorFastDouble.new(vecy)

    (0...vecx.shape.max).each do
      xi.set_next(yi.get_next)
    end
    
  end

  #------------------------------------------------------------------------------------
  # Performs a dotv operation between two vectors.  No error checking is done. Vectors
  # can be row or column vectors that no error will be issued.
  # @param vecx [MDArray] an MDArray configured as a vector: dimension [x, 1] or [1, x]
  # @param vecy [MDArray] an MDArray configured as a vector: dimension [1, x] or [x, 1]
  # @return rho [Numeric] a numeric value representing the dot product between
  # vecx and vecy
  #------------------------------------------------------------------------------------
  
  def self.dotv(vecx, vecy)

    xi = MDArray::IteratorFastDouble.new(vecx)
    yi = MDArray::IteratorFastDouble.new(vecy)

    rho = 0
    (0...vecx.shape.max).each do
      rho += xi.get_next * yi.get_next
    end
    rho
    
  end

  #------------------------------------------------------------------------------------
  # rho := beta * rho + alpha * conjx(x)^T * conjy(y)
  #------------------------------------------------------------------------------------

  def self.dotxv(alpha, vecx, vecy, beta, rho)

    xi = MDArray::IteratorFastDouble.new(vecx)
    yi = MDArray::IteratorFastDouble.new(vecy)

    dot = 0
    (0...vecx.shape.max).each do
      rho = beta * rho + alpha * xi.get_next * yi.get_next
    end
    rho
    
  end

  #------------------------------------------------------------------------------------
  # Invert all elements of an m-length vector x.
  #------------------------------------------------------------------------------------

  def self.invertv(vecx)

    xi = MDArray::IteratorFastDouble.new(vecx)
    
    (0...vecx.shape.max).each do
      xi.set_current(1/xi.get_next)
    end
    
  end
  
  #------------------------------------------------------------------------------------
  # y := alpha * conjx(x)
  #------------------------------------------------------------------------------------

  def self.scal2v(alpha, vecy, vecx)

    # iterator fast will go through every element of the arrays in canonical order
    xi = MDArray::IteratorFastDouble.new(vecx)
    yi = MDArray::IteratorFastDouble.new(vecy)

    (0...vecx.shape.max).each do
      yi.set_next(alpha * xi.get_next)
    end
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def self.scalv(alpha, vecx)
    
    # iterator fast will go through every element of the arrays in canonical order
    xi = MDArray::IteratorFastDouble.new(vecx)

    (0...vecx.shape.max).each do
      xi.set_current(alpha * xi.get_next)
    end

  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.setv(vecx, alpha)

    xi = MDArray::IteratorFastDouble.new(vecx)
    
    (0...vecx.shape.max).each do
      xi.set_next(alpha)
    end
    
  end

  #------------------------------------------------------------------------------------
  # y := y - conjx(x)
  #------------------------------------------------------------------------------------

  def self.subv(vecx, vecy)

  end
    
  #------------------------------------------------------------------------------------
  # Swap corresponding elements of two m-length vectors x and y.
  #------------------------------------------------------------------------------------

  def self.swapv(vecx, vecy)

  end
  
end
