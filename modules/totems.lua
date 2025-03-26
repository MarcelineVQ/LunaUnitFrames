local Totems = {}
local L = LunaUF.L
local BS = LunaUF.BS
local _,playerclass = UnitClass("player")
local tooltip = LunaUF.ScanTip
local SpellCast = {}
local isCasting
LunaUF:RegisterModule(Totems, "totemBar", L["Totem Bar"], true)

local has_superwow = SetAutoloot and true or false
local range_talent = false
local set_bonus = false

local player_guid = nil

local totemcolors = {
	{1,0,0},
	{0,0,1},
	{0.78,0.61,0.43},
	{0.41,0.80,0.94}
}
local inv_slots = {1,3,5,6,7,8,9,10}
local earthfury_set = {
	[1] = "Earthfury Helmet",
	[3] = "Earthfury Spaulders",
	[5] =	"Earthfury Chestpiece",
	[6] = "Earthfury Belt",
	[7] = "Earthfury Pants",
	[8] = "Earthfury Boots",
	[9] = "Earthfury Bracers",
	[10] = "Earthfury Gloves",
}

local TotemDB = {
	[BS["Searing Totem"]] = {
		type = 1,
		dur = {30,
		35,
		40,
		45,
		50,
		55},
		range = 20,
	},
	[BS["Grace of Air Totem"]] = {
		type = 4,
		dur = {120,
		120,
		120},
		range = 20,
		range_changes = true,
	},
	[BS["Nature Resistance Totem"]] = {
		type = 4,
		dur = {120,
		120,
		120},
		range = 20,
		range_changes = true,
	};
	[BS["Healing Stream Totem"]] = {
		type = 2,
		dur = {60,
		60,
		60,
		60,
		60},
		range = 20,
		range_changes = true,
	},
	[BS["Strength of Earth Totem"]] = {
		type = 3,
		dur = {120,
		120,
		120,
		120,
		120},
		range = 20,
		range_changes = true,
	},
	[BS["Fire Resistance Totem"]] = {
		type = 2,
		dur = {120,
		120,
		120},
		range = 20,
		range_changes = true,
	},
	[BS["Flametongue Totem"]] = {
		type = 1,
		dur = {120,
		120,
		120,
		120},
		range = 20,
		-- range_changes = true, -- todo: bug, flametongue is unaffected by range increases
	},
	[BS["Mana Tide Totem"]] = {
		type = 2,
		dur = {12,
		12,
		12},
	},
	[BS["Stoneclaw Totem"]] = {
		type = 3,
		dur = {15,
		15,
		15,
		15,
		15,
		15},
		range = 8,
	},
	[BS["Magma Totem"]] = {
		type = 1,
		dur = {20,
		20,
		20,
		20},
		range = 8,
	},
	[BS["Mana Spring Totem"]] = {
		type = 2,
		dur = {60,
		60,
		60,
		60},
		range = 20,
		range_changes = true,
	},
	[BS["Windwall Totem"]] = {
		type = 4,
		dur = {120,
		120,
		120},
		range = 20,
		range_changes = true,
	},
	[BS["Frost Resistance Totem"]] = {
		type = 1,
		dur = {120,
		120,
		120},
		range = 20,
		range_changes = true,
	},
	[BS["Stoneskin Totem"]] = {
		type = 3,
		dur = {120,
		120,
		120,
		120,
		120,
		120},
		range = 20,
		range_changes = true,
	},
	[BS["Fire Nova Totem"]] = {
		type = 1,
		dur = {4,
		4,
		4,
		4,
		4},
		range = 10,
	},
	[BS["Windfury Totem"]] = {
		type = 4,
		dur = {120,
		120,
		120},
		range = 20,
		range_changes = true,
	},
	[BS["Disease Cleansing Totem"]] = {
		type = 2,
		dur = {120},
		range = 20,
		range_changes = true,
	},
	[BS["Sentry Totem"]] = {
		type = 4,
		dur = {300},
	},
	[BS["Grounding Totem"]] = {
		type = 4,
		dur = {45},
		range = 20,
		range_changes = true,
	},
	[BS["Poison Cleansing Totem"]] = {
		type = 2,
		dur = {120},
		range = 20,
		range_changes = true,
	},
	[BS["Earthbind Totem"]] = {
		type = 3,
		dur = {45},
		range = 10,
	},
	[BS["Tremor Totem"]] = {
		type = 3,
		dur = {120},
		range = 30,
		range_changes = true,
	},
	[BS["Tranquil Air Totem"]] = {
		type = 4,
		dur = {120},
		range = 20, -- todo: bug? tranquil air is unaffected by range increases
	}
}

local function ClearTotem(totem)
	totem.active = nil
	totem.timer = 0
	totem.guid = nil
	totem.range = nil
	totem.range_changes = nil

	totem:SetValue(0)
	totem:SetAlpha(1)
end

local function ClearTotems(totems)
	for k,totem in pairs(totems) do
		ClearTotem(totem)
	end
end

function Totems.PLAYER_ENTERING_WORLD(frame)
	_,player_guid = UnitExists("player")

	ClearTotems(frame.totems)
	Totems:FullUpdate(frame:GetParent())
	Totems.CHARACTER_POINTS_CHANGED(frame,0)
end

function Totems.UNIT_HEALTH(frame,unit)
	if has_superwow or UnitHealth("player") ~= 0 then return end

	ClearTotems(frame.totems)
	SpellCast[1] = nil
	SpellCast[2] = nil
	Totems:FullUpdate(frame:GetParent())
end

function Totems.CHARACTER_POINTS_CHANGED(frame,how_many)
	-- do we have totemic mastery
	local name, icon, tier, column, currRank, maxRank, _, meetsPrereq = GetTalentInfo(3, 8)
	if currRank and currRank > 0 then
		range_talent = true
	else
		range_talent = false
	end
end

function Totems.UNIT_MODEL_CHANGED(frame,unit)
	if not UnitIsUnit(unit.."owner","player") then return end
	local _,_,totem = string.find(UnitName(arg1), "(.- Totem)")
	if not (totem and TotemDB[totem]) then return end

	frame.totems[TotemDB[totem].type].guid = arg1

	-- clean stales if any
	for _,totem in pairs(frame.totems) do
		if not UnitExists(totem.guid) then
			ClearTotem(totem)
		end
	end
end

function Totems.UNIT_CASTEVENT(frame,caster,target,action,spell_id,cast_time)
	if not UnitIsUnit(caster, "player") or action ~= "CAST" then return end

	-- recall
	if spell_id == 45513 then
		ClearTotems(frame.totems)
		Totems:FullUpdate(frame:GetParent())
	end

	local spell_name,spell_rank_str = SpellInfo(spell_id)
	local totem_data = TotemDB[spell_name]
	if totem_data then
		local totem = frame.totems[totem_data.type]
		local dur = totem_data.dur
		local _,_,rank = string.find(spell_rank_str,"Rank (%d+)")

		dur = dur[tonumber(rank)] or dur[1]
		totem.timer = dur + 0.5 -- why + 0.5?
		totem:SetMinMaxValues(0,dur)
		totem.active = true
		totem.range = totem_data.range
		totem.range_changes = totem_data.range_changes

		Totems:FullUpdate(frame:GetParent())
	end
end

function Totems.SPELLCAST_STOP(frame)
	isCasting = false
	if SpellCast and TotemDB[SpellCast[1]] then
		local totem = frame.totems[TotemDB[SpellCast[1]].type]
		local dur = TotemDB[SpellCast[1]].dur
		dur = dur[tonumber(SpellCast[2])] or dur[1]
		totem.timer = dur + 0.5
		totem:SetMinMaxValues(0,dur)
		totem.active = true
		Totems:FullUpdate(frame:GetParent())
	end
end

local inv_elapsed = 0 -- don't check inv multiple times at once
function Totems.UNIT_INVENTORY_CHANGED(frame,unit)
	if unit ~= "player" then return end
	if inv_elapsed < 0 then inv_elapsed = 0 end
end

local dist_elapsed = 0 -- don't check distance too often
local function OnUpdate()
	if has_superwow then
		dist_elapsed = dist_elapsed + arg1
		if inv_elapsed >= 0 then inv_elapsed = inv_elapsed + arg1 end

		if dist_elapsed > 0.15 then
			dist_elapsed = 0
			local px,py,pz = UnitPosition("player")
			for _,totem in pairs(this.totems) do
				if totem.active and totem.range then
					if totem.guid and UnitCanAssist(totem.guid,"player") then
						local totem_range = 1.8 + totem.range -- todo: 1.8 for tauren, what about others?
						if totem.range_changes then
							-- range_talent and set_bonus can change totem range on live totems
							totem_range = totem_range + (range_talent and 10 or 0) + (set_bonus and 10 or 0)
						end
						local tx,ty,tz = UnitPosition(totem.guid)
						local dist = math.sqrt((tx-px)^2 + (ty-py)^2 + (tz-pz)^2)
						if dist > totem_range then
							totem:SetAlpha(0.5)
						else
							totem:SetAlpha(1)
						end
					end
				end
			end
		end

		if inv_elapsed > 0.5 then
			inv_elapsed = -1
			local set_count = 0
			set_bonus = false
			for _,slot in ipairs(inv_slots) do
				local _,_,link = string.find(GetInventoryItemLink("player", slot) or "", "(item:%d+)")
				if link and earthfury_set[slot] and GetItemInfo(link) == earthfury_set[slot] then
					set_count = set_count + 1
				end
				if set_count >= 3 then
					set_bonus = true
					break
				end
			end
		end
	end

	for _,totem in pairs(this.totems) do
		if totem.active then
			totem.timer = totem.timer - arg1
			if totem.timer <= 0 then
				ClearTotem(totem)
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
	frame.totemBar:SetScript("OnEvent", function () Totems[event](frame.totemBar,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9) end)
	if has_superwow then
		frame.totemBar:RegisterEvent("UNIT_CASTEVENT")
		frame.totemBar:RegisterEvent("UNIT_MODEL_CHANGED")
		frame.totemBar:RegisterEvent("CHARACTER_POINTS_CHANGED")
		frame.totemBar:RegisterEvent("UNIT_INVENTORY_CHANGED")
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
