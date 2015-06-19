function  [vals str] = readRealVals(str, addr)
	[s,e] = regexpi(str, [addr "[+-]?\\d*\\.?\\d*"]);
	vals = [];
	for i = length(s) : -1 : 1
		if (s(i) == e(i))
			continue;
		endif
		vals(i) = str2num(str(s(i)+length(addr) : e(i)));
		str(s(i) : e(i)) = [];
	endfor
endfunction
