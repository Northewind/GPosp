function retcode = CircIJConv(varargin);
	global err;
	errInit();
	switch nargin
	case 1
		ovar = varargin{1};
		ifid = stdin();
		ofid = stdout();
	case 2
		ovar = varargin{1};
		ifid = fopen(varargin{2}, "r");
		ofid = stdout();
	case 3
		ovar = varargin{1};
		ifid = fopen(varargin{2}, "r");
		ofid = fopen(varargin{3}, "w");
	otherwise
		retcode = err.CMD_ARG_NUM;
		return;
	endswitch
	if (ifid != -1  &&  ofid != -1)
		retcode = convStream(ovar, ifid, ofid);
	else
		retcode = err.FILE_OPEN;
	endif
	(ifid != 0)  &&  fclose(ifid);
	(ofid != 1)  &&  fclose(ofid);
endfunction


function res = convStream(ovar, ifid, ofid)
	global err;
	res = 0;
	if (strcmp(ovar, "abs"))
		ovarf = @conv2abs;
	elseif (strcmp(ovar, "rad"))
		ovarf = @conv2rad;
	else
		res = err.CMD_ARG_VAL;
		return;
	endif
	while ((!feof(ifid))  &&  res >= 0)
		res = fputs(ofid, remMultipleSpaces(ovarf(fgets(ifid))));
	endwhile
	if (res >= 0)
		res = 0;
	else
		res = err.FILE_WRITE;
	endif
endfunction


function str = conv2abs(str)
	persistent G=[]  X=0  Y=0  I=0  J=0;
	G = gswitch(G, readIntVals(str, "G"));
	if (length(intersect(G, [2 3])) > 0)
		Xnew = readRealVals(str, "X");
		Ynew = readRealVals(str, "Y");
		[Inew, str] = readRealVals(str, "I");
		[Jnew, str] = readRealVals(str, "J");
		X = nonEmpty(Xnew, X);
		Y = nonEmpty(Ynew, Y);
		I = nonEmpty(Inew, I);
		J = nonEmpty(Jnew, J);
		str = sprintf("%s I%g J%g\r\n", str(1:end-2),  X+I,  Y+J);
	endif
endfunction


function str = conv2rad(str)
	persistent G=[]  I=0  J=0;
	G = gswitch(G, readIntVals(str, "G"));
	if (length(intersect(G, [2 3])) > 0)
		[Inew, str] = readRealVals(str, "I");
		[Jnew, str] = readRealVals(str, "J");
		I = nonEmpty(Inew, I);
		J = nonEmpty(Jnew, J);
		R = norm([I J]);
		str = sprintf("%s R%g\r\n",  str(1:end-2),  R);
	endif
endfunction


function str = remMultipleSpaces(str)
	str = regexprep(str, " {2,}", " ");
endfunction

