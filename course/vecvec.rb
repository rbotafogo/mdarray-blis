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

class Course

  #------------------------------------------------------------------------------------
  # Performs a dotv operation between a row vector and a column vector.  No error
  # checking is done.
  # @param r_vec [MDArray] an MDArray configured as a row vector: dimension [x, 1]
  # @param c_vec [MDArray] an MDArray configured as a column vector: dimension [1, x]
  # @return number [Numeric] a numeric value representing the dot product between
  # r_vec and c_vec
  #------------------------------------------------------------------------------------
  
  def self.dotv(r_vec, c_vec)
    
    dot = r_vec[0, 0] * c_vec[0, 0]
    Laff.part_synchronized(r_vec, Laff.method(:part_by_column_lr),
                           c_vec, Laff.method(:part_by_row_tb),
                           vec_size: r_vec.shape[1],
                           filter1: 0b01, filter2: 0b01) do |left, top|
      dot += left[0, 0] * top[0, 0]
    end
    dot
    
  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.axpyv(alfa, vec1, vec2)

    vec1[0, 0] = alfa * vec1[0, 0] + vec2[0, 0]
    Laff.part_synchronized(vec1, Laff.method(:part_by_row_tb),
                           vec2, Laff.method(:part_by_row_tb),
                           vec_size: vec1.shape[0],
                           filter1: 0b01, filter2: 0b01) do |top1, top2|
      top1[0, 0] = alfa * top1[0, 0] + top2[0, 0]
    end
    true
    
  end


end
