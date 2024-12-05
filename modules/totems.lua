local Totems = {}
local L = LunaUF.L
local BS = LunaUF.BS
local _,playerclass = UnitClass("player")
local tooltip = LunaUF.ScanTip
local SpellCast = {}
local isCasting
LunaUF:RegisterModule(Totems, "totemBar", L["Totem Bar"], true)

local has_superwow = SetAutoloot and true or false

local player_guid = nil

local totemcolors = {
	{1,0,0},
	{0,0,1},
	{0.78,0.61,0.43},
	{0.41,0.80,0.94}
}

local TotemDB = {
	[BS["Searing Totem"]] = {
		["type"] = 1,
		["dur"] = {30,
		35,
		40,
		45,
		50,
		55}
	},
	[BS["Grace of Air Totem"]] = {
		["type"] = 4,
		["dur"] = {120,
		120,
		120}
	},
	[BS["Nature Resistance Totem"]] = {
		["type"] = 4,
		["dur"] = {120,
		120,
		120}
	};
	[BS["Healing Stream Totem"]] = {
		["type"] = 2,
		["dur"] = {60,
		60,
		60,
		60,
		60}
	},
	[BS["Strength of Earth Totem"]] = {
		["type"] = 3,
		["dur"] = {120,
		120,
		120,
		120,
		120}
	},
	[BS["Fire Resistance Totem"]] = {
		["type"] = 2,
		["dur"] = {120,
		120,
		120}
	},
	[BS["Flametongue Totem"]] = {
		["type"] = 1,
		["dur"] = {120,
		120,
		120,
		120}
	},
	[BS["Mana Tide Totem"]] = {
		["type"] = 2,
		["dur"] = {12,
		12,
		12}
	},
	[BS["Stoneclaw Totem"]] = {
		["type"] = 3,
		["dur"] = {15,
		15,
		15,
		15,
		15,
		15}
	},
	[BS["Magma Totem"]] = {
		["type"] = 1,
		["dur"] = {20,
		20,
		20,
		20}
	},
	[BS["Mana Spring Totem"]] = {
		["type"] = 2,
		["dur"] = {60,
		60,
		60,
		60}
	},
	[BS["Windwall Totem"]] = {
		["type"] = 4,
		["dur"] = {120,
		120,
		120}
	},
	[BS["Frost Resistance Totem"]] = {
		["type"] = 1,
		["dur"] = {120,
		120,
		120}
	},
	[BS["Stoneskin Totem"]] = {
		["type"] = 3,
		["dur"] = {120,
		120,
		120,
		120,
		120,
		120}
	},
	[BS["Fire Nova Totem"]] = {
		["type"] = 1,
		["dur"] = {4,
		4,
		4,
		4,
		4}
	},
	[BS["Windfury Totem"]] = {
		["type"] = 4,
		["dur"] = {120,
		120,
		120}
	},
	[BS["Disease Cleansing Totem"]] = {
		["type"] = 2,
		["dur"] = {120}
	},
	[BS["Sentry Totem"]] = {
		["type"] = 4,
		["dur"] = {300}
	},
	[BS["Grounding Totem"]] = {
		["type"] = 4,
		["dur"] = {45}
	},
	[BS["Poison Cleansing Totem"]] = {
		["type"] = 2,
		["dur"] = {120}
	},
	[BS["Earthbind Totem"]] = {
		["type"] = 3,
		["dur"] = {45}
	},
	[BS["Tremor Totem"]] = {
		["type"] = 3,
		["dur"] = {120}
	},
	[BS["Tranquil Air Totem"]] = {
		["type"] = 4,
		["dur"] = {120}
	}
}

local function OnEvent()
	if event == "PLAYER_ENTERING_WORLD" then
		_,player_guid = UnitExists("player")

		for k,totem in pairs(this.totems) do
			totem.active = nil
			totem.timer = 0
		end
		Totems:FullUpdate(this:GetParent())
	elseif not has_superwow and (event == "UNIT_HEALTH" and arg1 == "player" and UnitHealth("player") == 0) then
		for k,totem in pairs(this.totems) do
			totem.active = nil
			totem.timer = 0
			totem:SetValue(0)
		end
		SpellCast[1] = nil
		SpellCast[2] = nil
		Totems:FullUpdate(this:GetParent())
	elseif event == "UNIT_CASTEVENT" then
		-- print(arg1 .. " "..arg2.." "..(arg3 or "x"))
		if arg1 ~= player_guid or arg3 ~= "CAST" then return end

		-- recall
		if arg4 == 45513 then
			for k,totem in pairs(this.totems) do
				totem.active = nil
				totem.timer = 0
				totem:SetValue(0)
			end
			Totems:FullUpdate(this:GetParent())
		end

		local spell_name,spell_rank_str = SpellInfo(arg4)
		if TotemDB[spell_name] then
			local totem = this.totems[TotemDB[spell_name]["type"]]
			local dur = TotemDB[spell_name]["dur"]
			local _,_,rank = string.find(spell_rank_str,"Rank (%d+)")

			dur = dur[tonumber(rank)] or dur[1]
			totem.timer = dur + 0.5 -- why + 0.5?
			totem:SetMinMaxValues(0,dur)
			totem.active = true
			Totems:FullUpdate(this:GetParent())
		end
	elseif not has_superwow then
		isCasting = false
		if SpellCast and TotemDB[SpellCast[1]] then
			local totem = this.totems[TotemDB[SpellCast[1]]["type"]]
			local dur = TotemDB[SpellCast[1]]["dur"]
			dur = dur[tonumber(SpellCast[2])] or dur[1]
			totem.timer = dur + 0.5
			totem:SetMinMaxValues(0,dur)
			totem.active = true
			Totems:FullUpdate(this:GetParent())
		end
	end
end

local function OnUpdate()
	for _,totem in pairs(this.totems) do
		if totem.active then
			totem.timer = totem.timer - arg1
			if totem.timer <= 0 then
				totem.timer = 0
				totem.active = nil
				Totems:FullUpdate(this:GetParent())
			end
			totem:SetValue(totem.timer)
		end
	end
end

local function gcdCheck()
	local _,_,offset,numSpells = GetSpellTabInfo(GetNumSpellTabs())
	local numAllSpell = offset + numSpells;
	local gcd
	for i=1,numAllSpell do
		local name = GetSpellName(i,"BOOKTYPE_SPELL");
		if ( name == BS["Lightning Bolt"] ) then
			_,gcd = GetSpellCooldown(i,"BOOKTYPE_SPELL")
			break
		end
	end
	return (gcd == 1.5)
end

local function ProcessSpellCast(spellName, rank)
	if (spellName and rank) and not isCasting then
		isCasting = true
		SpellCast[1] = spellName
		SpellCast[2] = rank
	end
end

-- no sense hooking if we use CASTEVENT
if not has_superwow then
	local oldCastSpell = CastSpell
	local function newCastSpell(spellId, spellbookTabNum)
		local gcd = gcdCheck()
		-- Call the original function so there's no delay while we process
		oldCastSpell(spellId, spellbookTabNum)
		if gcd then return end
		local spellName, rank = GetSpellName(spellId, spellbookTabNum)
		_,_,rank = string.find(rank,"(%d+)")
		ProcessSpellCast(spellName, rank or 1)
	end
	CastSpell = newCastSpell

	local oldCastSpellByName = CastSpellByName
	local function newCastSpellByName(spellName, onSelf)
		local gcd = gcdCheck()
		-- Call the original function
		oldCastSpellByName(spellName, onSelf)
		if gcd then return end
		local _,_,rank = string.find(spellName,"(%d+)")
		local _, _, spellName = string.find(spellName, "^([^%(]+)")
		if not rank then
			local i = 1
			while GetSpellName(i, BOOKTYPE_SPELL) do
				local s, r = GetSpellName(i, BOOKTYPE_SPELL)
				if s == spellName then
					rank = r
				end
				i = i+1
			end
			if rank then
				_,_,rank = string.find(rank,"(%d+)")
			end
		end
		if (spellName) then
			ProcessSpellCast(spellName, rank)
		end
	end
	CastSpellByName = newCastSpellByName

	local oldUseAction = UseAction
	local function newUseAction(a1, a2, a3)
		local gcd = gcdCheck()
		tooltip:ClearLines()
		tooltip:SetAction(a1)
		local spellName = LunaScanTipTextLeft1:GetText()
		-- Call the original function
		oldUseAction(a1, a2, a3)
		if gcd then return end
		-- Test to see if this is a macro
		if ( GetActionText(a1) or not spellName ) then
			return
		end
		local rank = LunaScanTipTextRight1:GetText()
		if rank then
			_,_,rank = string.find(rank,"(%d+)")
		else
			rank = 1
		end
		ProcessSpellCast(spellName, rank)
	end
	UseAction = newUseAction
end

function Totems:OnEnable(frame)
	if playerclass ~= "SHAMAN" then return end
	if not frame.totemBar then
		frame.totemBar = CreateFrame("Frame", nil, frame)
		frame.totemBar.totems = {}
		for id=1, 4 do
			frame.totemBar.totems[id] = CreateFrame("Statusbar", nil, frame.totemBar)
			frame.totemBar.totems[id]:SetMinMaxValues(0,1)
			frame.totemBar.totems[id]:SetValue(0)
		end
		frame.totemBar.totems[1]:SetPoint("LEFT", frame.totemBar, "LEFT")
		frame.totemBar.totems[2]:SetPoint("LEFT", frame.totemBar.totems[1], "RIGHT", 1, 0)
		frame.totemBar.totems[3]:SetPoint("LEFT", frame.totemBar.totems[2], "RIGHT", 1, 0)
		frame.totemBar.totems[4]:SetPoint("LEFT", frame.totemBar.totems[3], "RIGHT", 1, 0)
	end
	frame.totemBar:SetScript("OnUpdate", OnUpdate)
	frame.totemBar:SetScript("OnEvent", OnEvent)
	if has_superwow then
		frame.totemBar:RegisterEvent("UNIT_CASTEVENT")
	else
		frame.totemBar:RegisterEvent("SPELLCAST_STOP")
		frame.totemBar:RegisterEvent("UNIT_HEALTH")
	end
	frame.totemBar:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function Totems:OnDisable(frame)
	if frame.totemBar then
		frame.totemBar:SetScript("OnUpdate", nil)
		frame.totemBar:SetScript("OnEvent", nil)
		frame.totemBar:UnregisterAllEvents()
		for i=1, 4 do
			frame.totemBar.totems[i].active = nil
			frame.totemBar.totems[i]:SetValue(0)
		end
	end
end

function Totems:FullUpdate(frame)
	local totemWidth = (frame.totemBar:GetWidth() - 3) / 4
	local totemHeight = frame.totemBar:GetHeight()
	local active
	for i=1, 4 do
		frame.totemBar.totems[i]:SetHeight(totemHeight)
		frame.totemBar.totems[i]:SetWidth(totemWidth)
		if frame.totemBar.totems[i].active then
			active = true
			break
		end
	end
	if LunaUF.db.profile.units[frame.unitGroup].totemBar.hide then
		if active then
			if frame.totemBar.hidden then
				frame.totemBar.hidden = nil
				LunaUF.Units:PositionWidgets(frame)
			end
		else
			if not frame.totemBar.hidden then
				frame.totemBar.hidden = true
				LunaUF.Units:PositionWidgets(frame)
			end
		end
	elseif frame.totemBar.hidden then
		frame.totemBar.hidden = nil
		LunaUF.Units:PositionWidgets(frame)
	end
end

function Totems:SetBarTexture(frame,texture)
	if frame.totemBar then
		for i,totem in ipairs(frame.totemBar.totems) do
			totem:SetStatusBarTexture(texture)
			totem:SetStatusBarColor(unpack(totemcolors[i]))
		end
	end
end
