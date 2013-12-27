class 'CGame'

function CGame:__init()
	self.last_broadcast = 0
	
	Events:Subscribe("ModulesLoad", self, self.ModuleLoad)
	Events:Subscribe("ModuleUnload", self, self.ModuleUnload)
	Events:Subscribe("PlayerJoin", self, self.PlayerConnect)
	Events:Subscribe("PlayerSpawn", self, self.PlayerSpawn)
	Events:Subscribe("PlayerQuit", self, self.PlayerQuit)
	Events:Subscribe("PlayerDeath", self, self.PlayerDeath)
	self.delayedStart = Events:Subscribe("PostTick", self, self.DelayedStart)
	
	Network:Subscribe("SetPlayerInTeam", self, self.SetPlayerInTeam)  
end

function CGame:ModuleLoad()
	entityManager = CEntityManager()
	
	-- clear chat
	for i = 1, 10 do
		Chat:Broadcast("", Color(0))
	end
	
	-- init player upon module load, otherwise NPE
	for player in Server:GetPlayers() do
		local exists = sql:GetPlayerData(player)
	
		if exists then
			player:SendChatMessage("Welcome back!", Color(255, 255, 255))
		else
			player:SendChatMessage("Your account has been created, welcome!", Color(255, 255, 255))
		end
		
		entityManager:GetPlayers()[player:GetId()] = CPlayer(player)
		
		if entityManager:GetCurrentArenaName() ~= "undefined" then
			player:SendChatMessage("Current map running: " .. entityManager:GetCurrentArenaName(), Color(255, 255, 255))
			Network:Send(player, "ShowClientSpawnScreen")
		else
			player:SendChatMessage("No map running!", Color(255, 0, 0))
		end
	
		player:SendChatMessage("reloaded", Color(255, 255, 255))
	end
	
	-- init arenas
	local arena = CArena("Desert Arena by westre")
	
	local rVehicleIds = {63, 86, 10, 91}
	local gVehicleIds = {87, 46}
	
	local x = -9460
	local z = 3009
	for i = 1, 10 do 
		arena:AddVehicle(CVehicle(table.randomvalue(rVehicleIds), Vector3(x, 604, z), Angle(0.0043457695282996, 0.41196659207344, -0.0019943485967815)))
		x = x - 4 
		z = z - 4
	end
	
	x = -9449
	z = 2970
	for i = 1, 10 do 
		arena:AddVehicle(CVehicle(table.randomvalue(rVehicleIds), Vector3(x, 604, z), Angle(0.0043457695282996, 0.41196659207344, -0.0019943485967815)))
		x = x - 4 
		z = z - 4
	end
	
	x = -9438
	z = 2940
	for i = 1, 10 do 
		arena:AddVehicle(CVehicle(table.randomvalue(rVehicleIds), Vector3(x, 604, z), Angle(0.0043457695282996, 0.41196659207344, -0.0019943485967815)))
		x = x - 4 
		z = z - 4
	end
	
	x = -9692
	z = 3242
	for i = 1, 10 do 
		arena:AddVehicle(CVehicle(table.randomvalue(gVehicleIds), Vector3(x, 604, z), Angle(0.0043457695282996, 0.41196659207344, -0.0019943485967815)))
		x = x - 4 
		z = z - 4
	end
	
	x = -9676
	z = 3242
	for i = 1, 10 do 
		arena:AddVehicle(CVehicle(table.randomvalue(gVehicleIds), Vector3(x, 604, z), Angle(0.0043457695282996, 0.41196659207344, -0.0019943485967815)))
		x = x - 4 
		z = z - 4
	end
	
	x = -9650
	z = 3242
	for i = 1, 10 do 
		arena:AddVehicle(CVehicle(table.randomvalue(gVehicleIds), Vector3(x, 604, z), Angle(0.0043457695282996, 0.41196659207344, -0.0019943485967815)))
		x = x - 4 
		z = z - 4
	end
	
	arena:GetDictatorTeam():SetSpawnPoint( {["vector3"] = Vector3(-9685.7001953125, 601.45245361328, 3252.1813964844), ["angle"] = Angle(0, 0.90920698642731, 0)} )
	arena:GetSecretPoliceTeam():SetSpawnPoint( {["vector3"] = Vector3(-9685.7001953125, 601.45245361328, 3252.1813964844), ["angle"] = Angle(0, 0.90920698642731, 0)} )
	arena:GetMilitaryTeam():SetSpawnPoint( {["vector3"] = Vector3(-9685.7001953125, 601.45245361328, 3252.1813964844), ["angle"] = Angle(0, 0.90920698642731, 0)} )
	arena:GetRevolutionariesTeam():SetSpawnPoint( {["vector3"] = Vector3(-9479.5185546875, 604.15380859375, 2979.8190917969), ["angle"] = Angle(0, 0.97669154405594, 0)} )
	
	entityManager:RegisterArena(arena)
end

function CGame:ModuleUnload()
	if entityManager:GetCurrentArenaName() ~= "undefined" then
		CArena.FindArenaByName(entityManager:GetCurrentArenaName()):Unload()
	end
end

function CGame:DelayedStart()
    if os.difftime(os.time(), self.last_broadcast) >= 5 then -- 5 seconds
		print("called2")
		CArena.StartRandomArena()
		self.last_broadcast = os.time()
		Events:Unsubscribe(self.delayedStart)
    end
end

function CGame:PlayerConnect(args)
	local player = args.player

	local exists = sql:GetPlayerData(player)
	
	if exists then
		player:SendChatMessage("Welcome back!", Color(255, 255, 255))
	else
		player:SendChatMessage("Your account has been created, welcome!", Color(255, 255, 255))
	end
	
	entityManager:GetPlayers()[player:GetId()] = CPlayer(player)
	
	if entityManager:GetCurrentArenaName() ~= "undefined" then
		player:SendChatMessage("Current map running: " .. entityManager:GetCurrentArenaName(), Color(255, 255, 255))
		Network:Send(player, "ShowClientSpawnScreen")
	else
		player:SendChatMessage("No map running!", Color(255, 0, 0))
	end
	
end

function CGame:PlayerSpawn(args)
	local player = args.player
	local cPlayer = entityManager:GetPlayers()[player:GetId()]
	
	if cPlayer:GetTeam() ~= nil then
		if cPlayer:GetTeam():GetName() == "undefined" then
			player:SetPosition(Vector3(-6550, 219, -3290))
		else
			player:SetPosition(cPlayer:GetTeam():GetSpawnPoint().vector3)
		end
	end
	return false
end

function CGame:PlayerQuit(args)
	local player = args.player
	
	if entityManager:GetPlayers()[player:GetId()] ~= nil then
		local cPlayer = entityManager:GetPlayers()[player:GetId()]
		if cPlayer:GetTeam():GetName() == "Dictator" then
			Chat:Broadcast("The dictator has left. GG.", Color(255, 0, 0))
			CArena.StartRandomArena()
		end
		
		if cPlayer:GetTeam() ~= nil then
			cPlayer:GetTeam():DelMember(cPlayer)
		end
		entityManager:GetPlayers()[player:GetId()] = nil
	end
end

function CGame:PlayerDeath(args)
	local cPlayer = entityManager:GetPlayers()[args.player:GetId()]
	if cPlayer:GetTeam():GetName() == "Dictator" then
		Chat:Broadcast("The dictator has died. GG.", Color(255, 0, 0))
		CArena.StartRandomArena()
	end
end

function CGame:SetPlayerInTeam(args) -- called from CClientSpawnScreen
	local team = args[1]
	local playerId = args[2]
	
	local player = Player.GetById(playerId)
	local cPlayer = entityManager:GetPlayers()[playerId]
	
	local curArena = CArena.FindArenaByName(entityManager:GetCurrentArenaName())
	
	if team == "dictator" then
		if curArena:GetDictatorTeam():GetMemberCount() > 0 then
			Network:Send(player, "ShowClientSpawnScreen")
			player:SendChatMessage("This team is full!", Color(255, 0, 0))
			return
		end
		
		curArena:GetDictatorTeam():AddMember(cPlayer)
		cPlayer:GetPlayer():SetPosition(curArena:GetDictatorTeam():GetSpawnPoint().vector3)
		cPlayer:GetPlayer():SetColor(Color(255, 255, 0))
		cPlayer:SetTeam(curArena:GetDictatorTeam())
		
		player:ClearInventory()
		player:GiveWeapon(WeaponSlot.Left, Weapon(Weapon.Revolver, 6, 1000))
		player:SetModelId(74)
		
		Network:Send(player, "ShowDialog", 
		{ 
			["title"] = "Welcome Dictator!",
			["content"] = "Hello sir! These filty revolutionaries want to see our government (read: you) overthrown and install a democracy. Hold them off for 10 minutes!\n\nYour allies: Secret Police (green), Military (blue)"
		})
	elseif team == "secret police" then
		if curArena:GetSecretPoliceTeam():GetMemberCount() > 5 then
			Network:Send(player, "ShowClientSpawnScreen")
			player:SendChatMessage("This team is full!", Color(255, 0, 0))
			return
		end
		
		curArena:GetSecretPoliceTeam():AddMember(cPlayer)
		cPlayer:GetPlayer():SetPosition(curArena:GetSecretPoliceTeam():GetSpawnPoint().vector3)
		cPlayer:GetPlayer():SetColor(Color(0, 255, 0))
		cPlayer:SetTeam(curArena:GetSecretPoliceTeam())
		
		player:ClearInventory()
		player:GiveWeapon(WeaponSlot.Left, Weapon(Weapon.SMG, 30, 1000))
		player:GiveWeapon(WeaponSlot.Right, Weapon(Weapon.SMG, 30, 1000))
		player:GiveWeapon(WeaponSlot.Primary, Weapon(Weapon.Shotgun, 30, 1000))
		player:SetModelId(54)
		
		Network:Send(player, "ShowDialog", 
		{ 
			["title"] = "Welcome Agent!",
			["content"] = "Your objective is to defend your great leader at all costs! Grapple hook and parachute are all yours.\n\nYour allies: Dictator (yellow), Military (blue)"
		})
	elseif team == "military" then
		curArena:GetMilitaryTeam():AddMember(cPlayer)
		cPlayer:GetPlayer():SetPosition(curArena:GetMilitaryTeam():GetSpawnPoint().vector3)
		cPlayer:GetPlayer():SetColor(Color(0, 0, 255))
		cPlayer:SetTeam(curArena:GetMilitaryTeam())
		
		player:ClearInventory()
		player:GiveWeapon(WeaponSlot.Left, Weapon(Weapon.Handgun, 30, 1000))
		player:GiveWeapon(WeaponSlot.Primary, Weapon(Weapon.Assault, 30, 1000))
		player:SetModelId(66)
		
		Network:Send(player, "ShowDialog", 
		{ 
			["title"] = "Welcome Soldier!",
			["content"] = "Your objective is to defend your great leader at all costs! Use your body for the great leader's protection.\n\nYour allies: Dictator (yellow), Secret Police (green)"
		})
	elseif team == "revolutionary" then
		curArena:GetRevolutionariesTeam():AddMember(cPlayer)
		cPlayer:GetPlayer():SetPosition(curArena:GetRevolutionariesTeam():GetSpawnPoint().vector3)
		cPlayer:GetPlayer():SetColor(Color(255, 0, 0))
		cPlayer:SetTeam(curArena:GetRevolutionariesTeam())
		
		player:ClearInventory()
		player:GiveWeapon(WeaponSlot.Left, Weapon(Weapon.Handgun, 30, 1000))
		player:GiveWeapon(WeaponSlot.Primary, Weapon(Weapon.Assault, 30, 1000))
		player:SetModelId(79)
		
		Network:Send(player, "ShowDialog", 
		{ 
			["title"] = "Welcome Soldier!",
			["content"] = "Just kill the dictator (yellow)"
		})
	end
end

game = CGame()
