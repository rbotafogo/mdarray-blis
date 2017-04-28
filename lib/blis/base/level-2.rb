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
  # A := A + alpha * conjx(x) * conjy(y)^T
  #------------------------------------------------------------------------------------

  def self.ger(alpha, a, vecx, vecy)

    apart = a.part_by(:row, column_dir: :tb, filter: 0b10)
    xi = MDArray::IteratorFastDouble.new(vecx)
    
    loop do
      # If we put mpart.next inside scal2v, ruby throws an exception since xi.next
      # will be called before mpart.next and on the last call xi.next is out of bounds
      # xin = alpha * xi.next
      top = apart.next
      Blis.axpyv(alpha * xi.next, vecy, top)
    end

  end
  
  
  #------------------------------------------------------------------------------------
  # Generalized matrix vector multiply using dotv
  # y := beta*y + alfa*Ax
  # @param alpha [Number]
  # @param matrix [MDArray] the matrix tha multiplies the vector
  # @param vecx [MDArray] the vector that multiplies the matrix
  # @param beta [Number] number that multiplies vector y
  # @param vecy [MDArray] vector y where the result is stored
  #------------------------------------------------------------------------------------

  def self.gemv_dot(alpha, matrix, vecx, beta, vecy)

    mpart = matrix.part_by(:row, column_dir: :tb, filter: 0b10)
    ypart = vecy.part_by(:row, column_dir: :tb, filter: 0b10)

    loop do
      top = mpart.next
      elmt = ypart.next
      elmt[0, 0] = beta * elmt[0, 0] + alpha * Blis.dotv(top, vecx)
    end

  end

  #------------------------------------------------------------------------------------
  # Generalized transpose matrix vector multiply using dotv
  # y := beta*y + alfa*Ax
  #------------------------------------------------------------------------------------

  def self.getmv_dot(alpha, matrix, vecx, beta, vecy)
    
    mpart = matrix.part_by(:column, row_dir: :lr, filter: 0b10)
    ypart = vecy.part_by(:row, column_dir: :tb, filter: 0b10)

    loop do
      left = mpart.next
      elmt = ypart.next
      elmt[0, 0] = beta * elmt[0, 0] + alpha * Blis.dotv(left, vecx)
    end

  end
  
  #------------------------------------------------------------------------------------
  # Generalized matrix vector multiply using axpy
  # y := beta*y + alfa*Ax
  #------------------------------------------------------------------------------------

  def self.gemv_axpy(alpha, matrix, vecx, beta, vecy)

    mpart = matrix.part_by(:column, row_dir: :lr, filter: 0b10)
    xpart = vecx.part_by(:row, column_dir: :tb, filter: 0b10)

    loop do
      left = mpart.next
      xscalar = xpart.next
      Blis.axpyv(xscalar[0, 0], left, vecy)
    end

  end

  #------------------------------------------------------------------------------------
  # Generalized transpose matrix vector multiply using axpy
  # y := beta*y + alfa*Ax
  #------------------------------------------------------------------------------------

  def self.getmv_axpy(alpha, matrix, vecx, beta, vecy)

    mpart = matrix.part_by(:row, column_dir: :tb, filter: 0b10)
    xpart = vecx.part_by(:row, column_dir: :tb, filter: 0b10)

    loop do
      top = mpart.next
      xscalar = xpart.next
      Blis.axpyv(xscalar[0, 0], top, vecy)
    end

  end

  #------------------------------------------------------------------------------------
  # Generalized matrix vector multiply using 6 partitioning
  # y := beta*y + alfa*Ax
  #------------------------------------------------------------------------------------

  def self.gemv_6part_dot(alpha, matrix, vecx, beta, vecy)

    mpart = matrix.part_by(:six, row_dir: :lr, column_dir: :tb, filter: 0b100110)
    xpart = vecx.part_by(:three_columns, column_dir: :tb)
    ypart = vecy.part_by(:three_columns, column_dir: :tb, filter: 0b100)

    loop do
      mscalar, mleft, mright = mpart.next
      xscalar, xtop, xbottom = xpart.next
      yscalar = ypart.next

      yscalar[0, 0] = beta * yscalar[0, 0] +
                      alpha * (Blis.dotv(mleft, xtop) +
                               mscalar[0, 0] * xscalar[0, 0] +
                               Blis.dotv(mright, xbottom))
      
    end 

  end
  
  #------------------------------------------------------------------------------------
  # Generalized matrix vector multiply using 6 partitioning, based on axpy method
  # y := beta*y + alfa*Ax
  #------------------------------------------------------------------------------------

  def self.gemv_6part_axpy(alpha, matrix, vecx, beta, vecy)

    mpart = matrix.part_by(:six, row_dir: :lr, column_dir: :tb, filter: 0b111000)
    xpart = vecx.part_by(:three_columns, column_dir: :tb, filter: 0b100)
    ypart = vecy.part_by(:three_columns, column_dir: :tb)

    loop do
      mscalar, mtop, mbottom = mpart.next
      xscalar = xpart.next
      yscalar, ytop, ybottom = ypart.next

      # ytop = xscalar[0, 0] * mtop + ytop
      Blis.axpyv(xscalar[0, 0], mtop, ytop)

      yscalar[0, 0] = yscalar[0, 0] + xscalar[0, 0] * mscalar[0, 0]

      # ybottom = xscalar[0, 0] * mbottom + ybottom
      Blis.axpyv(xscalar[0, 0], mbottom, ybottom)
      
    end 

  end

  #------------------------------------------------------------------------------------
  # Generalized upper triangular matrix vector multiply using 6 partitioning
  # y := beta*y + alfa*Ax
  #------------------------------------------------------------------------------------

  def self.geutriangmv_6part_dot(alpha, matrix, vecx, beta, vecy)

    mpart = matrix.part_by(:six, row_dir: :lr, column_dir: :tb, filter: 0b100010)
    xpart = vecx.part_by(:three_columns, column_dir: :tb)
    ypart = vecy.part_by(:three_columns, column_dir: :tb, filter: 0b100)

    loop do
      mscalar, mright = mpart.next
      xscalar, xtop, xbottom = xpart.next
      yscalar = ypart.next
      
      yscalar[0, 0] = beta * yscalar[0, 0] +
                      alpha * (mscalar[0, 0] * xscalar[0, 0] +
                               Blis.dotv(mright, xbottom))
    end 

  end

end
