function res = nonEmpty(v1, v2)
	if (! isempty(v1))
		res = v1(1);
	elseif (! isempty(v2))
		res = v2(1);
	else
		res = NA;
	endif
endfunction

