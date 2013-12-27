class 'CVehicle'

function CVehicle:__init(vehicleId, vector, angle)
	self.vehicleId = vehicleId
	self.vector = vector
	self.angle = angle
	self.id = nil -- holds the actual vehicle reference
end

function CVehicle:GetVector()
	return self.vector
end

function CVehicle:GetAngle()
	return self.angle
end

function CVehicle:GetVehicleId()
	return self.vehicleId
end

function CVehicle:GetId()
	return self.id
end

function CVehicle:CreateActualVehicle()
	local vehicle = Vehicle.Create(self.vehicleId, self.vector, self.angle)
	vehicle:SetUnoccupiedRespawnTime(120) -- 2 minutes
	vehicle:SetDeathRespawnTime(30) -- 5 seconds
	self.id = vehicle:GetId()
end

function CVehicle:Remove()
	if self.id ~= nil then
		local vehicle = Vehicle.GetById(self.id)
		vehicle:Remove()
	end
end
