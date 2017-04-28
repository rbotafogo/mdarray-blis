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

class MDArray

  class LinAlg

    #--------------------------------------------------------------------------------------
    # Forward solves Lz = b
    # @param mLU [MDArray] Unit lower triangular matrix obtained after LU factorization
    # @param vb [MDArray] b vector so that Lz = b.  The result is stored in b.
    #--------------------------------------------------------------------------------------

    def self.forward_solve(mLU, vb)

      mLpart = mLU.part_by(:six, row_dir: :lr, column_dir: :tb, filter: 0b001000)
      vbpart = vb.part_by(:row, column_dir: :tb, filter: 0b11)

      loop do
        l21 = mLpart.next
        beta1, b2 = vbpart.next
        Blis.axpyv(-beta1[0, 0], l21, b2)
      end
      
    end
    
  end

end

