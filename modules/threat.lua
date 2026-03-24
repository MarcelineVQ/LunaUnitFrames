local LunaUF = LunaUF
-- local Threat = CreateFrame("Frame")
local Threat = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0")
local L = LunaUF.L
LunaUF:RegisterModule(Threat, "threat", L["Threat"])

local has_superwow = SetAutoloot and true or false

local __find = string.find
local __sub = string.sub
local __len = string.len
local __pairs = pairs
local __tonumber = tonumber
local __floor = math.floor

local target_list = {}
local scratch_players = {}
local scratch_msg = {}

Threat.threatApi = 'TWTv4=';
Threat.UDTS = 'TWT_UDTSv4';

Threat.prefix = 'TWT'
Threat.channel = ''
Threat.threats = {}

Threat.playerNamesToNotify = {}
Threat.tankNotify = false

-- taken from pepo's adaptation for bigwigs

local function isTurtleWoW()
	local _,_,ver = string.find(GetBuildInfo(),"^1%.(%d+)")
	return ver and tonumber(ver) > 16
end

local function hasThreatTags()
	for _, unitConfig in pairs(LunaUF.db.profile.units) do
		if unitConfig.tags and unitConfig.tags.bartags then
			for _, barConfig in pairs(unitConfig.tags.bartags) do
				for _, tagstr in pairs(barConfig) do
					if type(tagstr) == "string" and string.find(tagstr, "threat") then
						return true
					end
				end
			end
		end
	end
	return false
end

function Threat:CheckState()
	if not isTurtleWoW() then return end
	if hasThreatTags() then
		-- Piggyback on TWThreat if present — skip our own packet parsing
		if TWT and TWT.threats then
			self.threats = TWT.threats
			self.active = true
			return
		end
		if not self.active then
			self.active = true
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_ENTERING_WORLD")
			self:RegisterEvent("PLAYER_TARGET_CHANGED")
		end
	elseif self.active then
		self.active = false
		self.threats = {}
		self:UnregisterAllEvents()
		self:StopListening()
	end
end

function Threat:OnEnable()
	self:CheckState()
end

function Threat:OnDisable()
	-- per-frame call, ignore — use CheckState for global toggle
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
	self:PLAYER_TARGET_CHANGED()
end

function Threat:PLAYER_TARGET_CHANGED()
	if UnitExists("target") and self:IsInteresting() then
		-- self:wipe(self.threats)
		self:StartListening()
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
	if __find(arg2, self.threatApi, 1, true) then
		return self:handleThreatPacket(arg2)
	end
end

function Threat:wipe(src)
	for k in __pairs(src) do
		src[k] = nil
	end
	return src
end

function Threat:handleThreatPacket(packet)
	local apiPos = __find(packet, self.threatApi, 1, true)
	local playersString = __sub(packet, apiPos + __len(self.threatApi))

	self:wipe(self.threats)
	self.tankName = ''

	local players = self:explode(playersString, ';', scratch_players)
	for _, tData in players do
		local msgEx = self:explode(tData, ':', scratch_msg)
		if msgEx[1] and msgEx[2] and msgEx[3] and msgEx[4] and msgEx[5] then
			local player = msgEx[1]
			local tank = msgEx[2] == '1'
			local threat = __tonumber(msgEx[3])
			local perc = __tonumber(msgEx[4])
			local melee = msgEx[5] == '1'

			self.threats[player] = {
				threat = threat,
				tank = tank,
				perc = perc,
				melee = melee,
			}

			if tank then
				self.tankName = player
			end
		end
	end
end

-- returns {
-- threat = threatValue,
-- tank = boolean,
-- perc = threatPercentage,
-- melee = boolean
local emptyThreat = { threat = false, tank = false, perc = false, melee = false }

function Threat:GetPlayerInfo(playerName)
	return self.threats[playerName] or emptyThreat
end

function Threat:IsInteresting()
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
		return true
end

local function NextThreat(threats, threat)
	local nextLowest = nil
	for _, data in threats do
		if data.threat < threat then
			if not nextLowest or data.threat > nextLowest.threat then
				nextLowest = data
			end
		end
	end
	return nextLowest
end

function Threat:GetThreat(unit,perc,pull,neg)
	local name = UnitName(unit)
	if not self:IsInteresting() then return false end

	local data = self.threats[name]
	if data then
		if perc then
			if neg and data.perc >= 100 then
				local next_threater = NextThreat(self.threats, data.threat) or data
				return data.perc / next_threater.perc * 100
			end
			return data.perc
		end
		if pull then
			if data.tank and neg then
				local next_threater = NextThreat(self.threats, data.threat) or data
				return -(next_threater.threat * ((100 / next_threater.perc) - 1))
			else
				return data.threat * ((100 / data.perc) - 1)
			end
		end
		return data.threat
	elseif pull then -- not in the fight yet but want to see the data
		for n, data in self.threats do
			if data.tank then
				return data.threat
			end
		end
	end
	return 0 -- meets IsInteresting criteria but no value yet
end

function Threat:explode(str, delimiter, reuse)
	local result = reuse or {}
	local n = 0
	local from = 1
	local delim_from, delim_to = __find(str, delimiter, from, true)
	while delim_from do
		n = n + 1
		result[n] = __sub(str, from, delim_from - 1)
		from = delim_to + 1
		delim_from, delim_to = __find(str, delimiter, from, true)
	end
	n = n + 1
	result[n] = __sub(str, from)
	if reuse then
		local old = n + 1
		while result[old] do
			result[old] = nil
			old = old + 1
		end
	end
	return result
end
