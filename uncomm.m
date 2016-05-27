function [str com] = uncomm(str)
	## Extract comments, starting with ';'
	str = deblank(str);
	com = "";
	quotCount = 0;
	for i = 1 : length(str)
		switch str(i)
		case '"'
			quotCount = mod(++quotCount, 2);
		case ';'
			if (quotCount == 0)
				com = str(i:end); 
				str = strtrunc(str, i-1);
				break;
			endif
		otherwise	
		endswitch
	endfor
endfunction

