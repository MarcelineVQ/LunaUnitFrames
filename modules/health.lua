local LunaUF = LunaUF
local Health = {}
LunaUF:RegisterModule(Health, "healthBar", LunaUF.L["Health bar"], true)

-- local tooltip = LunaUF.ScanTip

-- Fallback buff scan for death state detection when auras module is disabled.
-- Only called for dead hunters (feign death) and full-hp priests (spirit of redemption).
local function deathbuffcheck(frame)
	local unit = frame.unit
	local _,class = UnitClass(unit)
	local searchFeign = class == "HUNTER"
	local searchSpirit = class == "PRIEST"
	if not searchFeign and not searchSpirit then return end
	for i=1,32 do
		if not UnitBuff(unit,i) then
			return
		end
		LunaUF.ScanTip:ClearLines()
		LunaUF.ScanTip:SetUnitBuff(unit,i)
		local name = LunaScanTipTextLeft1:GetText()
		if searchFeign and name == LunaUF.L["Feign Death"] then
			frame.hasFeignDeath = true
			return
		elseif searchSpirit and name == LunaUF.L["Spirit of Redemption"] then
			frame.hasSpiritOfRedemption = true
			return
		end
	end
end

-- Update frame death-state flags, using aura flags if available or scanning as fallback.
local function updateDeathState(frame)
	local aurasEnabled = LunaUF.db.profile.units[frame.unitGroup].auras
		and LunaUF.db.profile.units[frame.unitGroup].auras.enabled
	if not aurasEnabled then
		frame.hasFeignDeath = nil
		frame.hasSpiritOfRedemption = nil
		local _,class = UnitClass(frame.unit)
		if (class == "HUNTER" and frame.isDead)
		or (class == "PRIEST" and UnitHealth(frame.unit) == UnitHealthMax(frame.unit)) then
			deathbuffcheck(frame)
		end
	end
	if frame.hasFeignDeath then
		frame.isDead = false
	elseif frame.hasSpiritOfRedemption then
		frame.isDead = true
	end
end

local function OnEvent()
	if arg1 ~= this:GetParent().unit then return end
	if event == "UNIT_FACTION" or event == "UNIT_HAPPINESS" then
		this.dirty_color = true
	elseif event == "UNIT_MAXHEALTH" then
		this.dirty_maxhealth = true
	end
	this.dirty = true
	this:GetParent().dirty_tags = true
end

local function getGradientColor(unit, startColor)
	local percent = UnitHealth(unit) / UnitHealthMax(unit)

	if( percent >= 1 ) then return startColor end
	if( percent == 0 ) then return LunaUF.db.profile.healthColors.red end

	local sR, sG, sB, eR, eG, eB = 0, 0, 0, 0, 0, 0
	local modifier, inverseModifier = percent * 2, 0
	if( percent > 0.50 ) then
		sR, sG, sB = startColor.r, startColor.g, startColor.b
		eR, eG, eB = LunaUF.db.profile.healthColors.yellow.r, LunaUF.db.profile.healthColors.yellow.g, LunaUF.db.profile.healthColors.yellow.b

		modifier = modifier - 1
	else
		sR, sG, sB = LunaUF.db.profile.healthColors.yellow.r, LunaUF.db.profile.healthColors.yellow.g, LunaUF.db.profile.healthColors.yellow.b
		eR, eG, eB = LunaUF.db.profile.healthColors.red.r, LunaUF.db.profile.healthColors.red.g, LunaUF.db.profile.healthColors.red.b
	end

	inverseModifier = 1 - modifier
	return { r = eR * inverseModifier + sR * modifier,
		 g = eG * inverseModifier + sG * modifier,
		 b = eB * inverseModifier + sB * modifier }
end

Health.getGradientColor = getGradientColor

local function classColor(unit)
	local _, tempclass = UnitClass(unit)
	local class = UnitCreatureFamily(unit) or tempclass
	return class and LunaUF.db.profile.classColors[class]
end

local function updateTimer()
	local bar = this
	local frame = bar:GetParent()
	local dirty = bar.dirty

	-- Handle maxhealth change (rare, but needs SetMinMaxValues before SetValue)
	if bar.dirty_maxhealth then
		bar:SetMinMaxValues(0, UnitHealthMax(frame.unit))
		bar.dirty_maxhealth = nil
		dirty = true
	end

	-- Handle color-only events (faction/happiness change)
	if bar.dirty_color then
		Health:UpdateColor(frame)
		bar.dirty_color = nil
	end

	-- Check for actual health change
	local currentHealth = UnitHealth(frame.unit)
	if currentHealth ~= bar.currentHealth then
		dirty = true
	end

	if not dirty then return end
	bar.dirty = nil

	-- Update offline/dead state
	frame.isOffline = not UnitIsConnected(frame.unit)
	frame.isDead = UnitIsDeadOrGhost(frame.unit) or (UnitHealth(frame.unit) == 1 and not UnitIsVisible(frame.unit))
	updateDeathState(frame)

	-- Feigning hunters report 0 hp from the API; preserve their last real health
	if frame.hasFeignDeath then return end

	bar.currentHealth = currentHealth

	-- Update bar value
	if frame.isOffline or frame.isDead then
		bar:SetValue((frame.isOffline and UnitHealthMax(frame.unit)) or (frame.isDead and 0))
	else
		bar:SetValue(currentHealth)
	end

	-- Update bar color based on state
	if frame.isOffline then
		bar.wasOffline = true
		Health:SetBarColor(bar, LunaUF.db.profile.units[frame.unitGroup].healthBar.invert, LunaUF.db.profile.healthColors.offline)
	elseif bar.wasOffline then
		bar.wasOffline = nil
		Health:UpdateColor(frame)
	elseif bar.hasPercent then
		local color
		if ( LunaUF.db.profile.units[frame.unitGroup].healthBar.classGradient and
		     ( UnitIsPlayer(frame.unit) or UnitCreatureFamily(frame.unit) ) ) then
			color = classColor(frame.unit)
		end
		color = getGradientColor(frame.unit, color or LunaUF.db.profile.healthColors.green)
		Health:SetBarColor(bar, LunaUF.db.profile.units[frame.unitGroup].healthBar.invert, color)
	end

	-- Update incoming heal
	if LunaUF.db.profile.units[frame.unitGroup].incheal.enabled and frame.incheal then
		LunaUF.modules.incheal:FullUpdate(frame)
	end
end

function Health:OnEnable(frame)
	if( not frame.healthBar ) then
		frame.healthBar = LunaUF.Units:CreateBar(frame)
		frame.fontstrings["healthBar"] = {
			["left"] = frame.healthBar:CreateFontString(nil, "ARTWORK"),
			["center"] = frame.healthBar:CreateFontString(nil, "ARTWORK"),
			["right"] = frame.healthBar:CreateFontString(nil, "ARTWORK"),
		}
		for align,fontstring in pairs(frame.fontstrings["healthBar"]) do
			fontstring:SetFont(LunaUF.defaultFont, 14)
			fontstring:SetShadowColor(0, 0, 0, 1.0)
			fontstring:SetShadowOffset(0.80, -0.80)
			fontstring:SetJustifyH(string.upper(align))
			fontstring:SetAllPoints(frame.healthBar)
		end
	else
		frame.healthBar:Show()
	end

	frame.healthBar:RegisterEvent("UNIT_FACTION")
	frame.healthBar:RegisterEvent("UNIT_HEALTH")
	frame.healthBar:RegisterEvent("UNIT_MAXHEALTH")

	if( UnitIsUnit(frame.unit,"pet") ) then
		frame.healthBar:RegisterEvent("UNIT_HAPPINESS")
	end

	frame.healthBar:SetScript("OnEvent", OnEvent)
	frame.healthBar:SetScript("OnUpdate", updateTimer)
end

function Health:OnDisable(frame)
	if frame.healthBar then
		frame.healthBar:UnregisterAllEvents()
		frame.healthBar:SetScript("OnEvent", nil)
		frame.healthBar:SetScript("OnUpdate", nil)
		frame.healthBar:Hide()
	end
end

function Health:SetBarColor(bar, invert, color)
	local r, g, b = color.r, color.g, color.b
	if( not invert ) then
		bar:SetStatusBarColor(r, g, b, LunaUF.db.profile.bars.alpha)
		if( not bar.background.overrideColor ) then
			bar.background:SetVertexColor(r, g, b, LunaUF.db.profile.bars.backgroundAlpha)
		end
	else
		bar.background:SetVertexColor(r, g, b, LunaUF.db.profile.bars.alpha)
		if( not bar.background.overrideColor ) then
			bar:SetStatusBarColor(0, 0, 0, 1 - LunaUF.db.profile.bars.backgroundAlpha)
		else
			bar:SetStatusBarColor(bar.background.overrideColor.r, bar.background.overrideColor.g, bar.background.overrideColor.b, 1 - LunaUF.db.profile.bars.backgroundAlpha)
		end
	end
end

function Health:UpdateColor(frame)
	frame.healthBar.hasReaction = nil
	frame.healthBar.hasPercent = nil
	frame.healthBar.wasOffline = nil

	local color
	local unit = frame.unit
	local reactionType = LunaUF.db.profile.units[frame.unitGroup].healthBar.reactionType
	if( not UnitIsConnected(unit) ) then
		frame.healthBar.wasOffline = true
		self:SetBarColor(frame.healthBar, LunaUF.db.profile.units[frame.unitGroup].healthBar.invert, LunaUF.db.profile.healthColors.offline)
		return
	elseif( UnitIsCharmed(unit) and UnitIsPlayer(unit) ) then
		self:SetBarColor(frame.healthBar, LunaUF.db.profile.units[frame.unitGroup].healthBar.invert, LunaUF.db.profile.healthColors.charmed)
		return
	elseif( LunaUF.db.profile.units[frame.unitGroup].healthBar.colorAggro and UnitThreatSituation(frame.unit) == 3 ) then
		self:SetBarColor(frame.healthBar, LunaUF.db.profile.units[frame.unitGroup].healthBar.invert, LunaUF.db.profile.healthColors.hostile)
		return
	elseif( not UnitIsTappedByPlayer(unit) and UnitIsTapped(unit) and UnitCanAttack("player", unit) ) then
		color = LunaUF.db.profile.healthColors.tapped
	elseif( unit == "pet" and reactionType == "happiness" and GetPetHappiness() ) then
		local happiness = GetPetHappiness()
		if( happiness == 3 ) then
			color = LunaUF.db.profile.healthColors.friendly
		elseif( happiness == 2 ) then
			color = LunaUF.db.profile.healthColors.neutral
		elseif( happiness == 1 ) then
			color = LunaUF.db.profile.healthColors.hostile
		end
	elseif( not UnitPlayerOrPetInRaid(unit) and not UnitPlayerOrPetInParty(unit) and ( ( ( reactionType == "player" or reactionType == "both" ) and UnitIsPlayer(unit) and not UnitIsFriend(unit, "player") ) or ( ( reactionType == "npc" or reactionType == "both" )  and not UnitIsPlayer(unit) ) ) ) then
		if( not UnitIsFriend(unit, "player") and UnitPlayerControlled(unit) ) then
			if( UnitCanAttack("player", unit) ) then
				color = LunaUF.db.profile.healthColors.hostile
			else
				color = LunaUF.db.profile.healthColors.enemyUnattack
			end
		elseif( UnitReaction(unit, "player") ) then
			local reaction = UnitReaction(unit, "player")
			if( reaction > 4 ) then
				color = LunaUF.db.profile.healthColors.friendly
			elseif( reaction == 4 ) then
				color = LunaUF.db.profile.healthColors.neutral
			elseif( reaction < 4 ) then
				if( UnitIsCivilian(unit) ) then
					color = LunaUF.db.profile.healthColors.enemyCivilian
				else
					color = LunaUF.db.profile.healthColors.hostile
				end
			end
		end
	elseif( LunaUF.db.profile.units[frame.unitGroup].healthBar.colorType == "class" and ( UnitIsPlayer(unit) or UnitCreatureFamily(unit) ) ) then
		color = classColor(frame.unit)
	elseif( LunaUF.db.profile.units[frame.unitGroup].healthBar.colorType == "static" ) then
		color = LunaUF.db.profile.healthColors.static
	end

	if not color or LunaUF.db.profile.units[frame.unitGroup].healthBar.classGradient then
		color = getGradientColor(unit, color or LunaUF.db.profile.healthColors.green)
		frame.healthBar.hasPercent = true
	end

	self:SetBarColor(frame.healthBar, LunaUF.db.profile.units[frame.unitGroup].healthBar.invert, color)
end

function Health:Update(frame)
	frame.isOffline = not UnitIsConnected(frame.unit)
	frame.isDead = UnitIsDeadOrGhost(frame.unit) or (UnitHealth(frame.unit) == 1 and not UnitIsVisible(frame.unit))
	updateDeathState(frame)
	frame.healthBar:SetMinMaxValues(0, UnitHealthMax(frame.unit))

	-- Feigning hunters report 0 hp from the API; preserve their last real health
	if frame.hasFeignDeath then
		frame.healthBar:SetValue(frame.currentHealth or UnitHealthMax(frame.unit))
	elseif frame.isOffline or frame.isDead then
		frame.healthBar:SetValue((frame.isOffline and UnitHealthMax(frame.unit)) or (frame.isDead and 0))
	else
		frame.currentHealth = UnitHealth(frame.unit)
		frame.healthBar:SetValue(UnitHealth(frame.unit))
	end

	-- Unit is offline, fill bar up + grey it
	if( frame.isOffline ) then
		frame.healthBar.wasOffline = true
		self:SetBarColor(frame.healthBar, LunaUF.db.profile.units[frame.unitGroup].healthBar.invert, LunaUF.db.profile.healthColors.offline)
		-- The unit was offline, but they no longer are so we need to do a forced color update
	elseif( frame.healthBar.wasOffline ) then
		frame.healthBar.wasOffline = nil
		self:UpdateColor(frame)
		-- Color health by percentage
	elseif( frame.healthBar.hasPercent ) then
		local color
		if ( LunaUF.db.profile.units[frame.unitGroup].healthBar.classGradient and
		     ( UnitIsPlayer(frame.unit) or UnitCreatureFamily(frame.unit) ) ) then
			color = classColor(frame.unit)
		end

		color = getGradientColor(frame.unit, color or LunaUF.db.profile.healthColors.green)
		self:SetBarColor(frame.healthBar, LunaUF.db.profile.units[frame.unitGroup].healthBar.invert, color)
	end

	if LunaUF.db.profile.units[frame.unitGroup].incheal.enabled and frame.incheal then
		LunaUF.modules.incheal:FullUpdate(frame)
	end
end

function Health:FullUpdate(frame)
	local tags = LunaUF.db.profile.units[frame.unitGroup].tags.bartags.healthBar
	if LunaUF.db.profile.units[frame.unitGroup].healthBar.vertical then
		frame.healthBar:SetOrientation("VERTICAL")
	else
		frame.healthBar:SetOrientation("HORIZONTAL")
	end
	frame.healthBar:SetReverse(LunaUF.db.profile.units[frame.unitGroup].healthBar.reverse)
	frame.healthBar.hasPercent = LunaUF.db.profile.units[frame.unitGroup].healthBar.classGradient
	for align,fontstring in pairs(frame.fontstrings["healthBar"]) do
		fontstring:SetFont("Interface\\AddOns\\LunaUnitFrames\\media\\fonts\\"..LunaUF.db.profile.font..".ttf", tags.size)
		fontstring:ClearAllPoints()
		fontstring:SetHeight(frame.healthBar:GetHeight())
		if align == "left" then
			fontstring:SetPoint("LEFT", frame.healthBar, "LEFT", 2, 0)
			fontstring:SetWidth((frame.healthBar:GetWidth()-4)*(tags.leftsize/100))
		elseif align == "center" then
			fontstring:SetPoint("CENTER", frame.healthBar, "CENTER")
			fontstring:SetWidth(frame.healthBar:GetWidth()*(tags.middlesize/100))
		else
			fontstring:SetPoint("RIGHT", frame.healthBar, "RIGHT", -2 , 0)
			fontstring:SetWidth((frame.healthBar:GetWidth()-4)*(tags.rightsize/100))
		end
	end
	Health:Update(frame)
	Health:UpdateColor(frame)
end

function Health:SetBarTexture(frame,texture)
	if frame.healthBar then
		frame.healthBar:SetStatusBarTexture(texture)
		frame.healthBar.background:SetTexture(texture)
		frame.healthBar:SetStretchTexture(LunaUF.db.profile.stretchtex)
	end
end
