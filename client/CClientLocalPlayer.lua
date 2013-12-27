class 'CClientLocalPlayer'

function CClientLocalPlayer:__init()
	self.playerTable = {}
	
	Events:Subscribe("LocalPlayerBulletHit", self, self.BulletHit)
	Events:Subscribe("LocalPlayerInput", self, self.CheckInput)
	Network:Subscribe("UpdateTeamDamageValues", self, self.UpdateTeamDamageValues)  
end

function CClientLocalPlayer:BulletHit(args)
	local attacker = args.attacker
	local damage = args.damage
	
	if attacker ~= nil then
		print(" called" )
		if self.playerTable[attacker:GetId()].teamId == "Secret Police" or self.playerTable[attacker:GetId()].teamId == "Military" or self.playerTable[attacker:GetId()].teamId == "Dictator" then
			if self.playerTable[LocalPlayer:GetId()].teamId == "Secret Police" or self.playerTable[LocalPlayer:GetId()].teamId == "Military" or self.playerTable[LocalPlayer:GetId()].teamId == "Dictator" then
				Chat:Print("Friendly!", Color(255, 255, 255))
				return false
			end
		end
		
		if self.playerTable[LocalPlayer:GetId()].teamId == self.playerTable[attacker:GetId()].teamId then
			Chat:Print("Friendly!", Color(255, 255, 255))
			return false
		else
			Chat:Print("UnFriendly!", Color(255, 255, 255))
		end
	end
end


 
function CClientLocalPlayer:CheckInput(args)
	local blacklist = {
		Action.FireGrapple,
		Action.ParachuteOpenClose
	}

	for index, action in ipairs(blacklist) do
		if action == args.input then
			if self.playerTable[LocalPlayer:GetId()].teamId ~= "Secret Police" then
				return false
			else
				return true
			end		
		end
	end
end

function CClientLocalPlayer:UpdateTeamDamageValues(args)
	self.playerTable = args.playerTable
	
	for key, player in pairs(self.playerTable) do
		print("Received: " .. key .. ", " .. player.teamId)
	end
end

cLocalPlayer = CClientLocalPlayer()