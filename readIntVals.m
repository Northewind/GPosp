function [vals str] = readIntVals(str, addr)
	[s e] = regexpi(str, [addr "\\d+"]);
	vals = [];
	for i = length(s) : -1 : 1
		vals(i) = uint32(str2num(str(
			s(i)+length(addr) : e(i))));
		str(s(i) : e(i)) = [];
	endfor
endfunction
