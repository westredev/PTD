class 'CCommunication'

function CCommunication:__init()
	self.last_broadcast = 0
	self.canStart = false
	
	Events:Subscribe("ModuleLoad", self, self.ModuleLoad)
    Events:Subscribe("PostTick", self, self.PostTick)
end

function CCommunication:ModuleLoad()
	print("called")
	self.canStart = true
end

function CCommunication:PostTick()
    if os.difftime(os.time(), self.last_broadcast) >= 1 and self.canStart then -- 1 second
		if entityManager:GetCurrentArenaName() ~= "undefined" then
			local curArena = CArena.FindArenaByName(entityManager:GetCurrentArenaName())
			
			--[[ DESTINATION: CClientDebug ]]--
			Network:Broadcast("UpdateValues", 
			{ 
				["teamDictatorCount"] = curArena:GetDictatorTeam():GetMemberCount(),
				["teamSecretPoliceCount"] = curArena:GetSecretPoliceTeam():GetMemberCount(),
				["teamMilitaryCount"] = curArena:GetMilitaryTeam():GetMemberCount(),
				["teamRevolutionariesCount"] = curArena:GetRevolutionariesTeam():GetMemberCount(),
				["secondsRemaining"] = curArena:GetSecondsRemaining(),
				["arenaName"] = curArena:GetName()
			}) 
			
			--[[ DESTINATION: CClientTeamDamage ]]--
			local playerTable = {} -- directly sending entityManager:GetPlayers() will not work? cPlayer is an unsupported type
			for key, cPlayer in pairs(entityManager:GetPlayers()) do
				local teamName = "undefined"
				if cPlayer:GetTeam() ~= nil then
					teamName = cPlayer:GetTeam():GetName()
				end
				
				-- lets use the player id rather than the array's auto increment stated below
				playerTable[cPlayer:GetPlayer():GetId()] = { 
					["teamId"] = teamName 
				}

				--[[table.insert(playerTable, { 
					["playerId"] = cPlayer:GetPlayer():GetId(), 
					["teamId"] = teamName
				})--]]
			end
			
			Network:Broadcast("UpdateTeamDamageValues", 
			{ 
				["playerTable"] = playerTable
			}) 
			
			self.last_broadcast = os.time()
		end
    end
end

cCommunication = CCommunication()
