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

#----------------------------------------------------------------------------------------
# This file contains level 1v operations, i.e., operations between two vectors.
#
# A vector is represented as an array with one
# of its dimensions of size 1. Ex: [5, 1], [7, 1], [1, 8]. The number of elements in the
# vector is the largest of it´s dimensions
#----------------------------------------------------------------------------------------

class Blis

  
  #------------------------------------------------------------------------------------
  # y := y + conjx(x), where vecx and vecy are vectors of length m.
  #------------------------------------------------------------------------------------

  def self.addv(vx, vy)

  end

  #----------------------------------------------------------------------------------------
  # Find the element of vector x which contains the maximum absolute value. The index
  # of the element found is stored to index.
  # Note: This function attempts to mimic the algorithm for finding the element with the
  # maximum absolute value in the netlib BLAS routines i?amax().  
  #----------------------------------------------------------------------------------------

  def self.amaxv(vx)

  end
  
  #------------------------------------------------------------------------------------
  # Does axpy operation between vectors. 
  # vy = alpha * vx + vy
  #------------------------------------------------------------------------------------

  def self.axpyv(alpha, vx, vy)

    # iterator fast will go through every element of the arrays in canonical order
    xi = MDArray::IteratorFastDouble.new(vx)
    yi = MDArray::IteratorFastDouble.new(vy)

    (0...vx.shape.max).each do
      yi.set_current(alpha * xi.get_next + yi.get_next)
    end
    vy
    
  end

  #------------------------------------------------------------------------------------
  # Copies the content ov vec2 to vec1, destroying the value in vec1
  # param vec1 [MDArray] the vector to be overriden
  # param vec2 [MDArray] the vector to be copied
  #------------------------------------------------------------------------------------

  def self.copyv(vx, vy)
    
    # iterator fast will go through every element of the arrays in canonical order
    xi = MDArray::IteratorFastDouble.new(vx)
    yi = MDArray::IteratorFastDouble.new(vy)

    (0...vx.shape.max).each do
      xi.set_next(yi.get_next)
    end
    vx
    
  end

  #------------------------------------------------------------------------------------
  # Performs a dotv operation between two vectors.  No error checking is done. Vectors
  # can be row or column vectors that no error will be issued.
  # @param vecx [MDArray] an MDArray configured as a vector: dimension [x, 1] or [1, x]
  # @param vecy [MDArray] an MDArray configured as a vector: dimension [1, x] or [x, 1]
  # @return rho [Numeric] a numeric value representing the dot product between
  # vecx and vecy
  #------------------------------------------------------------------------------------
  
  def self.dotv(vx, vy, rho = MDArray.double([1, 1]))

    xi = MDArray::IteratorFastDouble.new(vx)
    yi = MDArray::IteratorFastDouble.new(vy)

    temp = 0
    (0...vx.shape.max).each do
      temp += xi.get_next * yi.get_next
    end
    rho[0, 0] = temp
    
  end

  #------------------------------------------------------------------------------------
  # rho := beta * rho + alpha * conjx(x)^T * conjy(y)
  #------------------------------------------------------------------------------------

  def self.dotxv(alpha, vx, vy, beta, rho = MDArray.double([1, 1], [0]))

    xi = MDArray::IteratorFastDouble.new(vx)
    yi = MDArray::IteratorFastDouble.new(vy)

    (0...vx.shape.max).each do
      rho[0, 0] = beta * rho[0, 0] + alpha * xi.get_next * yi.get_next
    end
    rho[0, 0]
    
  end

  #------------------------------------------------------------------------------------
  # Invert all elements of an m-length vector x.
  #------------------------------------------------------------------------------------

  def self.invertv(vx)

    xi = MDArray::IteratorFastDouble.new(vx)
    
    (0...vx.shape.max).each do
      xi.set_current(1/xi.get_next)
    end
    vx
    
  end
  
  #------------------------------------------------------------------------------------
  # y := alpha * conjx(x)
  #------------------------------------------------------------------------------------

  def self.scal2v(alpha, vx, vy)

    # iterator fast will go through every element of the arrays in canonical order
    xi = MDArray::IteratorFastDouble.new(vx)
    yi = MDArray::IteratorFastDouble.new(vy)

    (0...vx.shape.max).each do
      yi.set_next(alpha * xi.get_next)
    end
    vy
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def self.scalv(alpha, vx)
    
    # iterator fast will go through every element of the arrays in canonical order
    xi = MDArray::IteratorFastDouble.new(vx)

    (0...vx.shape.max).each do
      xi.set_current(alpha * xi.get_next)
    end
    vx

  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.setv(vx, alpha)

    xi = MDArray::IteratorFastDouble.new(vx)
    
    (0...vx.shape.max).each do
      xi.set_next(alpha)
    end
    vx
    
  end

  #------------------------------------------------------------------------------------
  # y := y - conjx(x)
  #------------------------------------------------------------------------------------

  def self.subv(vx, vy)

  end
    
  #------------------------------------------------------------------------------------
  # Swap corresponding elements of two m-length vectors x and y.
  #------------------------------------------------------------------------------------

  def self.swapv(vx, vy)

  end
  
end
