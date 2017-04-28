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
  # Mutiplies two matrices storing the result in c based on gemv_dot
  # C := beta * C + alpha * transa(A) * transb(B)
  # where C is an m x n matrix, transa(A) is an m x k matrix, and transb(B) is a k x n
  # matrix.
  # @param alpha [Number}
  # @param a [MDArray]
  # @param b [MDArray]
  # @param beta [Number]
  # @param c [MDArray]
  #------------------------------------------------------------------------------------
  
  def self.gemm_mvdot(alpha, a, b, beta, c)

    cpart = c.part_by(:column, row_dir: :lr, filter: 0b10)
    bpart = b.part_by(:column, row_dir: :lr, filter: 0b10)

    loop do
      Blis.gemv_dot(alpha, a, bpart.next, beta, cpart.next)
    end
    
  end
  
  #------------------------------------------------------------------------------------
  # Mutiplies two matrices storing the result in c based on gemv_dot doing
  # vector matrix multiplication
  # C := beta * C + alpha * transa(A) * transb(B)
  # where C is an m x n matrix, transa(A) is an m x k matrix, and transb(B) is a k x n
  # matrix.
  # @param alpha [Number}
  # @param a [MDArray]
  # @param b [MDArray]
  # @param beta [Number]
  # @param c [MDArray]
  #------------------------------------------------------------------------------------
  
  def self.gemm_vmdot(alpha, a, b, beta, c)

    cpart = c.part_by(:row, column_dir: :tb, filter: 0b10)
    apart = a.part_by(:row, column_dir: :tb, filter: 0b10)

    loop do
      Blis.gemm_mvdot(alpha, apart.next, b, beta, cpart.next)
    end
    
  end

  #------------------------------------------------------------------------------------
  # Mutiplies two matrices storing the result in c based on gemv_axpy
  # @param alpha [Number}
  # @param a [MDArray]
  # @param b [MDArray]
  # @param beta [Number]
  # @param c [MDArray]
  #------------------------------------------------------------------------------------
  
  def self.gemm_mvaxpy(alpha, a, b, beta, c)

    cpart = c.part_by(:column, row_dir: :lr, filter: 0b10)
    bpart = b.part_by(:column, row_dir: :lr, filter: 0b10)

    loop do
      Blis.gemv_axpy(alpha, a, bpart.next, beta, cpart.next)
    end
    
  end

  #------------------------------------------------------------------------------------
  # Multiplies two matrices storing the result in c based on rank-1 update.
  # @param alpha [Number]
  # @param a [MDArray]
  # @param b [MDArray]
  # @param beta [Number]
  # @param c [MDArray] where the result of the multiplication is stored
  #------------------------------------------------------------------------------------

  def self.gemm_ger(alpha, a, b, beta, c)

    apart = a.part_by(:column, row_dir: :lr, filter: 0b10)
    bpart = b.part_by(:row, column_dir: :tb, filter: 0b10)

    loop do
      Blis.ger(alpha, c, apart.next, bpart.next)
    end
    
  end

  #------------------------------------------------------------------------------------
  # transpose matrix a returning a matrix with the same backing store, but with indexes
  # transposed
  #------------------------------------------------------------------------------------

  def self.trnsp(a)
    return a if (a.shape[0] == 0)
    a.transpose(0, 1)
  end
  
end
