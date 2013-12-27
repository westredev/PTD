class 'CClientSpawnScreen'

function CClientSpawnScreen:__init()
	self.active = false
	self.playerJoined = false -- temp fix
	
	self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.5, 0.45 ) )
	self.window:SetPositionRel( Vector2( 0.5, 0.5 ) - self.window:GetSizeRel() / 2 )
	self.window:SetTitle( "Spawn" )
	self.window:SetVisible( self.active )
	
	self.buttonDictator = Button.Create(self.window)
	self.buttonDictator:SetPositionRel(Vector2(0, 0))
    self.buttonDictator:SetSizeRel(Vector2( 1, 0.15 ))
	self.buttonDictator:SetText("Play as Dictator")
	self.buttonDictator:Subscribe("Press", self, self.DictatorPress)
	
	self.buttonSecretPolice = Button.Create(self.window)
	self.buttonSecretPolice:SetPositionRel(Vector2(0, 0.25))
    self.buttonSecretPolice:SetSizeRel(Vector2( 1, 0.15 ))
	self.buttonSecretPolice:SetText("Play as Secret Police")
	self.buttonSecretPolice:Subscribe("Press", self, self.SecretPolicePress)
	
	self.buttonMilitary = Button.Create(self.window)
	self.buttonMilitary:SetPositionRel(Vector2(0, 0.50))
    self.buttonMilitary:SetSizeRel(Vector2( 1, 0.15 ))
	self.buttonMilitary:SetText("Play as Military")
	self.buttonMilitary:Subscribe("Press", self, self.MilitaryPress)
	
	self.buttonRevolutionaries = Button.Create(self.window)
	self.buttonRevolutionaries:SetPositionRel(Vector2(0, 0.75))
    self.buttonRevolutionaries:SetSizeRel(Vector2( 1, 0.15 ))
	self.buttonRevolutionaries:SetText("Play as Revolutionary")
	self.buttonRevolutionaries:Subscribe("Press", self, self.RevolutionaryPress)
	
	--Events:Subscribe( "KeyUp", self, self.KeyUp )
	Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput ) -- disable player input
	--Events:Subscribe( "PostTick", self, self.Tick )

	Network:Subscribe("ShowClientSpawnScreen", self, self.ShowSpawnScreen)  
end

function CClientSpawnScreen:DictatorPress() -- sent to CGame
	Network:Send("SetPlayerInTeam", { "dictator", LocalPlayer:GetId() })
	self:SetActive(false)
end

function CClientSpawnScreen:SecretPolicePress() -- sent to CGame
	Network:Send("SetPlayerInTeam", { "secret police", LocalPlayer:GetId() })
	self:SetActive(false)
end

function CClientSpawnScreen:MilitaryPress() -- sent to CGame
	Network:Send("SetPlayerInTeam", { "military", LocalPlayer:GetId() })
	self:SetActive(false)
end

function CClientSpawnScreen:RevolutionaryPress() -- sent to CGame
	Network:Send("SetPlayerInTeam", { "revolutionary", LocalPlayer:GetId() })
	self:SetActive(false)
end

function CClientSpawnScreen:ShowSpawnScreen()
	self.active = true
	self.window:SetVisible(true)
	Mouse:SetVisible(true)
end

function CClientSpawnScreen:GetActive()
	return self.active
end

function CClientSpawnScreen:SetActive( state )
	self.active = state
	self.window:SetVisible( self.active )
	Mouse:SetVisible( self.active )
end

function CClientSpawnScreen:KeyUp( args )
	if args.key == VirtualKey.F5 then
		self:SetActive( not self:GetActive() )
	end
end

function CClientSpawnScreen:LocalPlayerInput( args )
	if self:GetActive() and Game:GetState() == GUIState.Game then
		return false
	end
end

--[[function CClientSpawnScreen:Tick()
	if not self.playerJoined then
		self:SetActive(true)
		self.playerJoined = true
	end
end]]--

spawnScreen = CClientSpawnScreen()