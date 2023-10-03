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
	["AhnQiraj"] = {x = 977.56, y = 651.707},
	["AhnQiraj2f"] = {x = 2777.544, y = 1851.696},
	["AhnQirajEntrance"] = {x = 4139.02, y = 2946.05},
	["AlahThalas"] = {x = 1010.946, y = 677.151},
	["Alterac"] = {x = 2800.0003, y = 1866.6667},
	["AlteracValley"] = {x = 4237.5, y = 2825},
	["AlteracValleyClassic"] = {x = 4237.5, y = 2825},
	["AmaniAlor"] = {x = 1515, y = 997},
	["Arathi"] = {x = 3600.0004, y = 2399.9997},
	["ArathiBasin"] = {x = 1756.2497, y = 1170.833},
	["Ashenvale"] = {x = 5766.667, y = 3843.7504},
	["Aszhara"] = {x = 5070.833, y = 3381.25},
	["Azeroth"] = {x = 35199.9, y = 23466.6},
	["AzsharaCrater"] = {x = 4236, y = 695},
	["Badlands"] = {x = 2487.5, y = 1658.334},
	["Barrens"] = {x = 10133.334, y = 6756.25},
	["BlackFathomDeeps"] = {x = 1221.87, y = 806.42},
	["BlackrockDepths"] = {x = 1407.061, y = 938.0403},
	["BlackrockDepths2f"] = {x = 1507.061, y = 1004.7072},
	["BlackMorass"] = {x = 1271.991, y = 845.475},
	["BlackMorass2f"] = {x = 1085.859, y = 726.609},
	["BlackrockMountain"] = {x = 711.56, y = 468.68},
	["BlackrockSpire"] = {x = 886.839, y = 591.226},
	["BlackrockSpire2f"] = {x = 886.839, y = 591.226},
	["BlackrockSpire3f"] = {x = 886.839, y = 591.226},
	["BlackrockSpire4f"] = {x = 886.839, y = 591.226},
	["BlackrockSpire5f"] = {x = 886.839, y = 591.226},
	["BlackrockSpire6f"] = {x = 886.839, y = 591.226},
	["BlackrockSpire7f"] = {x = 886.839, y = 591.226},
	["BlackwingLair"] = {x = 499.428, y = 332.95},
	["BlackwingLair2f"] = {x = 649.427, y = 432.95},
	["BlackwingLair3f"] = {x = 649.427, y = 432.95},
	["BlackwingLair4f"] = {x = 649.427, y = 432.95},
	["BlastedLands"] = {x = 3350, y = 2233.33},
	["BurningSteppes"] = {x = 2929.1663, y = 1952.083},
	["CavernsOfTime"] = {x = 1348.242, y = 888.086},
	["Collin"] = {x = 37651.46, y = 25100.97},
	["CrescentGrove"] = {x = 2643.215, y = 1751.157},
	["Darkshore"] = {x = 6550, y = 4366.666},
	["Darnassis"] = {x = 1058.333, y = 705.733},
	["DeadminesEntrance"] = {x = 449.89, y = 299.92},
	["DeadwindPass"] = {x = 2499.9997, y = 1666.664},
	["DeeprunTram"] = {x = 312, y = 208},
	["DeeprunTram2f"] = {x = 309, y = 208},
	["Desolace"] = {x = 4495.833, y = 2997.9163},
	["DireMaul"] = {x = 1275, y = 850},
	["DireMaul2f"] = {x = 525, y = 350},
	["DireMaul3f"] = {x = 487.5, y = 325},
	["DireMaul4f"] = {x = 750, y = 500},
	["DireMaul5f"] = {x = 800.0008, y = 533.334},
	["DireMaul6f"] = {x = 975, y = 650},
	["DunMorogh"] = {x = 4925, y = 3283.334},
	["Durotar"] = {x = 5287.5, y = 3525},
	["Duskwood"] = {x = 2700.0003, y = 1800.004},
	["Dustwallow"] = {x = 5250.0001, y = 3500},
	["EasternPlaguelands"] = {x = 3870.833, y = 2581.25},
	["Elwynn"] = {x = 3470.834, y = 2314.587},
	["EmeraldSanctum"] = {x = 1273.101, y = 853.722},
	["EversongWoods"] = {x = 4925, y = 3283.337},
	["Felwood"] = {x = 5750, y = 3833.333},
	["Feralas"] = {x = 6950, y = 4633.333},
	["Ghostlands"] = {x = 3300, y = 2199.999},
	["Gillijim"] = {x = 2464.944, y = 1927.38},
	["Gilneas"] = {x = 3667.638, y = 2442.057},
	["GilneasCity"] = {x = 1250.19, y = 837.443},
	["Gnomeregan"] = {x = 769.668, y = 513.112},
	["Gnomeregan2f"] = {x = 769.668, y = 513.112},
	["Gnomeregan3f"] = {x = 869.668, y = 579.778},
	["Gnomeregan4f"] = {x = 869.6697, y = 579.78},
	["GnomereganEntrance"] = {x = 571.19, y = 379.14},
	["HateforgeQuarry"] = {x = 752.119, y = 510.335},
	["Hilsbrad"] = {x = 3200, y = 2133.333},
	["Hinterlands"] = {x = 3850, y = 2566.667},
	["Hyjal"] = {x = 3206.631, y = 2141.755},
	["Icepoint"] = {x = 1596.938, y = 1062.97},
	["Ironforge"] = {x = 790.6246, y = 527.605},
	["Kalimdor"] = {x = 36799.81, y = 24533.2},
	["Karazhan"] = {x = 598.041, y = 399.32},
	["KarazhanCrypt"] = {x = 546.75, y = 391.97},
	["Lapidis"] = {x = 2165.066, y = 2042.87},
	["LochModan"] = {x = 2758.333, y = 1839.583},
	["Maraudon"] = {x = 2112.09, y = 1410.89},
	["MaraudonEntrance"] = {x = 824, y = 550},
	["MoltenCore"] = {x = 1264.8, y = 843.199},
	["Moomoo"] = {x = 1007.68, y = 671.79},
	["Moonglade"] = {x = 2308.333, y = 1539.583},
	["Mulgore"] = {x = 5137.5, y = 3425.0003},
	["Naxxramas"] = {x = 1991.69, y = 1318.416},
	["Naxxramas2f"] = {x = 652.1, y = 439.67},
	["Ogrimmar"] = {x = 1402.605, y = 935.416},
	["OnyxiasLair"] = {x = 483.118, y = 322.0788},
	["Ragefire"] = {x = 738.864, y = 492.5762},
	["RazorfenDowns"] = {x = 709.049, y = 472.7},
	["RazorfenKraul"] = {x = 736.45, y = 490.96},
	["Redridge"] = {x = 2170.834, y = 1447.92},
	["RuinsofAhnQiraj"] = {x = 2512.5004, y = 1675},
	["ScarletEnclave"] = {x = 3172, y = 2115},
	["ScarletMonastery"] = {x = 619.984, y = 413.322},
	["ScarletMonastery2f"] = {x = 320.191, y = 213.4605},
	["ScarletMonastery3f"] = {x = 612.6966, y = 408.46},
	["ScarletMonastery4f"] = {x = 703.3, y = 468.8663},
	["ScarletMonasteryEntrance"] = {x = 203.66, y = 135.04},
	["Scholomance"] = {x = 320.0489, y = 213.365},
	["Scholomance2f"] = {x = 440.049, y = 293.3664},
	["Scholomance3f"] = {x = 410.078, y = 273.3858},
	["Scholomance4f"] = {x = 531.042, y = 354.0282},
	["SearingGorge"] = {x = 2231.2503, y = 1487.5},
	["ShadowfangKeep"] = {x = 352.43, y = 234.9534},
	["ShadowfangKeep2f"] = {x = 212.426, y = 141.618},
	["ShadowfangKeep3f"] = {x = 152.43, y = 101.61993},
	["ShadowfangKeep4f"] = {x = 152.43, y = 101.6247},
	["ShadowfangKeep5f"] = {x = 152.43, y = 101.6247},
	["ShadowfangKeep6f"] = {x = 198.43, y = 132.28661},
	["ShadowfangKeep7f"] = {x = 272.43, y = 181.61993},
	["Silithus"] = {x = 3483.334, y = 2322.916},
	["SilvermoonCity"] = {x = 1211.458, y = 806.772},
	["Silverpine"] = {x = 4200, y = 2800},
	["StonetalonMountains"] = {x = 4883.333, y = 3256.2503},
	["Stormwind"] = {x = 1737.50033, y = 1158.333},
	["StormwindVault"] = {x = 354.497, y = 234.738},
	["Stranglethorn"] = {x = 6381.25, y = 4254.17},
	["Stratholme"] = {x = 1185.344, y = 789.855},
	["Sunnyglade"] = {x = 988.626, y = 1393.165},
	["SwampOfSorrows"] = {x = 2293.75, y = 1529.167},
	["Tanaris"] = {x = 6900, y = 4600},
	["TelAbim"] = {x = 3154, y = 2174},
	["Teldrassil"] = {x = 5091.666, y = 3393.75},
	["TheDeadmines"] = {x = 656.59, y = 434.97},
	["TheStockade"] = {x = 378.153, y = 252.1025},
	["TheTempleOfAtalHakkar"] = {x = 695.029, y = 463.353},
	["TheTempleOfAtalHakkar2f"] = {x = 248.17677, y = 166.0355},
	["TheTempleOfAtalHakkar3f"] = {x = 556.1692, y = 370.388},
	["ThousandNeedles"] = {x = 4399.9997, y = 2933.333},
	["ThunderBluff"] = {x = 1043.7499, y = 695.8331},
	["Tirisfal"] = {x = 4518.75, y = 3012.5001},
	["Uldaman"] = {x = 893.668, y = 595.779},
	["UldamanEntrance"] = {x = 563.31, y = 376.1},
	["Undercity"] = {x = 959.375, y = 640.104},
	["UngoroCrater"] = {x = 3700.0003, y = 2466.666},
	["WailingCaverns"] = {x = 936.475, y = 624.316},
	["WailingCavernsEntrance"] = {x = 572.777, y = 381.849},
	["WarsongGulch"] = {x = 1145.8337, y = 764.5831},
	["WesternPlaguelands"] = {x = 4299.9997, y = 2866.667},
	["Westfall"] = {x = 3500.0003, y = 2333.33},
	["Wetlands"] = {x = 4135.4167, y = 2756.25},
	["Winterspring"] = {x = 7100.0003, y = 4733.333},
	["WinterVeilVale"] = {x = 1432, y = 977},
	["ZulFarrak"] = {x = 1383.3333, y = 922.916},
	["ZulGurub"] = {x = 2120.833, y = 1414.58}
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
	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" or not event then
		SetMapToCurrentZone()
		MapFileName, _, _ = GetMapInfo()
	elseif LunaUF.db.profile.RangeCLparsing and events[event] then
		ParseCombatMessage(events[event], arg1)
	end
end

OnEvent()
ZoneWatch:SetScript("OnEvent", OnEvent)
ZoneWatch:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ZoneWatch:RegisterEvent("PLAYER_ENTERING_WORLD")
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
		elseif MapFileName and MapSizes[MapFileName] and not WorldMapFrame:IsVisible() then
			local px, py, ux, uy, distance
			SetMapToCurrentZone()
			px, py = GetPlayerMapPosition("player")
			ux, uy = GetPlayerMapPosition(UnitID)
			if px ~= 0 and ux ~= 0 then
				distance = sqrt(((px - ux)*MapSizes[MapFileName].x)^2 + ((py - uy)*MapSizes[MapFileName].y)^2)*(40/42.9)
			end
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
