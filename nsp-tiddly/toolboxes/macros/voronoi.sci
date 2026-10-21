// Copyright (C) 2000-2012 Kai Habel
//
// This file is part of Octave.
//
// Octave is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3 of the License, or (at
// your option) any later version.
//
// Octave is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Octave; see the file COPYING.  If not, see
// <http://www.gnu.org/licenses/>.

// -*- texinfo -*-
// @deftypefn  {Function File} {} voronoi (@var{x}, @var{y})
// @deftypefnx {Function File} {} voronoi (@var{x}, @var{y}, @var{options})
// @deftypefnx {Function File} {} voronoi (@dots{}, "linespec")
// @deftypefnx {Function File} {} voronoi (@var{hax}, @dots{})
// @deftypefnx {Function File} {@var{h} =} voronoi (@dots{})
// @deftypefnx {Function File} {[@var{vx}, @var{vy}] =} voronoi (@dots{})
// Plot the Voronoi diagram of points @code{(@var{x}, @var{y})}.
// The Voronoi facets with points at infinity are not drawn.
// 
// If "linespec" is given it is used to set the color and line style of the
// plot.  If an axis graphics handle @var{hax} is supplied then the Voronoi
// diagram is drawn on the specified axis rather than in a new figure.
//
// The @var{options} argument, which must be a string or cell array of strings,
// contains options passed to the underlying qhull command.
// See the documentation for the Qhull library for details
// @url{http://www.qhull.org/html/qh-quick.htm#options}.
//
// If a single output argument is requested then the Voronoi diagram will be
// plotted and a graphics handle @var{h} to the plot is returned.
// [@var{vx}, @var{vy}] = voronoi(@dots{}) returns the Voronoi vertices
// instead of plotting the diagram.
//
// @example
// @group
// x = rand (10, 1);
// y = rand (size (x));
// h = convhull (x, y);
// [vx, vy] = voronoi (x, y);
// plot (vx, vy, "-b", x, y, "o", x(h), y(h), "-g");
// legend ("", "points", "hull");
// @end group
// @end example
//
// @seealso{voronoin, delaunay, convhull}
// @end deftypefn

// Author: Kai Habel <kai.habel@gmx.de>
// First Release: 20/08/2000

// 2002-01-04 Paul Kienzle <pkienzle@users.sf.net>
// * limit the default graph to the input points rather than the whole diagram
// * provide example
// * use unique(x,"rows") rather than __unique_rows__

// 2003-12-14 Rafael Laboissiere <rafael@laboissiere.net>
// Added optional fourth argument to pass options to the underlying
// qhull command

// 2012-06-06 Jean-Philippe Chancelier 
// adapted to nsp. 

function [vx, vy] = voronoi (x,y,varargopt)
  if (nargin < 1)
    error("Error: voronoi(x,y,varargopt)\n");
    return;
  end
  lx = length (x);
  ly = length (y);

  if (lx ~= ly)
    error ("voronoi: X and Y must be vectors of the same length\n");
  end

  // Add box to approximate rays to infinity. For Voronoi diagrams the
  // box can (and should) be close to the points themselves. To make the
  // job of finding the exterior edges it should be at least two times the
  // delta below however
  x=x(:); y=y(:);
  [xmin,xmax]= minmax(x);
  [ymin,ymax]= minmax(y);
  xdelta = xmax - xmin;
  ydelta = ymax - ymin;
  scale = 2;
  xbox = [xmin - scale * xdelta; xmin - scale * xdelta; ...
          xmax + scale * xdelta; xmax + scale * xdelta];
  ybox = [xmin - scale * xdelta; xmax + scale * xdelta; ...
          xmax + scale * xdelta; xmin - scale * xdelta];
  // take care that pts are transposed in  voronoi_internal
  [p, c, infi] = voronoi_internal("voronoi",[[x;xbox],[y;ybox]]');
  idx = find (~ infi);
  ll = length (idx);
  c = c(idx)';
  // k = sum (cellfun ("length", c));
  // en nsp 
  function y=cell_length(x);y=length(x);endfunction;
  c1 = map(c,cell_length);
  k= sum(ce2m(c1));
  
  // edges = cell2mat (cellfun (@(x) [x ; [x(end), x(1:end-1)]], c,"uniformoutput", false));
  function y=cell_fun(x) y=[x ; [x($), x(1:$-1)]];endfunction;
  c2 = map(c,cell_fun);
  edges =[]; for i=1:size(c2,'*'); edges=[edges,c2{i}];end 
  
  // Identify the unique edges of the Voronoi diagram
  // edges = sortrows (sort (edges).').';
  edges= sort(sort(edges,'r','i')','lr','i')';
  edges = edges (:, [(edges(1, 1: $ - 1) ~= edges(1, 2 : $) | ...
                      edges(2, 1 : $ - 1) ~= edges(2, 2 : $)), %t]);

  // Eliminate the edges of the diagram representing the box
  // rows(A) -> size(A,1);
  poutside = (1 : size(p,1)) ...
      (p (:, 1) < xmin - xdelta | p (:, 1) > xmax + xdelta | ...
       p (:, 2) < ymin - ydelta | p (:, 2) > ymax + ydelta);
  
  // edgeoutside = ismember (edges (1, :), poutside) & ismember (edges(2, :), poutside);
  edgeoutside = poutside.has[edges (1, :)] & poutside.has[edges(2,:)];
  edges (:, edgeoutside) = [];
  
  // Get points of the diagram
  vx = reshape (p(edges, 1), size (edges));
  vy = reshape (p(edges, 2), size (edges));
  
  if (nargout < 2)
    plot2d(x,y,style=-1,rect=[xmin, ymin, xmax, ymax]);
    xclip("clipgrf") 
    //xset("clipping",xmin,ymin,xmax-xmin,ymax-ymin);
    xsegs(vx,vy);
    xclip();
  end
endfunction

//!demo
//! voronoi (rand(10,1), rand(10,1));
//!testif HAVE_QHULL
//! phi = linspace (-pi, 3/4*pi, 8);
//! [x,y] = pol2cart (phi, 1);
//! [vx,vy] = voronoi (x,y);
//! assert(vx(2,:), zeros (1, columns (vx)), eps);
//! assert(vy(2,:), zeros (1, columns (vy)), eps);

//% FIXME: Need input validation tests

