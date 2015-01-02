//======================================================================
//
// blake2_G.v
// -----------
// Verilog 2001 implementation of the G function in the
// blake2 hash function core. This is pure combinational logic in a
// separade module to allow us to build versions  with 1, 2, 4
// and even 8 parallel compression functions.
//
//
// Copyright (c) 2014, Secworks Sweden AB
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

module blake2_G(
                input wire [63 : 0]  a,
                input wire [63 : 0]  b,
                input wire [63 : 0]  c,
                input wire [63 : 0]  d,

                output wire [63 : 0] a_prim,
                output wire [63 : 0] b_prim,
                output wire [63 : 0] c_prim,
                output wire [63 : 0] d_prim
               );


  //----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
  reg [63 : 0] internal_a_prim;
  reg [63 : 0] internal_b_prim;
  reg [63 : 0] internal_c_prim;
  reg [63 : 0] internal_d_prim;


  //----------------------------------------------------------------
  // Concurrent connectivity for ports.
  //----------------------------------------------------------------
  assign a_prim = internal_a_prim;
  assign b_prim = internal_b_prim;
  assign c_prim = internal_c_prim;
  assign d_prim = internal_d_prim;


  //----------------------------------------------------------------
  // G
  //
  // The actual G function.
  //----------------------------------------------------------------
  always @*
    begin : G
      reg [63 : 0] a0;
      reg [63 : 0] a1;

      reg [63 : 0] b0;
      reg [63 : 0] b1;
      reg [63 : 0] b2;
      reg [63 : 0] b3;

      reg [63 : 0] c0;
      reg [63 : 0] c1;

      reg [63 : 0] d0;
      reg [63 : 0] d0;
      reg [63 : 0] d1;
      reg [63 : 0] d2;
      reg [63 : 0] d3;

      reg [63 : 0] m0;
      reg [63 : 0] m1;

      a0 = a + b + m0;

      d0 = d ^ a0;
      d1 = {d0[31 : 0], d0[64 : 32]};

      c0 = c + d1;

      b0 = b ^ c0;
      b1 = {b0[23 : 0], b0[63 : 24]};

      a1 = a0 + b1 + m1;

      d2 = d1 ^ a1;
      d3 = {d2[15 : 0], d2[63 : 16]};

      c1 = c0 + d3;

      b2 = b1 ^ c1;
      b3 = {b2[0], b2[63 : 1]};

      internal_a_prim = a1;
      internal_b_prim = b3;
      internal_c_prim = c1;
      internal_d_prim = d3;
    end // G
endmodule // blake2_G

//======================================================================
// EOF blake2_G.v
//======================================================================