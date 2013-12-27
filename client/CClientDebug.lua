class 'CClientDebug'

function CClientDebug:__init()
	self.dictatorCount = 0
	self.spCount = 0
	self.militaryCount = 0
	self.revCount = 0
	self.seconds = -1
	self.arenaName = "undefined"
	
	Events:Subscribe( "Render", self, self.Render )
	
	Network:Subscribe("UpdateValues", self, self.UpdateValues)  
end

function CClientDebug:Render()
    local text = "3d text"

    local text_width = Render:GetTextWidth( text, TextSize.Default )
    local text_height = Render:GetTextHeight( text, TextSize.Default )

    --local pos = Vector2((Render.Width - text_width)/2, (Render.Height - text_height)/2)
	local pos = Vector2((Render.Width - text_width)/2, 10)

    Render:DrawText(pos, "Map Loaded: " .. self.arenaName .. "\nDictator: (" .. self.dictatorCount .. "/1)\nSecret Police: (" .. self.spCount .. "/6)\nMilitary: (" .. self.militaryCount .. ")\nRevolutionaries: (" .. self.revCount .. ")\nSeconds Remaining: " .. self.seconds, Color( 255, 255, 255 ), TextSize.Default)
end

function CClientDebug:UpdateValues(serverTable)
	self.dictatorCount = serverTable.teamDictatorCount
	self.spCount = serverTable.teamSecretPoliceCount
	self.militaryCount = serverTable.teamMilitaryCount
	self.revCount = serverTable.teamRevolutionariesCount
	self.seconds = serverTable.secondsRemaining
	self.arenaName = serverTable.arenaName
end

debugScreen = CClientDebug()