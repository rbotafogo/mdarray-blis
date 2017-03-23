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
  java_import 'java.util.Arrays'
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def dotv(other)

    raise "DOTV requires a row vector as the first operand" if self.shape[0] != 1
    raise "DOTV requires a column vector as the second operand" if other.shape[1] != 1
    raise "Incompatible dimensions for dot between self.shape and other.shape" if
      (self.shape[0] != other.shape[1]) && (self.shape[1] != other.shape[0])

    Blis.dotv(self, other)

  end
    
  #------------------------------------------------------------------------------------
  # Compare to matrices.  They are equal if they have the same shape and all the
  # elements are the same.
  #------------------------------------------------------------------------------------

  def identical(other)
    if (shape.size != other.shape.size || shape[0] != other.shape[0] ||
        shape[1] != other.shape[1])
      false
    else
      java.util.Arrays.equals(@nc_array.get1DJavaArray(java.lang.Double),
                              other.nc_array.get1DJavaArray(java.lang.Double))
    end
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  alias pp :print
  
end
