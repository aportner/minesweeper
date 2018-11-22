return function(tbl, object)
	for index, value in tbl do
		if value == object then
			return index
		end
	end

	return 0
end