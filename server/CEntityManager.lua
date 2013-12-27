class 'CEntityManager'

function CEntityManager:__init()
    self.players = {} -- index = playerId, value = CPlayer
	
	self.arenas = {} -- index = int, value = CArena
	self.currentArenaName = "undefined"
end

function CEntityManager:GetPlayers()
	return self.players
end

function CEntityManager:RegisterArena(cArena)
	table.insert(self.arenas, cArena)
end

function CEntityManager:GetArenas()
	return self.arenas
end

function CEntityManager:SetCurrentArenaName(strArena)
	self.currentArenaName = strArena
end

function CEntityManager:GetCurrentArenaName()
	return self.currentArenaName
end