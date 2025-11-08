--[[
This file is for use by Benchmarker (https://boatbomber.itch.io/benchmarker)

|WARNING| THIS RUNS IN YOUR REAL ENVIRONMENT. |WARNING|
--]]

local function shuffle(t, seed)
	for i = #t, 2, -1 do
		local j = Random.new(seed):NextInteger(1, i)

		t[i], t[j] = t[j], t[i]
	end
end
local function rebuild(seed) -- Could improve by just picking random, unselected indices
	local t = table.create(16)

	for n = 0, 15 do
		local a = (n//8)%2 == 1
		local b = (n//4)%2 == 1
		local c = (n//2)%2 == 1
		local d = (n//1)%2 == 1
		t[#t+1] = {a, b, c, d}
	end

	shuffle(t, seed)

	return t
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
local reversed_table = false

if reversed_table then
	for i = 1, #booleans/2 do -- Could save two pointers but this runs aside from the benchmark
		booleans[i], booleans[#booleans-i+1] = booleans[#booleans-i+1], booleans[i]
	end
end

local iterations = 10^4
local randomized_order = true
local runner = function(fn, randomized_order)
	for __ = 1, iterations do
		local final_booleans = randomized_order and rebuild(0) or booleans

		for _, quad in final_booleans do
			fn(table.unpack(quad))
		end
	end
end

return {
	ParameterGenerator = function()
		return	
	end,

	BeforeAll = function() end,
	AfterAll = function() end,
	BeforeEach = function() end,
	AfterEach = function() end,

	Functions = {
		["full_dnf"] = function(Profiler)
			runner(full_dnf)
		end,

		["simplified_dnf"] = function(Profiler)
			runner(simplified_dnf)
		end,

		["simplified_cnf"] = function(Profiler)
			runner(simplified_cnf)
		end,

		["conditional_1"] = function(Profiler)
			runner(conditional_1)
		end,

		["conditional_2"] = function(Profiler)
			runner(conditional_2)
		end,
	},
}
