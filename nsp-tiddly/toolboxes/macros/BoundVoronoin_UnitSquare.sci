function [V, C] = BoundVoronoin_UnitSquare(V, C,toggleplot=%f)
    
  global x_VoronoiGlobal y_VoronoiGlobal
  global LeftEdge RightEdge BtmEdge TopEdge

  function y=realsqrt(x) ; y=sqrt(x);endfunction 
  
  // An arbitrarily selected small number for distance comparison
  Epsilon = 1e-14;

  x = x_VoronoiGlobal;
  y = y_VoronoiGlobal;

  // Identify points with unbounded cell
  
  LenC = size(C,'*'); // equals to M
  
  ptUnbound = [];
  for index = 1 : LenC
    if C{index}.has[1]  // Unbounded cell was ismember(1,C{index}) in matlab
      ptUnbound = [ptUnbound;index]; //#ok<AGROW>
    end
  end
  // List the unbounded cells in counter-clockwise direction
  UnboundCentre = mean([x(ptUnbound),y(ptUnbound)],1);
  // Angle =
  // atan2(y(ptUnbound)-UnboundCentre(2),x(ptUnbound)-UnboundCentre(1));
  Angle = atan(y(ptUnbound)-UnboundCentre(2),x(ptUnbound)-UnboundCentre(1));
  [Angle,ptptUnbound] = sort(Angle,'g','i'); //#ok<ASGLU>
  ptUnbound = ptUnbound(ptptUnbound);
  Orphan_x = x(ptUnbound);
  Orphan_y = y(ptUnbound);

  rect=[LeftEdge,BtmEdge,RightEdge,TopEdge];
  of=1;
  rectp=[LeftEdge-of,BtmEdge-of,RightEdge+of,TopEdge+of];
  
  if toggleplot
    // attention à revoir.
    [vx,vy] = voronoi(x,y);
    xset('window',1);
    plot2d([],[],rect=rectp);
    //hold on
    plot2d(vx,vy,style=ones(1,size(vx,2)),axesflag=0,rect=rectp);
    //plot2d(V(2:$,1),V(2:$,2),style=-3,axesflag=0,rect=rectp)
    plot2d(x,y,style=0,axesflag=0,rect=rectp);
    plot2d(Orphan_x,Orphan_y,style=-2,axesflag=0,rect=rectp)
    xrect(LeftEdge,BtmEdge+TopEdge,RightEdge,TopEdge)
  end
  
  //// Find suitable replacement for infinity points
  // Pointer to the next(circular) unbounded cell
  ptNext = [2:length(ptUnbound),1];
  for index = 1 : length(ptUnbound)
    ptV = C{ptUnbound(index)};
    // =====================================================================
    if toggleplot
      // Display voronoi diagram
      xset('window',2);
      plot2d([],[],rect=rectp);
      plot2d(Orphan_x,Orphan_y,style=-2,axesflag=0,rect=rectp);
      plot2d(x(ptUnbound(index)),y(ptUnbound(index)),style=-3,...
	     axesflag=0,rect=rectp);
      plot2d(vx,vy,style=ones(1,size(vx,2)),axesflag=0,rect=rectp);
      for jndex = 1 : length(ptV)
	if ptV(jndex) ~= 1
	  plot2d(V(ptV(jndex),1),V(ptV(jndex),2),style=-4,axesflag=0,rect=rectp);
	end
      end
    end
    // =====================================================================
    P1x         = Orphan_x(index);
    P1y         = Orphan_y(index);
    P2x_Next    = Orphan_x(ptNext(index));
    P2y_Next    = Orphan_y(ptNext(index));
    ptVFinite   = setdiff(ptV,[1]);
    // Identify voronoi vertex that is closest to the proposed perpendicular bisector
    Dist  = abs(V(ptVFinite,1)*(P1x-P2x_Next) + ... 
		V(ptVFinite,2)*(P1y-P2y_Next) ...
		-(P1y^2-P2y_Next^2+P1x^2-P2x_Next^2)/2);
    [MinDist,jndex] = min(Dist); //#ok<ASGLU>
    // NormVoronoiPoint = realsqrt(sum(V(ptVFinite(jndex),:).^2));
    // NormVoronoiPoint = V(ptVFinite(jndex),1)<= RightEdge & V(ptVFinite(jndex),1)>= LeftEdge & V(ptVFinite(jndex),2)<= TopEdge & V(ptVFinite(jndex),2)>= BtmEdge;
    // Identifies the points that uses ptVFinite(jndex) as voronoi vertice
    ptP = [];    bContinue = %t;   Counter=0;      PCounter=0;
    while bContinue
      Counter = Counter + 1;
      // if ismember(ptVFinite(jndex),C{Counter})
      if C{Counter}.has[ptVFinite(jndex)] then 
	PCounter = PCounter + 1;
	ptP(PCounter) = Counter;
	if PCounter>=3
	  bContinue = %f;
	end
      end
      if Counter >= LenC
	bContinue = %f;
      end
    end
    
    // Find the bisector and append the new point to appropriate entries in C
    for Counter1 = 1 : PCounter-1
      for Counter2 = Counter1 + 1 : PCounter
	ptLocalVSet = setdiff(union(C{ptP(Counter1)},C{ptP(Counter2)}),[1,ptVFinite(jndex)]);
	// Equation of bisector (y-y0)(dy)+(x-x0)(dx)=0
	MidPoint    = 0.5*[x(ptP(Counter1))+x(ptP(Counter2)),y(ptP(Counter1))+y(ptP(Counter2))];
	dx          = x(ptP(Counter1))-x(ptP(Counter2));
	dy          = y(ptP(Counter1))-y(ptP(Counter2));
	VecLen      = realsqrt(dx^2+dy^2);
	dx          = dx/VecLen;
	dy          = dy/VecLen;
	DistBisect  = abs( (V(ptLocalVSet,1)-MidPoint(1))*dx + (V(ptLocalVSet,2)-MidPoint(2))*dy );
	bNoHit      = DistBisect > Epsilon;
	if all(bNoHit)
	  
	  // Can't find a finite voronoi vertice to complement ptVFinite(jndex)
	  // Create a new point outside the rectangle
	  Lambda = 2*realsqrt((V(ptVFinite(jndex),1)-x(ptP(Counter1))).^2+(V(ptVFinite(jndex),2)-y(ptP(Counter1))).^2);
	  
	  P_ex1 = V(ptVFinite(jndex),:) + Lambda*[dy,-dx];
	  P_ex2 = V(ptVFinite(jndex),:) + Lambda*[-dy,dx];
	  // attention a sort XXX 
	  Dist1 = sort(realsqrt((P_ex1(1)-x(ptP)).^2+(P_ex1(2)-y(ptP)).^2));
	  Dist2 = sort(realsqrt((P_ex2(1)-x(ptP)).^2+(P_ex2(2)-y(ptP)).^2));
	  
	  Direction = [];
	  if (Dist1(3)-Dist1(2) > 0) && (abs(Dist1(2)-Dist1(1))<Epsilon)
	    Direction = 1;
	  elseif (Dist2(3)-Dist2(2) > 0) && (abs(Dist2(2)-Dist2(1))<Epsilon)
	    Direction = 2;
	  end
	  if ~isempty(Direction)
	    bContinue = %t;
	    while bContinue
	      if Direction == 1
		P_ex = V(ptVFinite(jndex),:) + Lambda*[dy,-dx];
	      elseif Direction == 2
		P_ex = V(ptVFinite(jndex),:) + Lambda*[-dy,dx];
	      end
	      if ~(P_ex(1)<= RightEdge && P_ex(1)>= LeftEdge && P_ex(2)<= TopEdge && P_ex(2)>= BtmEdge)
		bContinue = %f;
		V = [V;P_ex]; //#ok<AGROW>
		C{ptP(Counter1)} = [C{ptP(Counter1)},size(V,1)];
		C{ptP(Counter2)} = [C{ptP(Counter2)},size(V,1)];
		if toggleplot
		  plot2d(V($,1),V($,2),style=-2,axesflag=0,rect=rectp);
		end
	      else
		Lambda = 2*Lambda;
	      end
	    end
	  end
	end
	
      end // End of Counter 2
    end // End of Counter 1
    
    if toggleplot
      // hold off
    end
  end

  //// Sort angle, all vertices in anti-clockwise direction

  for index = 1 : LenC
    ptVFinite = setdiff(C{index},[1]);
    if toggleplot
      xset('window',3);
      plot2d([],[],rect=rectp);
      plot2d(Orphan_x,Orphan_y,style=-2,axesflag=0,rect=rectp);
      plot2d(x(index),y(index),style=-3,axesflag=0,rect=rectp);
      plot2d(vx,vy,style=ones(1,size(vx,2)),axesflag=0,rect=rectp);
      plot2d(V(ptVFinite,1),V(ptVFinite,2),style=-4,axesflag=0,rect=rectp);
    end
    Centre = mean(V(ptVFinite,:),1);
    // Angle = atan2(V(ptVFinite,2)-Centre(2),V(ptVFinite,1)-Centre(1));
    Angle = atan(V(ptVFinite,2)-Centre(2),V(ptVFinite,1)-Centre(1));
    [Angle,jndex] = sort(Angle,'g','i'); //#ok<ASGLU>
    C{index} = ptVFinite(jndex);   // Sorted Voronoi vertices
    if toggleplot
      // hold off
    end
  end
endfunction 
