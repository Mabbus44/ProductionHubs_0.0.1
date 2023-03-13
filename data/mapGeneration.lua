local noise = require("noise");

local tne = noise.to_noise_expression
local less_than = noise.less_than
local less_or_equal = noise.less_or_equal
local equals = noise.equals
local max = noise.max
local min = noise.min
local floor = noise.floor

local function add(a, b)
	return {
		type = "function-application",
		function_name = "add",
		arguments = {a,b}
	}
end

local function sub(a, b)
	return {
		type = "function-application",
		function_name = "subtract",
		arguments = {a,b}
	}
end

local function mul(a, b)
	return {
		type = "function-application",
		function_name = "multiply",
		arguments = {a,b}
	}
end

local function div(a, b)
	return {
		type = "function-application",
		function_name = "divide",
		arguments = {a,b}
	}
end

local function sqrt(a)
	return {
		type = "function-application",
		function_name = "exponentiate",
		arguments = {a,tne(0.5)}
	}
end

local function regionSize()
	return tne(512)
end

local function maxDist()
	return tne(10000)
end

local function decreaseSpotsDist()
	return tne(3000)
end

local function minRadius()
	return tne(25)
end

local function maxRadiusInc()
	return tne(60)
end

local function dist()
	return min(	sqrt(	add(mul(noise.var("x"), noise.var("x")),
										mul(noise.var("y"), noise.var("y")))),
							maxDist())
end

local function spotRadius()
	return add( mul(div(dist(), maxDist()),
									maxRadiusInc()),
							minRadius())
end

local function spotQuantity()
	return mul(mul(spotRadius(), spotRadius()), tne(0.31415))
end

local function spots()
	return div(	add(sub(maxDist(),dist()),
									decreaseSpotsDist()),
							decreaseSpotsDist())
end

local function density()
	return div(	div(mul(spots(),spotQuantity()),
									regionSize()),
							regionSize())
end

local basicNoise = {
	type = "function-application",
	function_name = "factorio-basis-noise",
	arguments = {
		x = noise.var("x"),
		y = noise.var("y"),
		seed0 = add(noise.var("map_seed"),tne(12)),
		seed1 = tne(17),
		octaves = tne(4),
		input_scale = tne(0.05),
		output_scale = tne(6)
	}
}

local basicNoiseShifted = {
	type = "function-application",
	function_name = "factorio-basis-noise",
	arguments = {
		x = add(noise.var("x"), tne(100)),
		y = add(noise.var("y"), tne(100)),
		seed0 = add(noise.var("map_seed"),tne(65)),
		seed1 = tne(119),
		octaves = tne(4),
		input_scale = tne(0.05),
		output_scale = tne(6)
	}
}

local spotNoise = {
	type = "function-application",
	function_name = "spot-noise",
	arguments = {
		x = add(noise.var("x"),basicNoise),
		y = add(noise.var("y"),basicNoiseShifted),
		seed0 = add(noise.var("map_seed"),tne(17)),
		seed1 = tne(123),
		region_size = regionSize(),
		skip_offset = tne(0),
		skip_span = tne(1),
		candidate_point_count = tne(64),
		suggested_minimum_candidate_point_spacing = tne(150),
		hard_region_target_quantity = tne(false),
		density_expression = {
			type = "literal-expression",
			literal_value = density()
		},
		spot_quantity_expression = {
			type = "literal-expression",
			literal_value = spotQuantity()
		},
		spot_radius_expression = {
			type = "literal-expression",
			literal_value = spotRadius()
		},
		spot_favorability_expression = {
			type = "literal-expression",
			literal_value = tne(1.0)
		},
		basement_value = tne(0.1),
		maximum_spot_basement_radius = add(minRadius(),maxRadiusInc())
	}
}

data:extend{
  {
		type = "noise-expression",
		name = "spots",
		expression = max(spotNoise, mul(less_than(dist(), tne(20)), tne(2)))
  },
  {
		type = "noise-expression",
		name = "unBuildableTerrain",
		expression = max(tne(0.1), less_than(dist(), tne(50)))
  },
  {
		type = "noise-expression",
		name = "zero",
		expression = tne(0.0)
  }
}


