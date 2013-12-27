class 'CArena'

function CArena:__init(name)
	self.name = name
	self.vehicles = {}
	self.secondsRemaining = -1
	self.last_broadcast = 0
	
	self.teamDictator = CTeam("Dictator")
	self.teamSecretPolice = CTeam("Secret Police")
	self.teamMilitary = CTeam("Military")
	self.teamRevolutionary = CTeam("Revolutionaries")
	
	Events:Subscribe("PostTick", self, self.PostTick)
end

function CArena.FindArenaByName(name)
	for key, cArena in ipairs(entityManager:GetArenas()) do
		if entityManager:GetCurrentArenaName() == cArena:GetName() then
			return cArena
		end
	end
end

function CArena.StartRandomArena()
	if entityManager:GetCurrentArenaName() ~= "undefined" then
		CArena.FindArenaByName(entityManager:GetCurrentArenaName()):Unload()
	end
	
	local randomId = math.random(1, table.count(entityManager:GetArenas()))
	entityManager:GetArenas()[randomId]:Load()
end

function CArena:GetName()
	return self.name
end

function CArena:SetSecondsRemaining(sec)
	self.secondsRemaining = sec
end

function CArena:GetSecondsRemaining()
	return self.secondsRemaining
end

function CArena:AddVehicle(cVehicle)
	table.insert(self.vehicles, cVehicle)
end

function CArena:GetVehicles()
	return self.vehicles
end

function CArena:Load()
	self:LoadVehicles()
	
	entityManager:SetCurrentArenaName(self.name)
	
	Network:Broadcast("ShowClientSpawnScreen")
	
	self:SetSecondsRemaining(900)
	
	Chat:Broadcast(self.name .. " has been loaded as the arena!", Color(255, 255, 255))
end

function CArena:Unload()
	self:UnloadVehicles()
	self.teamDictator:ClearMembers()
	self.teamSecretPolice:ClearMembers()
	self.teamMilitary:ClearMembers()
	self.teamRevolutionary:ClearMembers()
	entityManager:SetCurrentArenaName("undefined")
	Chat:Broadcast(self.name .. " has been unloaded as the arena.", Color(255, 255, 255))
end

function CArena:LoadVehicles()
	-- we use table.insert so numeric keys so ipairs!
	local vehiclesLoaded = 0
	for key, cVehicle in ipairs(self.vehicles) do
		cVehicle:CreateActualVehicle()
		vehiclesLoaded = vehiclesLoaded + 1
	end
	print(vehiclesLoaded .. " vehicles loaded.")
end

function CArena:UnloadVehicles()
	for key, cVehicle in ipairs(self.vehicles) do
		cVehicle:Remove()
	end
end

function CArena:PostTick()
    if os.difftime(os.time(), self.last_broadcast) >= 1 then -- 1 second
		if entityManager:GetCurrentArenaName() == self:GetName() then
			self:SetSecondsRemaining(self:GetSecondsRemaining() - 1)
			
			if self:GetSecondsRemaining() == 0 then
				Chat:Broadcast("The dictator has survived!", Color(0, 255, 255))
				CArena.StartRandomArena()
			end		
			self.last_broadcast = os.time()
		end
    end
end

function CArena:GetDictatorTeam()
	return self.teamDictator
end

function CArena:GetSecretPoliceTeam()
	return self.teamSecretPolice
end

function CArena:GetMilitaryTeam()
	return self.teamMilitary
end

function CArena:GetRevolutionariesTeam()
	return self.teamRevolutionary
end

