local noise = require("noise");

local tne = noise.to_noise_expression
local expr = {
      type = "function-application",
      function_name = "factorio-basis-noise",
      arguments = {
        x = noise.var("x"),
        y = noise.var("y"),
        seed0 = tne(noise.var("map_seed")), -- i.e. map.seed
        seed1 = tne(123), -- Some random number
        input_scale = noise.var("segmentation_multiplier")/50.7,
        output_scale = 20/noise.var("segmentation_multiplier")
      }
    }

data:extend{
  {
		type = "noise-expression",
		name = "forest",
		expression = {
			type = "function-application",
			function_name = "multiply",
			arguments = {
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					{type = "literal-number",
						literal_value = 20},
					{
						type = "function-application",
						function_name = "factorio-basis-noise",
						arguments = {
							x = noise.var("x"),
							y = noise.var("y"),
							seed0 = {
								type = "function-application",
								function_name = "add",
								arguments = {
									tne(noise.var("map_seed")),
									{type = "literal-number",
										literal_value = 76}
									}
								},
							seed1 = tne(123), -- Some random number
							input_scale = noise.var("segmentation_multiplier")/50.7,
							output_scale = 20/noise.var("segmentation_multiplier")
						}
					}
				}
			},
			{type = "literal-number",
				literal_value = 150}
			}
		}
  },
  {
		type = "noise-expression",
		name = "montain",
		expression = {
			type = "function-application",
			function_name = "multiply",
			arguments = {
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					{type = "literal-number",
						literal_value = 20},
					{
						type = "function-application",
						function_name = "factorio-basis-noise",
						arguments = {
							x = noise.var("x"),
							y = noise.var("y"),
							seed0 = {
								type = "function-application",
								function_name = "add",
								arguments = {
									tne(noise.var("map_seed")),
									{type = "literal-number",
										literal_value = 17}
									}
								},
							seed1 = tne(123), -- Some random number
							input_scale = noise.var("segmentation_multiplier")/50.7,
							output_scale = 20/noise.var("segmentation_multiplier")
						}
					}
				}
			},
			{type = "literal-number",
				literal_value = 200}
			}
		}
  },
  {
    type = "noise-expression",
    name = "dryLvl1",
    expression = {
      type = "function-application",
      function_name = "multiply",
      arguments = {
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					expr,
					{type = "literal-number",
					literal_value = -32}
					}
				},
				{type = "literal-number",
				literal_value = 100}
			}
    }
  },
  {
    type = "noise-expression",
    name = "dryLvl2",
    expression = {
      type = "function-application",
      function_name = "multiply",
      arguments = {
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					{type = "literal-number",
					literal_value = -32},
					expr
					}
				},
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					expr,
					{type = "literal-number",
					literal_value = -26}
					}
				},
				{type = "literal-number",
				literal_value = 100}
			}
    }
  },
  {
    type = "noise-expression",
    name = "dryLvl3",
    expression = {
      type = "function-application",
      function_name = "multiply",
      arguments = {
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					{type = "literal-number",
					literal_value = -26},
					expr
					}
				},
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					expr,
					{type = "literal-number",
					literal_value = -20}
					}
				},
				{type = "literal-number",
				literal_value = 100}
			}
    }
  },
  {
    type = "noise-expression",
    name = "dryLvl4",
    expression = {
      type = "function-application",
      function_name = "multiply",
      arguments = {
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					{type = "literal-number",
					literal_value = -20},
					expr
					}
				},
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					expr,
					{type = "literal-number",
					literal_value = -14}
					}
				},
				{type = "literal-number",
				literal_value = 100}
			}
    }
  },
  {
    type = "noise-expression",
    name = "dryLvl5",
    expression = {
      type = "function-application",
      function_name = "multiply",
      arguments = {
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					{type = "literal-number",
					literal_value = -14},
					expr
					}
				},
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					expr,
					{type = "literal-number",
					literal_value = 0}
					}
				},
				{type = "literal-number",
				literal_value = 100}
			}
    }
  },
  {
    type = "noise-expression",
    name = "dryLvl6",
    expression = {
      type = "function-application",
      function_name = "multiply",
      arguments = {
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					{type = "literal-number",
					literal_value = 0},
					expr
					}
				},
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					expr,
					{type = "literal-number",
					literal_value = 15}
					}
				},
				{type = "literal-number",
				literal_value = 100}
			}
    }
  },
  {
    type = "noise-expression",
    name = "dryLvl7",
    expression = {
      type = "function-application",
      function_name = "multiply",
      arguments = {
				{type = "function-application",
				function_name = "less-than",
				arguments = {
					{type = "literal-number",
					literal_value = 15},
					expr
					}
				},
				{type = "literal-number",
				literal_value = 100}
			}
    }
  },
}


