local LunaUF = LunaUF
-- local Threat = CreateFrame("Frame")
local Threat = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0")
local L = LunaUF.L
LunaUF:RegisterModule(Threat, "threat", L["Threat"])

local has_superwow = SetAutoloot and true or false

local target_list = {}

Threat.threatApi = 'TWTv4=';
Threat.UDTS = 'TWT_UDTSv4';

Threat.prefix = 'TWT'
Threat.channel = ''
Threat.threats = {}

Threat.playerNamesToNotify = {}
Threat.tankNotify = false

-- taken from pepo's adaptation for bigwigs

function Threat:OnEnable()
	-- turtle-wow check
	if string.find(GetBuildInfo(),"^1.17.") then
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
	end
end

function Threat:OnDisable()
	-- Threat:StopListening()
end

function Threat:PLAYER_ENTERING_WORLD()
	if UnitAffectingCombat("player") then
		self:StartListening()
	end
end

function Threat:PLAYER_REGEN_DISABLED()
	self:StartListening()
end

function Threat:PLAYER_REGEN_ENABLED()
	self:StopListening()
end

function Threat:PLAYER_TARGET_CHANGED()
	if UnitExists("target") and not UnitIsPlayer("target") then
		self:wipe(self.threats)
	end
end

function Threat:IsListening()
	return self:IsEventRegistered("CHAT_MSG_ADDON")
end

function Threat:StartListening()
	if not self:IsListening() then
		self:Debug("threat listener started")
		self:RegisterEvent("CHAT_MSG_ADDON", "Event")
	end
end

function Threat:StopListening()
	if self:IsListening() then
		self:Debug("threat listener stopped")
		self:UnregisterEvent("CHAT_MSG_ADDON")
		self:wipe(self.threats)
	end
end

function Threat:EnableEventsForTank()
	if self.tankNotify == false then
		self:Debug('Enabling events for tank')
		self.tankNotify = true
	end
end

function Threat:DisableEventsForTank()
	if self.tankNotify == true then
		self:Debug('Disabling events for tank')
		self.tankNotify = false
	end
end

function Threat:EnableEventsForPlayerName(playerName)
	if not self.playerNamesToNotify[playerName] then
		self:Debug('Enabling events for {' .. playerName .. '}')
		self.playerNamesToNotify[playerName] = true
	end
end

function Threat:DisableEventsForPlayerName(playerName)
	if self.playerNamesToNotify[playerName] then
		self:Debug('Disabling events for {' .. playerName .. '}')
		self.playerNamesToNotify[playerName] = nil
	end
end

function Threat:DisablePlayerEvents()
	self:Debug('Disabling all player events')
	self.playerNamesToNotify = {}
end

function Threat:Debug(msg)
	if lf_debug then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
end

function Threat:Event()
	-- print("even")
	if string.find(arg2, self.threatApi, 1, true) then
		local threatData = arg2
		return self:handleThreatPacket(threatData)
	end
end

function Threat:wipe(src)
	-- notes: table.insert, table.remove will have undefined behavior
	-- when used on tables emptied this way because Lua removes nil
	-- entries from tables after an indeterminate time.
	-- Instead of table.insert(t,v) use t[table.getn(t)+1]=v as table.getn collapses nil entries.
	-- There are no issues with hash tables, t[k]=v where k is not a number behaves as expected.
	local mt = getmetatable(src) or {}
	if mt.__mode == nil or mt.__mode ~= "kv" then
		mt.__mode = "kv"
		src = setmetatable(src, mt)
	end
	for k in pairs(src) do
		src[k] = nil
	end
	return src
end

function Threat:handleThreatPacket(packet)
	local playersString = string.sub(packet, string.find(packet, self.threatApi) + string.len(self.threatApi), string.len(packet))

	self.threats = self:wipe(self.threats)
	self.tankName = ''

	local players = self:explode(playersString, ';')
	for _, tData in players do
		local msgEx = self:explode(tData, ':')
		if msgEx[1] and msgEx[2] and msgEx[3] and msgEx[4] and msgEx[5] then
			local player = msgEx[1]
			local tank = msgEx[2] == '1'
			local threat = tonumber(msgEx[3])
			local perc = tonumber(msgEx[4])
			local melee = msgEx[5] == '1'

			self.threats[player] = {
				threat = threat,
				tank = tank,
				perc = perc,
				melee = melee,
			}
			self:Debug('Player: {' .. player .. '} Threat: ' .. threat .. ' Perc: ' .. perc .. ' Tank: ' .. tostring(tank) .. ' Melee: ' .. tostring(melee))

			-- if tank then
			-- 	self.tankName = player
			-- 	if self.tankNotify == true then
			-- 		self:Debug('Notifying for tank {' .. player .. '}')
			-- 		-- self:TriggerEvent("BigWigs_ThreatUpdate", player, threat, perc, tank, melee)
			-- 	end
			-- end

			-- if self.playerNamesToNotify[player] then
			-- 	self:Debug('Notifying for {' .. player .. '}')
			-- 	-- self:TriggerEvent("BigWigs_ThreatUpdate", player, threat, perc, tank, melee)
			-- end
		end
	end
end

-- returns {
-- threat = threatValue,
-- tank = boolean,
-- perc = threatPercentage,
-- melee = boolean
function Threat:GetPlayerInfo(playerName)
	if not self.threats[playerName] then
		return {
			threat = false,
			tank = false,
			perc = false,
			melee = false,
		}
	end
	return self.threats[playerName]
end

function Threat:GetThreat(unit,perc)
	-- non interesting target
	if UnitClassification('target') ~= 'worldboss' and UnitClassification('target') ~= 'elite' then
		return false
	end
	-- no raid or party
	if GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then
			return false
	end
	-- not in combat
	if not UnitAffectingCombat('target') then
			return false
	end

	if self.threats[UnitName(unit)] then
		return perc and self.threats[UnitName(unit)].perc or self.threats[UnitName(unit)].threat
	end
	return 0 -- meets criteria but no value yet
end

function Threat:explode(str, delimiter)
	local result = {}
	local from = 1
	local delim_from, delim_to = string.find(str, delimiter, from, 1, true)
	while delim_from do
		table.insert(result, string.sub(str, from, delim_from - 1))
		from = delim_to + 1
		delim_from, delim_to = string.find(str, delimiter, from, true)
	end
	table.insert(result, string.sub(str, from))
	return result
end
