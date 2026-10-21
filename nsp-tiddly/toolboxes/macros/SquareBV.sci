function [CellArea,V,C]=SquareBV(x,y,toggleplot=%f,rect=[0,1,0,1])
// SQUAREBV   Arbitrary Square Bounded Voronoi Diagram
// This function compute the individual Voronoi cell area of point sets
// bounded in an arbitrary square

// Written by / send comments or suggestions to :
// Meng Sang, Ong (ongdotmengdotsangatengdotmonashdotedudotmy) 
// & Ye Chow, Kuang (kuangdotyedotchowatmonashdotedu)
// Photonic, Semiconductor & Communication Research Group
// School of Engineering
// Monash University Sunway campus
// October 2010
//  Inputs:
//  x             : M x 1 array of x-coordinates
//  y             : M x 1 array of y-coordinates
//  toggleplot    : 1 to turn on figures (may take longer time for large samples)
//                  0 to turn off figures;
//  [x1,x2,y1,y2] : 1 x 4 array of square edges
//  Outputs:
//  CellArea      : M x 1 array of Voronoi cell area bounded in an arbitrary square
//  Usage:
//  CellArea=SquareBV(x,y,toggleplot,[x1,x2,y1,y2])
//  CellArea=SquareBV(x,y,toggleplot)
  
  if any(size(x) ~= size(y)) then 
    error('x,y dimensions are not consistent')
  end
  x=x(:); y=y(:);
  clearglobal x_VoronoiGlobal y_VoronoiGlobal
  clear LeftEdge RightEdge BtmEdge TopEdge
  global x_VoronoiGlobal y_VoronoiGlobal
  global LeftEdge RightEdge BtmEdge TopEdge
  if toggleplot
    //plottools('on')
    //propertyeditor('off')
    //figure(1);figure(2);figure(3);figure(4);figure(5);
    //set([1:5],'WindowStyle','docked');
  end
  // Check input
  LeftEdge = rect(1);
  RightEdge = rect(2);
  BtmEdge = rect(3);
  TopEdge = rect(4);
  x_VoronoiGlobal = x;
  y_VoronoiGlobal = y;
  // Voronoi tesselation using voronoin()
  [V, C] = voronoin([x,y]);
  [vx,vy] = voronoi(x,y);
  // Force all voronoi vertices to be finite
  [V,C] = BoundVoronoin_UnitSquare(V, C,toggleplot=toggleplot);

  // ---------------------------------------------------------------------
  // Find boundary intersection points and each voronoi cell areas
  // NormV = realsqrt(sum(V.^2,2));
  NormV = V(:,1) <= RightEdge & V(:,1) >= LeftEdge ...
	  & V(:,2) <= TopEdge & V(:,2) >= BtmEdge;
  LenC  = max(size(C)); // length(C) in octave 
  CellArea = zeros(LenC,1);
  for index = 1 : LenC
    ptV = C{index};
    VSet = V(ptV,:);
    NormVSet = NormV(ptV);
    // =================================================================
    if toggleplot
      rect=[LeftEdge,BtmEdge,RightEdge,TopEdge];
      of=1;
      rectp=[LeftEdge-of,BtmEdge-of,RightEdge+of,TopEdge+of];
      xset('window',4);
      plot2d([],[],rect=rectp);
      plot2d(x,y,style=-2,axesflag=0,rect=rectp);
      plot2d(x(index),y(index),style=-3,axesflag=0,rect=rectp);
      plot2d(vx,vy,style=ones(1,size(vx,2)),axesflag=0,rect=rectp);
      for jndex = 1 : size(ptV,2);
	if ptV(jndex) ~= 1
	  plot2d(V(ptV(jndex),1),V(ptV(jndex),2),style=-4,axesflag=0,rect=rectp);	end
      end
    end
    // =================================================================
    // Identify the vertice furthest from the origin to be the first scanning vertice
    // if max(NormVSet) < 1
    if all(NormVSet)
      // All points inside unit square, calculate area
      CellArea(index) = polyarea(V(ptV,1),V(ptV,2));
    else
      // Find points outside unit Square
      // bOutside = NormVSet>1;
      bOutside = ~NormVSet;
      bTestStartPoint = bOutside;
      // bTestStartPoint = or(bTestStartPoint,circshift(bTestStartPoint,-1));
      bTestStartPoint = or(bTestStartPoint,bTestStartPoint([2:$,1])) 
      ptComplimentaryPoint = mod(find(bTestStartPoint),size(VSet,1))+1;
      // Find intersection points (if exist)
      TestPoint1 = VSet(bTestStartPoint,:);
      TestPoint2 = VSet(ptComplimentaryPoint,:);
      if size(VSet,1) == 2
	TestPoint1(2,:) = [];
	TestPoint2(2,:) = [];
      end
      // =============================================================
      if toggleplot
	plot2d([TestPoint1(:,1),TestPoint2(:,1)]',[TestPoint1(:,2),TestPoint2(:,2)]',rect=rectp,axesflag=0)
      end
      // =============================================================
      Norm1 = NormVSet(bTestStartPoint);
      Norm2 = NormVSet(ptComplimentaryPoint);
      if size(VSet,1) == 2
	Norm1(2,:) = [];
	Norm2(2,:) = [];
      end
      // bOneInOneOut= xor(~Norm1, ~Norm2);
      bOneInOneOut= ~Norm1 <> ~Norm2 // gives xor 
      count = 0; xc1 = []; yc1 = [];
      for hndex = 1:size(bOneInOneOut,1)
	if bOneInOneOut(hndex)
	  count = count + 1;
	  // [xc1, yc1]  = BoundaryIntersect_UnitSquare(TestPoint1(bOneInOneOut,:),TestPoint2(bOneInOneOut,:),1);
	  [xc1(count), yc1(count)]  = ...
	      BoundaryIntersect_UnitSquare(TestPoint1(hndex,:),TestPoint2(hndex,:),1);
	end
      end
      xc1 = reshape(xc1,numel(xc1),1);
      yc1 = reshape(yc1,numel(yc1),1);
      // bTwoOut= and(Norm1>1,Norm2>1);
      bTwoOut     = and(~Norm1, ~Norm2);
      count = 0; xc2 = []; yc2 = [];
      for kndex = 1:size(bTwoOut,1)
	if bTwoOut(kndex)
	  count = count + 2;
	  [xc2(count-1:count), yc2(count-1:count)]  = ...
	      BoundaryIntersect_UnitSquare(TestPoint1(kndex,:),TestPoint2(kndex,:),2);
	end
      end
      xc2 = reshape(xc2,numel(xc2),1);
      yc2 = reshape(yc2,numel(yc2),1);
      xc2(isnan(xc2)) = [];
      yc2(isnan(yc2)) = [];
      // =============================================================
      if toggleplot
	if ~isempty(xc1)
	  plot2d(xc1,yc1,	rect=rectp,axesflag=0)
	end
	if ~isempty(xc2)
	  plot2d(xc2,yc2,	rect=rectp,axesflag=0)
	end
      end
      // =============================================================
      // Calculate Voronoi cell area
      CellArea(index) = CalcArea_UnitSquare(VSet(NormVSet,:), [xc1,yc1], [xc2,yc2], index);
    end
    // =================================================================
    if toggleplot
      // hold off
      // pause(0.8)
    end
    // =================================================================
  end
  TotalArea = sum(CellArea);
  Err = TotalArea - abs((RightEdge - LeftEdge)*(TopEdge-BtmEdge));
  fprintf('Total Area = %.3e\n',TotalArea);
  fprintf('Mean absolute Error = %.3e\n',mean(abs(Err)))
  fprintf('Largest absolute Error = %.3e\n',max(abs(Err)))
  clearglobal x_VoronoiGlobal y_VoronoiGlobal
  clear LeftEdge RightEdge BtmEdge TopEdge
endfunction 
