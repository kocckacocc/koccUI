if not oUF then return end

--[[

Based on Hungtar's oUF Global Cooldown Bar
http://www.wowinterface.com/downloads/info14769-oUF_GCD-HungtarsoUFGlobalCooldownBar.html

Spell IDs come from Hungtar's. Not all these spells are available at 
level 1 (most are learned at level 4). If you have a better suggestion(s),
post a comment at the above URL.

--]]

local referenceSpells = {
	49892,			-- Death Coil (Death Knight)
	66215,			-- Blood Strike (Death Knight)
	1978,			-- Serpent Sting (Hunter)
	585,			-- Smite (Priest)
	19740,			-- Blessing of Might (Paladin)
	172,			-- Corruption (Warlock)
	5504,			-- Conjure Water (Mage)
	772,			-- Rend (Warrior)
	331,			-- Healing Wave (Shaman)
	1752,			-- Sinister Strike (Rogue)
	5176,			-- Wrath (Druid)
}


local GetTime = GetTime
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local GetSpellCooldown = GetSpellCooldown


local spellId = nil


local FindSpellId = function()
	local FindInSpellbook = function(spell)
		for tab = 1, 4 do
			local _, _, offset, numSpells = GetSpellTabInfo(tab)
			for i = (1+offset), (offset + numSpells) do
				local bspell = GetSpellName(i, BOOKTYPE_SPELL)
				if (bspell == spell) then
					return i   
				end
			end
		end
		return nil
	end

	for _, lspell in pairs(referenceSpells) do
		local na = GetSpellInfo (lspell)
		local x = FindInSpellbook(na)
		if x ~= nil then
			return lspell
		end
	end

	return nil
end


local Update = function(self, event, unit)
	if self.GCD_frame then
		if not spellId then
			spellId = FindSpellId()
			if not spellId then
				print ("oUF_GCD_frame: Unable to find reference spell! Aborting.")
				return
			end
		end

		if not self.GCD_frame.Cooldown then
			local cooldown = CreateFrame('Cooldown', nil, self.GCD_frame, 'CooldownFrameTemplate')
			cooldown:SetPoint('CENTER', 0, -1)
			cooldown:SetHeight(self.GCD_frame:GetHeight())
			cooldown:SetWidth(self.GCD_frame:GetWidth())
			self.GCD_frame.Cooldown = cooldown
		end
		
		local start, dur, enable = GetSpellCooldown(spellId)
		if (start == 0) then -- interrupted
			if self.GCD_frame.GCD_hideFrame then self.GCD_frame:Hide() end
			self:SetScript('OnUpdate', nil)		
		else
			if self.GCD_frame.GCD_hideFrame then self.GCD_frame:Show() end
			self.GCD_frame.Cooldown:SetCooldown(start, dur)
			self.GCD_frame.endTime = start + dur
			if (not self:GetScript('OnUpdate')) then
				self:SetScript('OnUpdate', function(self, elapsed)
					if (self.GCD_frame.endTime < GetTime()) then
						if self.GCD_frame.GCD_hideFrame then self.GCD_frame:Hide() end
						self:SetScript('OnUpdate', nil)
					end
				end)
			end
		end
	end
end


local Enable = function(self)
	if (self.GCD_frame) then
--		if not self.GCD_frame.GCD_hideFrame then self.GCD_frame:Show() end
		self:RegisterEvent('SPELL_UPDATE_COOLDOWN', Update)
	end
end


local Disable = function(self)
	if (self.GCD_frame) then
		self:UnregisterEvent('SPELL_UPDATE_COOLDOWN')
		if self.GCD_frame.GCD_hideFrame then self.GCD_frame:Hide() end
		self:SetScript('OnUpdate', nil)
	end
end


oUF:AddElement('GCD_frame', Update, Enable, Disable)
