class 'CClientDialog'

function CClientDialog:__init()
	self.active = false
	
	self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.5, 0.45 ) )
	self.window:SetPositionRel( Vector2( 0.5, 0.5 ) - self.window:GetSizeRel() / 2 )
	self.window:SetTitle( "Spawn" )
	self.window:SetVisible( self.active )
	
	self.button = Button.Create(self.window)
	self.button:SetPositionRel(Vector2(0, 0.80))
    self.button:SetSizeRel(Vector2( 1, 0.10 ))
	self.button:SetText("OK")
	self.button:Subscribe("Press", self, self.Press)
	
	self.label = Label.Create(self.window)
	self.label:SetWrap(true)
	self.label:SetPositionRel(Vector2(0, 0))
	self.label:SetSizeRel(Vector2(1, 1))
	--Events:Subscribe( "KeyUp", self, self.KeyUp )

	Network:Subscribe("ShowDialog", self, self.ShowSpawnScreen)  
end

function CClientDialog:Press() -- sent to CGame
	self.active = false
	self.window:SetVisible(false)
	Mouse:SetVisible( self.active )
end

--[[function CClientDialog:KeyUp( args )
	if args.key == VirtualKey.F5 then
		self:SetActive( not self:GetActive() )
	end
end]]--

function CClientDialog:GetActive()
	return self.active
end

function CClientDialog:SetActive( state )
	self.active = state
	self.window:SetVisible( self.active )
	Mouse:SetVisible( self.active )
end

function CClientDialog:ShowSpawnScreen(args)
	self.active = true
	self.window:SetVisible(true)
	self.window:SetTitle(args.title)
	self.label:SetText(args.content)
	Mouse:SetVisible( self.active )
end

cClientDialog = CClientDialog()