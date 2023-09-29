local Range = {}
AceLibrary("AceHook-2.1"):embed(Range)
AceLibrary("AceEvent-2.0"):embed(Range)
local L = LunaUF.L
local BS = LunaUF.BS
local ScanTip = LunaUF.ScanTip
local rosterLib = AceLibrary("RosterLib-2.0")
LunaUF:RegisterModule(Range, "range", L["Range"])
local MapFileName
local roster = {}
local ZoneWatch = CreateFrame("Frame")
local _, playerClass = UnitClass("player")

-- Big thx to Renew & Astrolabe
local MapSizes = {
	["Alterac"] = {x = 2800.0003, y = 1866.6667},
	["AlteracValley"] = {x = 4237.5, y = 2825},
	["Arathi"] = {x = 3600.0004, y = 2399.9997},
	["ArathiBasin"] = {x = 1756.2497, y = 1170.833},
	["Ashenvale"] = {x = 5766.667, y = 3843.7504},
	["Aszhara"] = {x = 5070.833, y = 3381.25},
	["Azeroth"] = {x = 35199.9, y = 23466.6},
	["Badlands"] = {x = 2487.5, y = 1658.334},
	["Barrens"] = {x = 10133.334, y = 6756.25},
	["BlastedLands"] = {x = 3350, y = 2233.33},
	["BurningSteppes"] = {x = 2929.1663, y = 1952.083},
	["Darkshore"] = {x = 6550, y = 4366.666},
	["Darnassis"] = {x = 1058.333, y = 705.733},
	["DeadwindPass"] = {x = 2499.9997, y = 1666.664},
	["Desolace"] = {x = 4495.833, y = 2997.9163},
	["DunMorogh"] = {x = 4925, y = 3283.334},
	["Durotar"] = {x = 5287.5, y = 3525},
	["Duskwood"] = {x = 2700.0003, y = 1800.004},
	["Dustwallow"] = {x = 5250.0001, y = 3500},
	["EasternPlaguelands"] = {x = 3870.833, y = 2581.25},
	["Elwynn"] = {x = 3470.834, y = 2314.587},
	["Felwood"] = {x = 5750, y = 3833.333},
	["Feralas"] = {x = 6950, y = 4633.333},
	["Hilsbrad"] = {x = 3200, y = 2133.333},
	["Hinterlands"] = {x = 3850, y = 2566.667},
	["Ironforge"] = {x = 790.6246, y = 527.605},
	["Kalimdor"] = {x = 36799.81, y = 24533.2},
	["LochModan"] = {x = 2758.333, y = 1839.583},
	["Moonglade"] = {x = 2308.333, y = 1539.583},
	["Mulgore"] = {x = 5137.5, y = 3425.0003},
	["Ogrimmar"] = {x = 1402.605, y = 935.416},
	["Redridge"] = {x = 2170.834, y = 1447.92},
	["SearingGorge"] = {x = 2231.2503, y = 1487.5},
	["Silithus"] = {x = 3483.334, y = 2322.916},
	["Silverpine"] = {x = 4200, y = 2800},
	["StonetalonMountains"] = {x = 4883.333, y = 3256.2503},
	["Stormwind"] = {x = 1344.27037, y = 896.354},
	["Stranglethorn"] = {x = 6381.25, y = 4254.17},
	["SwampOfSorrows"] = {x = 2293.75, y = 1529.167},
	["Tanaris"] = {x = 6900, y = 4600},
	["Teldrassil"] = {x = 5091.666, y = 3393.75},
	["ThousandNeedles"] = {x = 4399.9997, y = 2933.333},
	["ThunderBluff"] = {x = 1043.7499, y = 695.8331},
	["Tirisfal"] = {x = 4518.75, y = 3012.5001},
	["Undercity"] = {x = 959.375, y = 640.104},
	["UngoroCrater"] = {x = 3700.0003, y = 2466.666},
	["WarsongGulch"] = {x = 1145.8337, y = 764.5831},
	["WesternPlaguelands"] = {x = 4299.9997, y = 2866.667},
	["Westfall"] = {x = 3500.0003, y = 2333.33},
	["Wetlands"] = {x = 4135.4167, y = 2756.25},
	["Winterspring"] = {x = 7100.0003, y = 4733.333}
}

local HealSpells = {
    ["DRUID"] = {
		[string.lower(BS["Healing Touch"])] = true,
		[string.lower(BS["Regrowth"])] = true,
		[string.lower(BS["Rejuvenation"])] = true,
	},
    ["PALADIN"] = {
		[string.lower(BS["Flash of Light"])] = true,
		[string.lower(BS["Holy Light"])] = true,
	},
    ["PRIEST"] = {
		[string.lower(BS["Flash Heal"])] = true,
		[string.lower(BS["Lesser Heal"])] = true,
		[string.lower(BS["Heal"])] = true,
		[string.lower(BS["Greater Heal"])] = true,
		[string.lower(BS["Renew"])] = true,
	},
    ["SHAMAN"] = {
		[string.lower(BS["Chain Heal"])] = true,
		[string.lower(BS["Lesser Healing Wave"])] = true,
		[string.lower(BS["Healing Wave"])] = true,
	},
}

-- This table needs to be localized, of course
local events

if ( GetLocale() == "koKR" ) then
	events = {
		CHAT_MSG_COMBAT_PARTY_HITS = "(.+)|1이;가; .-|1을;를; 공격하여 %d+의 [^%s]+ 입혔습니다",
		CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS = "(.+)|1이;가; .-|1을;를; 공격하여 %d+의 [^%s]+ 입혔습니다",
		CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS = ".-의 공격을 받아 %d+의 [^%s]+ 입었습니다",
		CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS = ".+|1이;가; ([^%s]+)|1을;를; 공격하여 %d+의 [^%s]+ 입혔습니다",
		CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS = ".+|1이;가; ([^%s]+)|1을;를; 공격하여 %d+의 [^%s]+ 입혔습니다",

		CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE = {".-|1이;가; .+|1으로;로; 당신에게 %d+의 .- 입혔습니다", ".-|1이;가; .-|1으로;로; 공격했지만 저항했습니다"},
		CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE = {".-|1이;가; .+|1으로;로; (.-)에게 %d+의 .- 입혔습니다", ".-|1이;가; .-|1으로;로; (.-)|1을;를; 공격했지만 저항했습니다"},
		CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE = {".-|1이;가; .+|1으로;로; (.-)에게 %d+의 .- 입혔습니다", ".-|1이;가; .-|1으로;로; (.-)|1을;를; 공격했지만 저항했습니다"},

		CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF = "([^%s]+)의 .+%.",
		CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE = "(.-)|1이;가; .+|1으로;로; .-에게 %d+의 .- 입혔습니다",
		CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE = ".-|1이;가; .+|1으로;로; (.-)에게 %d+의 .- 입혔습니다",
		CHAT_MSG_SPELL_PARTY_BUFF = "([^%s]+)의 .+%.",
		CHAT_MSG_SPELL_PARTY_DAMAGE = "(.-)|1이;가; .+|1으로;로; .-에게 %d+의 .- 입혔습니다",
		--CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE = ".-|1이;가; ([^%s]+)의 .-에 의해 %d+의 .+",
		CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS = "([^%s]+)|1이;가; .+%.",
		CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE = "([^%s]+)|1이;가; .-에 의해 %d+의 .+",
		CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = "([^%s]+)|1이;가; .-에 의해 %d+의 .+",
		CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE = "([^%s]+)|1이;가; .-에 의해 %d+의 .+",
		CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS = "([^%s]+)|1이;가; .+%.",
	}
else
	events = {
		CHAT_MSG_COMBAT_PARTY_HITS = {L["CHAT_MSG_COMBAT_HITS"],L["CHAT_MSG_COMBAT_CRITS"]},
		CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS = {L["CHAT_MSG_COMBAT_HITS"],L["CHAT_MSG_COMBAT_CRITS"]},
		CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS = {L["CHAT_MSG_COMBAT_CREATURE_VS_HITS"],L["CHAT_MSG_COMBAT_CREATURE_VS_CRITS"]},
		CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS = {L["CHAT_MSG_COMBAT_CREATURE_VS_HITS"],L["CHAT_MSG_COMBAT_CREATURE_VS_CRITS"]},
		CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS = {L["CHAT_MSG_COMBAT_CREATURE_VS_HITS"],L["CHAT_MSG_COMBAT_CREATURE_VS_CRITS"],L["CHAT_MSG_COMBAT_CREATURE_VS_CRITS2"]},

		CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE = {L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE1"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE2"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE3"]},
		CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE = {L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE1"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE2"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE3"]},
		CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE = {L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE1"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE2"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE3"]},

		CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF = L["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"],
		CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE = {L["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE"],L["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE2"]},
		CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE = L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE1"],
		CHAT_MSG_SPELL_PARTY_BUFF = L["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"],
		CHAT_MSG_SPELL_PARTY_DAMAGE = {L["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE"],L["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE2"]},
		CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS = L["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS"],
		CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE = {L["CHAT_MSG_SPELL_PERIODIC_DAMAGE"], L["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"]},
		CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = {L["CHAT_MSG_SPELL_PERIODIC_DAMAGE"], L["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"]},
		CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE = L["CHAT_MSG_SPELL_PERIODIC_DAMAGE"],
		CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS = {L["CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS1"], L["CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS2"]},

		CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES = {L["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES1"], L["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES2"], L["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES3"], L["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES4"]},
		CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF = {L["CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF1"], L["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"]},
	}
end

local function ParseCombatMessage(eventstr, clString)
	local unit
	if type(eventstr) == "string" then
		local _, _, unitname = string.find(clString, eventstr)
		if unitname and (unitname ~= L["you"] and unitname ~= L["You"]) then
			unit = rosterLib:GetUnitIDFromName(unitname)
			if unit then
				roster[unit] = GetTime()
			end
		end
	elseif type(eventstr) == "table" then
		for _,val in pairs(eventstr) do
			local _, _, unitname = string.find(clString, val)
			if unitname and (unitname ~= L["you"] and unitname ~= L["You"]) then
				unit = rosterLib:GetUnitIDFromName(unitname)
				if unit then
					roster[unit] = GetTime()
					return
				end
			end
		end
	end
end

local function OnUpdate()
	Range:FullUpdate(this:GetParent())
end

local function OnEvent()
	if event == "ZONE_CHANGED_NEW_AREA" or not event then
		SetMapToCurrentZone()
		MapFileName, _, _ = GetMapInfo()
	elseif LunaUF.db.profile.RangeCLparsing and events[event] then
		ParseCombatMessage(events[event], arg1)
	end
end

OnEvent()
ZoneWatch:SetScript("OnEvent", OnEvent)
ZoneWatch:RegisterEvent("ZONE_CHANGED_NEW_AREA")
for i in pairs(events) do ZoneWatch:RegisterEvent(i) end

function Range:GetRange(UnitID)
    if UnitExists(UnitID) and UnitIsVisible(UnitID) then
		local _,instance = IsInInstance()

		if CheckInteractDistance(UnitID, 1) then
			return 10
		elseif CheckInteractDistance(UnitID, 3) then
			return 10
		elseif CheckInteractDistance(UnitID, 4) then
			return 30
		elseif (instance == "none" or instance == "pvp") and MapFileName and MapSizes[MapFileName] and not WorldMapFrame:IsVisible() then
			local px, py, ux, uy, distance
			SetMapToCurrentZone()
			px, py = GetPlayerMapPosition("player")
			ux, uy = GetPlayerMapPosition(UnitID)
			distance = sqrt(((px - ux)*MapSizes[MapFileName].x)^2 + ((py - uy)*MapSizes[MapFileName].y)^2)*(40/42.9)
			return distance
		elseif (GetTime() - (roster[UnitID] or 0)) < 4 then
			return 40
		else
			return 45
		end
    end
	return 100
end

function Range:ScanRoster()
	if not SpellIsTargeting() then return end
	-- We have a valid 40y spell on the cursor so we can now easily check the range.
	for i=1,40 do
		local unit = "raid"..i
		if not UnitExists(unit) then
			break
		end
		if SpellCanTargetUnit(unit) then
			roster[unit] = GetTime()
		end
		unit = "raidpet"..i
		if UnitExists(unit) and SpellCanTargetUnit(unit) then
			roster[unit] = GetTime()
		end
	end
	for i=1,4 do
		local unit = "party"..i
		if not UnitExists(unit) then
			break
		end
		if SpellCanTargetUnit(unit) then
			roster[unit] = GetTime()
		end
		unit = "partypet"..i
		if UnitExists(unit) and SpellCanTargetUnit(unit) then
			roster[unit] = GetTime()
		end
	end
end

function Range:CastSpell(spellId, spellbookTabNum)
	self.hooks.CastSpell(spellId, spellbookTabNum)
	if SpellIsTargeting() then
		local spell = GetSpellName(spellId, spellbookTabNum)
		spell = string.lower(spell)
		if HealSpells[playerClass] and HealSpells[playerClass][spell] then
			if not self:IsEventScheduled("ScanRoster") then
				self:ScheduleRepeatingEvent("ScanRoster", self.ScanRoster, 2)
			end
			self:ScanRoster()
		end
	end
end

function Range:CastSpellByName(spellName, onSelf)
	self.hooks.CastSpellByName(spellName, onSelf)
	if SpellIsTargeting() then
		local _,_,spell = string.find(spellName, "^([^%(]+)")
		spell = string.lower(spell)
		if HealSpells[playerClass] and HealSpells[playerClass][spell] then
			if not self:IsEventScheduled("ScanRoster") then
				self:ScheduleRepeatingEvent("ScanRoster", self.ScanRoster, 2)
			end
			self:ScanRoster()
		end
	end
end

function Range:UseAction(slot, checkCursor, onSelf)
	self.hooks.UseAction(slot, checkCursor, onSelf)
	if not GetActionText(slot) and SpellIsTargeting() then
		ScanTip:ClearLines()
		ScanTip:SetAction(slot)
		local spell = LunaScanTipTextLeft1:GetText()
		spell = string.lower(spell)
		if HealSpells[playerClass] and HealSpells[playerClass][spell] then
			if not self:IsEventScheduled("ScanRoster") then
				self:ScheduleRepeatingEvent("ScanRoster", self.ScanRoster, 2)
			end
			self:ScanRoster()
		end
	end
end

function Range:SpellStopTargeting()
	self.hooks.SpellStopTargeting()
	if self:IsEventScheduled("ScanRoster") then
		self:CancelScheduledEvent("ScanRoster")
	end
end

function Range:OnEnable(frame)
	if not frame.range then
		frame.range = CreateFrame("Frame", nil, frame)
	end
	frame.range.lastUpdate = GetTime() - 5
	frame.range:SetScript("OnUpdate", OnUpdate)
end

function Range:OnDisable(frame)
	if frame.range then
		frame.range:SetScript("OnUpdate", nil)
	end
end

function Range:FullUpdate(frame)
	if frame.DisableRangeAlpha or (GetTime() - frame.range.lastUpdate) < (LunaUF.db.profile.RangePolRate or 1.5) then return end
	frame.range.lastUpdate = GetTime()
	local range = self:GetRange(frame.unit)

	local healththreshold = LunaUF.db.profile.units.raid.healththreshold
	if (not healththreshold.enabled) then
		if range and range <= 40 then
			frame:SetAlpha(LunaUF.db.profile.units[frame.unitGroup].fader.enabled and LunaUF.db.profile.units[frame.unitGroup].fader.combatAlpha or 1)
		else
			frame:SetAlpha(LunaUF.db.profile.units[frame.unitGroup].range.alpha)
		end
	else -- TODO Remove dependency on the Range module for healththreshold.
		local percent = UnitHealth(frame.unit) / UnitHealthMax(frame.unit)
		if (range and range <= 40) then
			if (percent <= healththreshold.threshold) then				
				frame:SetAlpha(healththreshold.inRangeBelowAlpha)
			else
				frame:SetAlpha(healththreshold.inRangeAboveAlpha)
			end
		else
			if (percent <= healththreshold.threshold) then
				frame:SetAlpha(healththreshold.outOfRangeBelowAlpha)
			else
				frame:SetAlpha(LunaUF.db.profile.units[frame.unitGroup].range.alpha)
			end
		end
	end


end

if HealSpells[playerClass] then -- only hook on healing classes
	Range:Hook("CastSpell")
	Range:Hook("CastSpellByName")
	Range:Hook("UseAction")
	Range:Hook("SpellStopTargeting")
end
