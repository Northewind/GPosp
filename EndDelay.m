function retcode = EndDelay(varargin);
	global err;
	errInit();
	switch nargin
	case 0
		ifid = stdin();
		ofid = stdout();
	case 2
		ifid = fopen(varargin{1}, "r");
		ofid = fopen(varargin{2}, "w");
	otherwise
		retcode = err.CMD_ARG_NUM;
		return;
	endswitch
	if (ifid != -1  &&  ofid != -1)
		retcode = convStream(ifid, ofid);
	else
		retcode = err.FILE_OPEN;
	endif
	(ifid != 0)  &&  fclose(ifid);
	(ofid != 1)  &&  fclose(ofid);
endfunction


function res = convStream(ifid, ofid)
	global err;
	res = 0;
	blk = com = "";
	while ((!feof(ifid))  &&  res >= 0)
		blkPrev = blk;
		comPrev = com;
		[blk com] = uncomm(fgets(ifid));
		blkPrev = convStr(blkPrev, blk);
		res = fputs(ofid, [blkPrev comPrev "\r\n"]);
	endwhile
	if (res >= 0)
		blk = convStr(blk, "");
		res = fputs(ofid, [blk com "\r\n"]);
	endif
	if (res >= 0)
		res = 0;
	else
		res = err.FILE_WRITE;
	endif
endfunction


function blkPrev = convStr(blkPrev, blk)
	persistent G=[0 29 40 90]  X=0  Y=0  Z=0  dX=0  dY=0  dZ=0;
	Gprev = G;
	Xprev = X;
	Yprev = Y;
	Zprev = Z;
	dXprev = dX;
	dYprev = dY;
	dZprev = dZ;
	G = gswitch(G, readIntVals(blk, "G"));
	X = nonEmpty(readRealVals(blk, "X"),  X);
	Y = nonEmpty(readRealVals(blk, "Y"),  Y);
	Z = nonEmpty(readRealVals(blk, "Z"),  Z);
	dX = X - Xprev;
	dY = Y - Yprev;
	dZ = Z - Zprev;
	#if (ismember(0, Gprev)  &&  sum(ismember(1:3, G))  &&  !ismember(28, Gprev))
	#	blkPrev = ["G28 "  blkPrev];
	#elseif (sum(ismember(1:3, Gprev))  &&  ismember(0, G)  &&  !ismember(29, Gprev))
	#	blkPrev = ["G29 "  blkPrev];
	#else
	if ((ismember(27, Gprev) || ismember(28, Gprev))
		&&  ((dXprev * dX < 0) || (dYprev * dY < 0) || (dZprev * dZ < 0)))

		blkPrev = ["G9 "  blkPrev];
	endif
endfunction

