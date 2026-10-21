function [xp,yp,K] = posttransfo(x,y,prep,K,pars)
//                                       [xp,yp] = posttransfo(x,y,prep,K)
// POSTTRANSFO  Transforms (x,y) from internal SeDuMi format into original
//   user format.
//
// **********  INTERNAL FUNCTION OF SEDUMI **********
//
// See also sedumi

//
// This file is part of SeDuMi 1.1 by Imre Polik and Oleksandr Romanko
// Copyright (C) 2005 McMaster University, Hamilton, CANADA  (since 1.1)
//
// Copyright (C) 2001 Jos F. Sturm (up to 1.05R5)
//   Dept. Econometrics & O.R., Tilburg University, the Netherlands.
//   Supported by the Netherlands Organization for Scientific Research (NWO).
//
// Affiliation SeDuMi 1.03 and 1.04Beta (2000):
//   Dept. Quantitative Economics, Maastricht University, the Netherlands.
//
// Affiliations up to SeDuMi 1.02 (AUG1998):
//   CRL, McMaster University, Canada.
//   Supported by the Netherlands Organization for Scientific Research (NWO).
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc.,  51 Franklin Street, Fifth Floor, Boston, MA
// 02110-1301, USA
//
  K.l = K.l - 1;       // remove artificial var of self-dual embedding
  xp=x(2:$);
  // ------------------------------------------------------------
  // If there are Lorentz cones then reorder the variables
  // ------------------------------------------------------------
  if ~isempty(K.q)
    xp = qreshape(xp,1,K);
  end
  // ------------------------------------------------------------
  // Transform LQ-vars into F-vars (free)
  // ------------------------------------------------------------


  K.f = prep.Kf;
  if K.f>0
    select pars.free
     case 0
      K.l = K.l - 2 * K.f;
      nnx=2*K.f+1;
      xp = [xp(K.f+1 : 2*K.f) - xp(1:K.f); xp(nnx:$)];
    else
      K.q=K.q(2:$);
      nnx=K.l+K.f+2;
      xp=[xp(K.l+2:K.l+K.f+1);xp(1:K.l);xp(nnx:$)];
    end
  end


  // -----------------------------------------------------
  // Reenter the split free variables (if any)
  // -----------------------------------------------------
  if isfield(prep,'freeblock1')
    numvars=length(prep.freeblock1);
    //XXX block1=false(1,K.l+2*numvars);
    block1= m2b(zeros(1,K.l+2*numvars));
    block2=block1;
    block1(prep.freeblock1)=%t; //true;
    block2(prep.freeblock2)=%t; // true;
    xkl=zeros(K.l+2*numvars,1);
    //xkl(~(block1+block2))=xp(K.f+1:K.f+K.l);
    xkl(~(or(block1,block2)))=xp(K.f+1:K.f+K.l);
    xkl(prep.freeblock1)=max(xp(1:numvars),0);
    xkl(prep.freeblock2)=-min(xp(1:numvars),0);
    nnx=K.f+K.l+1;
    xp=[xp(numvars+1:K.f);xkl;xp(nnx:$)];
    K.f=K.f-numvars;
    K.l=K.l+2*numvars;
  end

  // ----------------------------------------
  // Postprocess the SDP part
  // ----------------------------------------

  if pars.sdp==1 & isfield(prep,'sdp')
    xpf(1:K.f,1)=xp(1:K.f);
    xp=xp(K.f+1:$);
    Kf=K.f;
    K.f=0;
    [xp,yp,K]=postprocessSDP(xp,y,prep.sdp,K);
    xp=[xpf;xp];
    K.f=Kf;
    clear Kf xpf
    // [xp,yp,K]=postprocessSDP(xp,y,prep.sdp,K);
  end

  // ----------------------------------------
  // transform q-variables into r-variables (Lorentz) (if any)
  // ----------------------------------------

  if prep.rq==1
    nnx=prep.lenKq + 1
    K.r = K.q(nnx : $);
    K.q = K.q(1:prep.lenKq);
    xp = rotlorentz(xp,K);
  else
    K.r=[];
  end

  // ----------------------------------------
  // Bring x into the complex format of original (At,c),
  // ----------------------------------------

  xp = veccomplex(xp,prep.cpx,K);
  // ----------------------------------------
  // bring y into complex format, indicated by K.ycomplex.
  // ----------------------------------------
  ylen = length(y) - length(K.ycomplex);
  if ~isempty([ylen+1:length(y)]) then 
    yp = y(1:ylen) + %i * sparse([K.ycomplex(:),ones(size(K.ycomplex(:)))],y(ylen+1:length(y)),[ylen,1]);
  else
    yp = y(1:ylen) 
  end
  // ---------------------------
  // Make x sparse if necessary
  // ---------------------------
  if nnz(xp)/length(xp)<2/3
    xp=sparse(xp);
  end
endfunction
