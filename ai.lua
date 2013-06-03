--[[
	ai.lua
	Stores different kinds of AI and their methods

	Authors:
		Daniel Rolandi
--]]

ai = {}

ai.EASY = 1
ai.MEDIUM = 2
ai.PERFECT = 3

-- angleOffset is given in degrees
local aiTable =
{
	[ai.EASY] =
	{
		angleOffset = 14
	},

	[ai.MEDIUM] =
	{
		angleOffset = 7
	},

	[ai.PERFECT] =
	{
		angleOffset = 0
	}

}

-- Find the absolute angle (degrees) of perfect shooting
-- @param ai The level of AI
function calcAIPower(ai)	
	-- assume AI is always Player 2
	local tank1 = TankManager.getPlayerTank(1)
	local tank2 = TankManager.getPlayerTank(2)
	local angleOffset = aiTable[ai].angleOffset
	-- magic formula
	-- so the AI is less dumb when WIND is in effect
	angleOffset = math.max((3 - ai)*7 - 3*WIND/METER_SIZE, 3 - ai)

	local xSource, ySource = tank2:getBarrelPos()
	local xTarget, yTarget = tank1:getBarrelPos()
	-- th is short for theta
	local th = tank2:getAbsoluteBarrelAngle()

	local dx = (xTarget - xSource) * METER_SIZE
	local dy = (yTarget - ySource) * METER_SIZE	
	th = math.random(th - angleOffset, th + angleOffset)	
	th = math.rad(th)
	-- wind acceleration is WIND
	-- gravity acceleration is GRAVITY	

	-- magical constants used in the formula
	-- these were found in the process of derivation
	-- (not differentiation)
	-- pardon the nondescriptive single-letters
	-- because indeed these constants carry no meaning
	-- other than reducing typing
	local p = dy * math.cos(th) - dx * math.sin(th)
	local q = dx * (GRAVITY/METER_SIZE) - dy * (WIND/METER_SIZE)
	local r = q * math.cos(th) + p * (WIND/METER_SIZE)

	local power = dx * q * q / (2.0 * p * r )

	-- if it happens that this part is negative
	-- we cannot proceed to the sqrt
	-- therefore, force a recalculation
	if power < 0 then
		power = -1000
	else
		power = math.sqrt(power)
	end

	power = power / METER_SIZE
	
	if DEBUG then
		---[[
		local file = io.open("aitest.txt", "a")

		file:write("angleOffset = " .. angleOffset .."\n")
		file:write("x,y source = " .. xSource .. ", " .. ySource .."\n")
		file:write("x,y target = " .. xTarget .. ", " .. yTarget .."\n")
		file:write("th = " .. math.deg(th) .."\n")		
		file:write("dx = " .. dx .."\n")
		file:write("dy = " .. dy .."\n")		
		file:write("" .."\n")
		file:write("p = " .. p .."\n")
		file:write("q = " .. q .."\n")
		file:write("r = " .. r .."\n")		
		file:write("power = " .. power .."\n")
		file:write("" .."\n")
		file:close()
		--]]
	end

	return power
end