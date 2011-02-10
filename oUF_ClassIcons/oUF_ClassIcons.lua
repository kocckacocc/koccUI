local classIcons = {
  ["WARRIOR"] = { 0.00, 0.25, 0.00, 0.25 },
  ["MAGE"] = { 0.25, 0.50, 0.00, 0.25 },
  ["ROGUE"] = { 0.50, 0.75, 0.00, 0.25 },
  ["DRUID"] = { 0.75, 1.00, 0.00, 0.25 },
  ["HUNTER"] = { 0.00, 0.25, 0.25, 0.50 },
  ["SHAMAN"] = { 0.25, 0.50, 0.25, 0.50 },
  ["PRIEST"] = { 0.50, 0.75, 0.25, 0.50 },
  ["WARLOCK"] = { 0.75, 1.00, 0.25, 0.50 },
  ["PALADIN"] = { 0.00, 0.25, 0.50, 0.75 },
  ["DEATHKNIGHT"] = { 0.25, 0.50, 0.50, 0.75 },
 }


local Update = function(self, event)
	local _, class = UnitClass(self.unit)
	local icon = self.ClassIcon
	local coords = classIcons[class]

	if(class) then
		icon:SetTexCoord(coords[1], coords[2], coords[3], coords[4]);
		icon:Show()
	else
		icon:Hide()
	end
end

local Enable = function(self)
	local cicon = self.ClassIcon

	if(cicon) then
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", Update)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", Update)

		cicon:SetTexture[[Interface\WorldStateFrame\Icons-Classes]]
		
		return true
	end
end

local Disable = function(self)
	local ricon = self.ClassIcon
	if(ricon) then
		self:UnregisterEvent("PARTY_MEMBERS_CHANGED", Update)
		self:UnregisterEvent("PLAYER_TARGET_CHANGED", Update)
	end
end

oUF:AddElement('ClassIcon', Update, Enable, Disable)