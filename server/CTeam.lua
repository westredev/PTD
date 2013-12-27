class 'CTeam'

function CTeam:__init(teamName)
    self.teamName = teamName
	self.members = {}
	self.spawnPoint = nil
end

function CTeam:SetName(name)
	self.teamName = name
end

function CTeam:GetName()
	return self.teamName
end

function CTeam:GetMembers()
	return self.members
end

function CTeam:GetMemberCount()
	local count = 0
	for key, value in pairs(self.members) do
		count = count + 1
	end
	return count
end

function CTeam:SetMembers(memberTable)
	self.members = memberTable
end

function CTeam:AddMember(cPlayer)
	table.insert(self.members, cPlayer)
	
	print(cPlayer:GetPlayer():GetName() .. " has been added to team " .. self.teamName .. " team count: " .. self:GetMemberCount())
	Chat:Broadcast(cPlayer:GetPlayer():GetName() .. " has been added to team " .. self.teamName .. " team count: " .. self:GetMemberCount(), Color(255, 255, 255))
end

function CTeam:ClearMembers()
	for key, value in pairs(self.members) do
		table.remove(self.members, key)
	end
end

function CTeam:DelMember(cPlayer)
	-- self.members[cPlayer] = nil doesnt work?
	-- ofcourse not, we use table.insert, the key is an int, not a CPlayer objecT!!
	
	for key, value in pairs(self.members) do
		if(value == cPlayer) then
			print("ref found!")
			cPlayer:SetTeam(nil)
			table.remove(self.members, key)
		end
	end

	print(cPlayer:GetPlayer():GetName() .. " has been removed from team " .. self.teamName .. " team count: " .. self:GetMemberCount())
	Chat:Broadcast(cPlayer:GetPlayer():GetName() .. " has been removed from team " .. self.teamName .. " team count: " .. self:GetMemberCount(), Color(255, 255, 255))
end

function CTeam:SetSpawnPoint(vaTable)
	self.spawnPoint = vaTable
end

function CTeam:GetSpawnPoint()
	return self.spawnPoint
end

function CTeam:print()
	print("Team Name: " .. self:GetName())
end