local parent, ns = ...
local oUF = ns.oUF

local UnitAura, UnitGUID = UnitAura, UnitGUID
local GUIDs = {}

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
}

local SetupGUID
do 
	local cache = setmetatable({}, {__type = "k"})

	local frame = CreateFrame"Frame"
	frame:SetScript("OnEvent", function(self, event)
		for k,t in pairs(GUIDs) do
			GUIDs[k] = nil
			wipe(t)
			cache[t] = true
		end
	end)
	frame:RegisterEvent"PLAYER_REGEN_ENABLED"
	frame:RegisterEvent"PLAYER_ENTERING_WORLD"
	
	function SetupGUID(guid)
		local t = next(cache)
		if t then
			cache[t] = nil
		else
			t = {}
		end
		GUIDs[guid] = t
	end
end

local function DefaultResetIcon(watch, icon, count, duration, remaining)
	if not icon.onlyShowMissing then
		if icon.cd then
			if duration and duration > 0 then
				icon.cd:SetCooldown(remaining - duration, duration)
				icon.cd:Show()
			else
				icon.cd:Hide()
			end
		end
		if icon.count then
			icon.count:SetText(count > 1 and count)
		end
		if icon.overlay then
			icon.overlay:Hide()
		end
		icon:SetAlpha(watch.presentAlpha)
		icon:Show()
		if watch.PostResetIcon then watch.PostResetIcon(watch, icon) end
	end
end

local function ResetIcon(watch, icon, ...)
	if watch.OverrideResetIcon then
		watch.OverrideResetIcon(watch, icon, ...)
	else
		DefaultResetIcon(watch, icon, ...)
	end
end

local function DefaultExpireIcon(watch, icon)
	if not icon.onlyShowPresent then
		if icon.cd then 
			icon.cd:Hide() 
		end
		if icon.count then 
			icon.count:SetText() 
		end
		icon:SetAlpha(watch.missingAlpha)
		if icon.overlay then
			icon.overlay:Show()
		end
		icon:Show()
		if watch.PostExpireIcon then watch.PostExpireIcon(watch, icon) end
	end
end

local function ExpireIcon(watch, icon, ...)
	if watch.OverrideExpireIcon then
		watch.OverrideExpireIcon(watch, icon, ...)
	else
		DefaultExpireIcon(watch, icon, ...)
	end
end

local Update
do
	local found = {}
	function Update(frame, event, unit)
		if frame.unit ~= unit then return end
		local watch = frame.AuraWatch
		local index, icons = 1, watch.watched
		local _, name, texture, count, duration, remaining, caster, key, icon, spellid 
		local filter = "HELPFUL"
		local guid = UnitGUID(unit)
		if not GUIDs[guid] then SetupGUID(guid) end
		
		for key, icon in pairs(icons) do
			icon:Hide()
		end
		
		while true do
			name, _, texture, count, _, duration, remaining, caster, _, _, spellid = UnitAura(unit, index, filter)
			if not name then 
				if filter == "HELPFUL" then
					filter = "HARMFUL"
					index = 1
				else
					break
				end
			else
				if watch.strictMatching then
					key = spellid
				else
					key = name..texture
				end
				icon = icons[key]
				if icon and (icon.anyUnit or (caster and icon.fromUnits[caster])) then
					ResetIcon(watch, icon, count, duration, remaining)
					GUIDs[guid][key] = true
					found[key] = true
				end
				index = index + 1
			end
		end
		
		for key in pairs(GUIDs[guid]) do
			if icons[key] and not found[key] then
				ExpireIcon(watch, icons[key])
			end
		end
		
		wipe(found)
	end
end

local function SetupIcons(self)

	local watch = self.AuraWatch
	local icons = watch.icons
	watch.watched = {}
	if not watch.missingAlpha then watch.missingAlpha = 0.75 end
	if not watch.presentAlpha then watch.presentAlpha = 1 end
	
	for _,icon in pairs(icons) do
	
		local name, _, image = GetSpellInfo(icon.spellID)
		if not name then error("oUF_AuraWatch error: no spell with "..tostring(icon.spellID).." spell ID exists") end
		icon.name = name
	
		if not watch.customIcons then
			local cd = CreateFrame("Cooldown", nil, icon)
			cd:SetAllPoints(icon)
			icon.cd = cd

			local tex = icon:CreateTexture(nil, "BACKGROUND")
			tex:SetAllPoints(icon)
			tex:SetTexture(image)
			icon.icon = tex
			
			local overlay = icon:CreateTexture(nil, "OVERLAY")
			overlay:SetTexture"Interface\\Buttons\\UI-Debuff-Overlays"
			overlay:SetAllPoints(icon)
			overlay:SetTexCoord(.296875, .5703125, 0, .515625)
			overlay:SetVertexColor(1, 0, 0)
			icon.overlay = overlay

			local count = icon:CreateFontString(nil, "OVERLAY")
			count:SetFontObject(NumberFontNormal)
			count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -1, 0)
			icon.count = count
		end

		if icon.onlyShowMissing == nil then
			icon.onlyShowMissing = watch.onlyShowMissing
		end
		if icon.onlyShowPresent == nil then
			icon.onlyShowPresent = watch.onlyShowPresent
		end
		if icon.fromUnits == nil then
			icon.fromUnits = watch.fromUnits or PLAYER_UNITS
		end
		if icon.anyUnit == nil then
			icon.anyUnit = watch.anyUnit
		end
		
		if watch.strictMatching then
			watch.watched[icon.spellID] = icon
		else
			watch.watched[name..image] = icon
		end

		if watch.PostCreateIcon then watch:PostCreateIcon(icon, icon.spellID, name, self) end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	if self.AuraWatch then
		self.AuraWatch.__owner = self
		self.AuraWatch.ForceUpdate = ForceUpdate
		
		self:RegisterEvent("UNIT_AURA", Update)
		SetupIcons(self)
		return true
	else
		return false
	end
end

local function Disable(self)
	if self.AuraWatch then
		self:UnregisterEvent("UNIT_AURA", Update)
		for _,icon in pairs(self.AuraWatch.icons) do
			icon:Hide()
		end
	end
end

oUF:AddElement("AuraWatch", Update, Enable, Disable)
