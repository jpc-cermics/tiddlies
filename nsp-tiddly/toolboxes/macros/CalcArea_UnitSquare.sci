function CellArea = CalcArea_UnitSquare(VSet, V1, V2, ptS)

  global x_VoronoiGlobal y_VoronoiGlobal
  global LeftEdge RightEdge BtmEdge TopEdge

  x = x_VoronoiGlobal;
  y = y_VoronoiGlobal;

  S               = [x(ptS),y(ptS)];
  xOther          = x;
  xOther(ptS)     = [];
  yOther          = y;
  yOther(ptS)     = [];

  VBoundary       = [V1;V2];
  VAll            = [VSet;VBoundary];
  Centre          = mean(VAll,1);
  // SAngle          = atan2(S(2)-Centre(2),S(1)-Centre(1));
  Angle           = atan(VBoundary(:,2)-Centre(2),VBoundary(:,1)-Centre(1));
  // Angle           = atan2([VBoundary(:,2)],[VBoundary(:,1)]);
  [Angle,index]   = sort(Angle,'g','i');
  VBoundary       = VBoundary(index,:);

  ptNext      = [2:size(VBoundary,1),1];
  flagBtmLeft  = %f;
  flagTopLeft  = %f;
  flagTopRight = %f;
  flagBtmRight = %f;

  for index = 1 : size(VBoundary,1)
    // Determine if there is a point inside the Voronoi cell
    dx = VBoundary(index,1)-VBoundary(ptNext(index),1);
    dy = VBoundary(index,2)-VBoundary(ptNext(index),2);
    
    Side            = sign((xOther-VBoundary(index,1))*dy - (yOther-VBoundary(index,2))*dx);
    RefSideBtmLeft  = sign((LeftEdge-VBoundary(index,1))*dy  - (BtmEdge-VBoundary(index,2))*dx);
    RefSideTopLeft  = sign((LeftEdge-VBoundary(index,1))*dy  - (TopEdge-VBoundary(index,2))*dx);
    RefSideTopRight = sign((RightEdge-VBoundary(index,1))*dy - (TopEdge-VBoundary(index,2))*dx);
    RefSideBtmRight = sign((RightEdge-VBoundary(index,1))*dy - (BtmEdge-VBoundary(index,2))*dx);
    
    // Append square edges to the corresponding Voronoi cell
    if (~any(Side==RefSideBtmLeft) && (RefSideBtmLeft ~= 0))
      if ~flagBtmLeft
	VAll = [VAll; [LeftEdge, BtmEdge]];
	flagBtmLeft = %t;
      end
    end
    
    if (~any(Side==RefSideTopLeft) && (RefSideTopLeft ~= 0))
      if ~flagTopLeft
	VAll = [VAll; [LeftEdge, TopEdge]];
	flagTopLeft = %t;
      end
    end
    
    if (~any(Side==RefSideTopRight) && (RefSideTopRight ~= 0))
      if ~flagTopRight
	VAll = [VAll; [RightEdge, TopEdge]];
	flagTopRight = %t;
      end
    end
    
    if (~any(Side==RefSideBtmRight) && (RefSideBtmRight ~= 0))
      if ~flagBtmRight
	VAll = [VAll; [RightEdge, BtmEdge]];
	flagBtmRight = %t;
      end
    end
    
  end

  // Calculate Voronoi Cell Area
  vec             = VAll - repmat(Centre, size(VAll,1),1);
  Angle           = atan(vec(:,2),vec(:,1));
  // attention 
  [sorted,index]  = sort(Angle,'g','i'); //#ok<ASGLU>
  VAll            = VAll(index,:);
  CellArea        = polyarea(VAll(:,1), VAll(:,2));
  if size(CellArea,'*')==0 then CellArea=0;end 
endfunction 


