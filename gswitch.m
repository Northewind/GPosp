function res = gswitch(gold, gnew)
	res = gold;
	gmodgr = {[0:3];  [9];  [17:19];  [27:29];  [40:42];  [79];  [80:84];  [90 91];  [94 95]};
	for i = 1 : length(gnew)
		chg = 0;
		for j = 1 : length(gmodgr)
			if (ismember(gnew(i), gmodgr{j}))
				res = setdiff(res, gmodgr{j});
				res = union(res, gnew(i));
				chg = 1;
				break;
			endif
		endfor
		if (! chg)
			warning(["Unsupported G-code found: ", num2str(gnew(i))]);
			res = union(res, gnew(i));
		endif
	endfor
endfunction

