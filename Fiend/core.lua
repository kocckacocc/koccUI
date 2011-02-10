local ADDON_NAME, Fiend = ...
Fiend.L = Fiend.L or { }
local L = setmetatable(Fiend.L, { __index = function(t, s) t[s] = s return s end })

local addon = CreateFrame("Frame")
addon:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
addon:RegisterEvent("ADDON_LOADED")

local UnitAffectingCombat = UnitAffectingCombat
local UnitInVehicle = UnitInVehicle
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitName = UnitName
local pairs = pairs
local time = time

local timer = 0
local OnUpdate = function(self, elapsed)
	timer = timer + elapsed

	if timer > 0.5 then
		for i, d in pairs(self.displays) do
			d:OnUpdate(timer)
		end
		timer = 0
	end
end

local ldb
local band = bit.band
local filter = bit.bor(COMBATLOG_OBJECT_AFFILIATION_RAID, COMBATLOG_OBJECT_AFFILIATION_PARTY)
filter = bit.bor(filter, COMBATLOG_OBJECT_AFFILIATION_MINE)

local events = {
	["SWING_DAMAGE"] = "Damage",
	["RANGE_DAMAGE"] = "Damage",
	["SPELL_DAMAGE"] = "Damage",
	["SPELL_PERIODIC_DAMAGE"] = "Damage",
	["SPELL_HEAL"] = "Healing",
	["SPELL_PERIDOIC_HEAL"] = "Healing",
	["SPELL_SUMMON"] = true,
}

local lastAction = {}

-- [[ DPS TRACKING ENABLE HERE ]]
addon.trackDPS = true

function addon:ADDON_LOADED(name)
	if name ~= "Fiend" then return end

	ldb = LibStub and LibStub("LibDataBroker-1.1", true)

	if ldb then
		self:initDropDown()

		local obj = ldb:NewDataObject("Fiend", {
			type = "launcher",
			icon = [[Interface\Icons\Ability_BullRush]],
			OnClick = function(self, button)
				if button == "RightButton" then
					ToggleDropDownMenu(1, nil, addon.dropDown, "cursor")
				end
			end,
		})

		self.dataObj = obj
	end

	self:UnregisterEvent("ADDON_LOADED")

	self.displays = {}

	self.printNum = 10

	-- Displays are the windows
	local win = self:NewDisplay("main")
	-- View syntax:
	-- Display:NewView(String name, String[] events, int barSize, int[]
	-- headerColor, int[] barColor, bool dps)
	-- Only name, events and size are required.
	
	local dps = win:NewView(L["DPS"], {
		"SWING_DAMAGE",
		"RANGE_DAMAGE",
		"SPELL_DAMAGE",
		"SPELL_PERIODIC_DAMAGE",
	}, 12, { 0.2, 0.2, 0.2, 0.5 }, nil, true)
	
	local damage = win:NewView(L["Damage"], {
		"SWING_DAMAGE",
		"RANGE_DAMAGE",
		"SPELL_DAMAGE",
		"SPELL_PERIODIC_DAMAGE",
	}, 12, { 0.2, 0.2, 0.2 })

	local heal = win:NewView(L["Healing"], {
		"SPELL_HEAL",
		"SPELL_PERIDOIC_HEAL"
	}, 12, { 0.2, 0.2, 0.2 })

	local overHeal = win:NewView(L["OverHealing"], {
		"SPELL_HEAL",
		"SPELL_PERIDOIC_HEAL"
	}, 12, { 0.2, 0.2, 0.2 })
	
	overHeal.overHeal = true

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	self:Show()

	self:SetScript("OnUpdate", OnUpdate)

	self.ADDON_LOADED = nil
end

local spellId, spellName, spellSchool, ammount, over, school, resist
function addon:COMBAT_LOG_EVENT_UNFILTERED(timeStamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	if not events[event] or not band(sourceFlags, filter) then return end

	if event == "SWING_DAMAGE" then
		ammount, over, school, resist = ...
	elseif event == "SPELL_SUMMON" then
		-- This is to get summoned pets like totems etc
		return self:AddPet(destGUID, sourceGUID)
	else
		spellId, spellName, spellSchool, ammount, over, school, resist = ...
	end

	-- Bail, ususaly because the unit is in a vehicle and we dont have its
	-- GUID mapping
	local unit = self:GetUnit(sourceGUID)
	if not unit then return end

	ammount = ammount or 0
	resist = resist or 0
	over = over or 0

	-- Track over kill ?
	local damage = ammount - (over + resist)
	--local damage = ammount

	local overHeal
	if (event == "SPELL_HEAL" or event == "SPELL_PERIDOIC_HEAL") and over > 0 then
		overHeal = over
	end

	if damage > 0 or overHeal then
		local pet = self:IsPet(sourceGUID)

		if pet then
			sourceGUID = pet
			sourceName = UnitName(self:GetUnit(pet))
		end

		if(self.trackDPS) then
			lastAction[sourceGUID] = timeStamp
		end

		for name, display in pairs(self.displays) do
			display:CombatEvent(event, sourceGUID, damage, sourceName, overHeal)
		end
	end
end

if(addon.trackDPS) then
	function addon:InCombat(guid)
		return time() - (lastAction[guid] or 0) < 5
	end
end

function addon:initDropDown()
	local drop = CreateFrame("Frame", "FiendDropDown", UIParent, "UIDropDownMenuTemplate")
	self.menu = {
		{
			{
				text = "Fiend",
				owner = drop,
				isTitle = true,
			}, {
				text = "Windows",
				owner = drop,
				hasArrow = true,
				menuList = {
				},
			}
		}
	}

	UIDropDownMenu_Initialize(drop, function(horse, level, menuList)
		if not (menuList or self.menu[level]) then return end
		for k, v in ipairs(menuList or self.menu[level]) do
			v.value = k
			UIDropDownMenu_AddButton(v, level)
		end
	end, "MENU", 1)

	self.dropDown = drop
end

_G.Fiend = addon
