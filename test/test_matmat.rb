# -*- coding: utf-8 -*-

##########################################################################################
# Copyright © 2016 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
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

require "test/unit"
require 'shoulda'

require '../config' if @platform == nil
require 'mdarray-laff'


class BlisMatrixTest < Test::Unit::TestCase

  context "BlisMatrix" do

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    setup do 

      @m2 = MDArray.double([5, 5],
                           [1, -1, 3, 2, -2,
                            2, -2, 1, 0, -1,
                            0, -4, 3, 2, 1,
                            3, 1, -2, 1, 0,
                            -1, 2, 1, -1, -2])
      
      @u = MDArray.double([5, 5],
                          [-1, 2, 4, 1, 0,
                           0, 0, -1, -2, 1,
                           0, 0, 3, 1, 2,
                           0, 0, 0, 4, 3,
                           0, 0, 0, 0, 2])

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do matrix matrix multiplication" do

      p "square a matrix"
      t = MDArray.double([5, 5])
      Blis.gemm_dot(t, @m2, @m2)
      t.pp

#=begin      
      mt = MDMatrix.from_mdarray(@m2)
      res = mt.mult(mt)
      res.print 
      #=end

      t = MDArray.double([5, 5])
      Blis.gemm_dot(t, @m2, @u)
      t.pp

      umat = MDMatrix.from_mdarray(@u)
      res = mt.mult(umat)
      res.print 
      
    end

  end

end
