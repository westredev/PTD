class 'CCommand'

function CCommand:__init()
    Events:Subscribe("PlayerChat", self, self.CommandMessage)
end

function CCommand:CommandMessage(args)
    local msg = args.text
	local split_msg = msg:split(" ")
    local player = args.player
    
	print("called")
	
    -- If the string is't a command, we're not interested!
    if ( msg:sub(1, 1) ~= "/" ) then
        return true
    end    
    
	--[[if split_msg[1] == "/sc" then
		print("spam2: " .. player:GetWorld():GetId())
		for player in player:GetWorld():GetVehicles() do
			print("spam")
		end
	end
	
	if split_msg[1] == "/sp" then
		local veh = player:GetVehicle()
		print(tostring(veh:GetOccupants()))
	end
	
	if split_msg[1] == "/spawnarena" then
		print("spawn called")
		entityManager:GetArenas()[1]:Load()
	end
	
	if split_msg[1] == "/spawnarena2" then
		print("spawn called")
		entityManager:GetArenas()[2]:Load()
	end
    
	if split_msg[1] == "/delarena" then
		print("delarena called")
		entityManager:GetArenas()[1]:Unload()
	end]]--
	
	if split_msg[1] == "/kill" then
		player:SetHealth(0)
	end
	
	if split_msg[1] == "/test" then
		Network:Send(player, "ShowDialog", 
		{ 
			["title"] = "Dialog",
			["content"] = "hey there AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
		}) -- CClientDialog
	end
	
	if split_msg[1] == "/savepos" then
		local file = io.open("positions.txt", "a")
		
		if player:InVehicle() == false then
			file:write("Vector3(" .. player:GetPosition().x .. ", " .. player:GetPosition().y .. ", " .. player:GetPosition().z .. "), Angle(" .. player:GetAngle().x .. ", " .. player:GetAngle().y .. ", " .. player:GetAngle().z .. ")\n")
			file:close()
		else
			local vehicle = player:GetVehicle()
			file:write("Vector3(" .. vehicle:GetPosition().x .. ", " .. vehicle:GetPosition().y .. ", " .. vehicle:GetPosition().z .. "), Angle(" .. vehicle:GetAngle().x .. ", " .. vehicle:GetAngle().y .. ", " .. vehicle:GetAngle().z .. ")\n")
			file:close()
		end
		
		player:SendChatMessage("Written to file", Color(255, 255, 255))
	end
	
    return false
end

cCommand = CCommand()