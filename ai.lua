--[[
	ai.lua
	Stores different kinds of AI and their methods.

	Authors:
		Daniel Rolandi
--]]

ai.EASY = 1
ai.MEDIUM = 2
ai.PERFECT = 3

-- angleOffset is given in degrees
local ai =
{
	[ai.EASY] =
	{
		angleOffset = 20
	},

	[ai.MEDIUM] =
	{
		angleOffset = 10
	},

	[ai.PERFECT] =
	{
		angleOffset = 0
	}

}



function calcDegrees()

end