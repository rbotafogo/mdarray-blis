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
  # Mutiplies two matrices storing the result in result_matrix based on gemv_dot
  # @param result_matrix [MDArray]
  # @param m1 [MDArray]
  # @param m2 [MDArray]
  #------------------------------------------------------------------------------------
  
  def self.gemm_mvdot(result_matrix, m1, m2)

    respart = result_matrix.part_by(:column, row_dir: :lr, filter: 0b10)
    m2part = m2.part_by(:column, row_dir: :lr, filter: 0b10)

    loop do
      Blis.gemv_dot(1, 1, respart.next, m1, m2part.next)
    end
    
  end
  
  #------------------------------------------------------------------------------------
  # Mutiplies two matrices storing the result in result_matrix based on gemv_dot doing
  # vector matrix multiplication
  # @param result_matrix [MDArray]
  # @param m1 [MDArray]
  # @param m2 [MDArray]
  #------------------------------------------------------------------------------------
  
  def self.gemm_vmdot(result_matrix, m1, m2)

    respart = result_matrix.part_by(:row, column_dir: :tb, filter: 0b10)
    m1part = m1.part_by(:row, column_dir: :tb, filter: 0b10)

    loop do
      Blis.gemm_mvdot(respart.next, m1part.next, m2)
    end
    
  end

  #------------------------------------------------------------------------------------
  # Mutiplies two matrices storing the result in result_matrix based on gemv_axpy
  # @param result_matrix [MDArray]
  # @param m1 [MDArray]
  # @param m2 [MDArray]
  #------------------------------------------------------------------------------------
  
  def self.gemm_mvaxpy(result_matrix, m1, m2)

    respart = result_matrix.part_by(:column, row_dir: :lr, filter: 0b10)
    m2part = m2.part_by(:column, row_dir: :lr, filter: 0b10)

    loop do
      Blis.gemv_axpy(1, 1, respart.next, m1, m2part.next)
    end
    
  end

end
