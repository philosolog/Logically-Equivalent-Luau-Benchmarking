local function all(t)
	local last = t[1]
	
	for i, v in t do
		if v ~= t[i%#t+1] then
			print(table.unpack(t))
			
			return false
		end
	end
	
	return true
end
local full_dnf = function(a, b, c, d) -- 43, 31, 8
	return (not a and b and c and not d)
		or (a and not b and not c and not d)
		or (a and not b and not c and d)
		or (a and not b and c and not d)
		or (a and not b and c and d)
		or (a and b and not c and not d)
		or (a and b and not c and d)
		or (a and b and c and not d)
end
local simplified_dnf = function(a, b, c, d) -- 12, 6, 3
	return (a and not c) or (a and not b) or (b and c and not d)
end
local simplified_cnf = function(a, b, c, d) -- 12, 6, 3
	return (a or b) and (a or c) and (not b or not c or not d)
end
local conditional_1 = function(a, b, c, d) -- 6, 2, 2
	if b then
		if c then
			return not d
		else
			return a
		end
	else
		return a
	end
end
local conditional_2 = function(a, b, c, d) -- 19, 9, 5
	if a then
		if (not c) or (not b) then
			return true
		elseif b and c and not d then
			return true
		else
			return false
		end
	elseif b and c and not d then
		return true
	else
		return false
	end
end
--local false_debug = function()
--	return false
--end
local booleans = {
	{false, false, false, false},
	{false, false, false, true},
	{false, false, true, false},
	{false, false, true, true},
	{false, true, false, false},
	{false, true, false, true},
	{false, true, true, false},
	{false, true, true, true},
	{true, false, false, false},
	{true, false, false, true},
	{true, false, true, false},
	{true, false, true, true},
	{true, true, false, false},
	{true, true, false, true},
	{true, true, true, false},
	{true, true, true, true},
}
local functions = {
	full_dnf,
	simplified_dnf,
	--full_cnf,
	simplified_cnf,
	conditional_1,
	conditional_2,
	--false_debug
}
local equivalent = true
--local iterations = 0

for _, quad in booleans do
	if not equivalent then
		break
	end
	
	--iterations += 1
	local baseline = functions[1](table.unpack(quad))

	for i = 2, #functions do
		if functions[i](table.unpack(quad)) ~= baseline then
			equivalent = false
			
			break
		end
	end
end

--print(iterations)
print(equivalent and "Equivalent" or "Not equivalent")
