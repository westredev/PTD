class 'CDatabase'

function CDatabase:__init()
    SQL:Execute("CREATE TABLE IF NOT EXISTS player (steamid VARCHAR UNIQUE)")
end

function CDatabase:GetPlayerData(player)
	local query = SQL:Query("SELECT * FROM player WHERE steamid = (?)")
    query:Bind(1, player:GetSteamId().id)
    local result = query:Execute()

	if #result > 0 then
		return true
	else
		local transaction = SQL:Transaction()
		
		local cmd = SQL:Command("INSERT OR REPLACE INTO player (steamid) VALUES (?)")
		cmd:Bind(1, player:GetSteamId().id)
		cmd:Execute()
		
		transaction:Commit()
		return false
	end
		
    --[[if #result > 0 then
        player:SetMoney( tonumber(result[1].money) )
    end]]--
end

sql = CDatabase()