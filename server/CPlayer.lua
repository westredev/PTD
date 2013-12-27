class 'CPlayer'

function CPlayer:__init(player)
    self.player = player
	self.team = nil
	
	Chat:Broadcast("New player created: " .. self.player:GetName(), Color(255, 255, 255))
end

function CPlayer:SetPlayer(player)
	self.player = player
end

function CPlayer:GetPlayer()
	return self.player
end

function CPlayer:SetTeam(team)
	self.team = team
end

function CPlayer:GetTeam()
	return self.team
end

function CPlayer:print()
	print("hello!")
end