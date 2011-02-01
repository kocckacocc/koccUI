local parent, ns = ...
local oUF = ns.oUF

local referenceSpells = {
  'Find Fish',
  'Find Herbs',
  'Find Minerals',
  'Track Beasts', 
  'Track Demons',
  'Track Dragonkin', 
  'Track Elementals', 
  'Track Giants', 
  'Track Hidden',
  'Track Humanoids',
}

local spellid
local GetTime = GetTime
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local GetSpellCooldown = GetSpellCooldown

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

local ChooseSpell = function(rspell)
  if (rspell) then
    spellid = FindInSpellbook(rspell)
  end
  
  if (not spellid) then
    for _, lspell in pairs(referenceSpells) do
      spellid = FindInSpellbook(lspell)
      if (spellid) then return end
    end
  end
end

local OnUpdateGCD
do
	OnUpdateGCD = function(self)
   	if self.Spark then self.Spark:ClearAllPoints() end
  	local perc = (GetTime() - self.starttime) / self.duration
  	if perc > 1 then
      self:Hide()
  		return 
  	else
  		if self.Spark then self.Spark:SetPoint('CENTER', self, 'LEFT', self:GetWidth() * perc, 0) end
			self.Bar:SetValue(perc)
  	end
  end
end

local OnHideGCD = function(self)
 	self:SetScript('OnUpdate', nil)
	self.drawing = false
end

local OnShowGCD = function(self)
	self:SetScript('OnUpdate', OnUpdateGCD)
end

local Update = function(self, event, unit)
  if (self.GCD) then
    if not spellid then
      ChooseSpell(self.GCD.ReferenceSpellName)
    end

  	if (spellid) then
    	local start, dur = GetSpellCooldown(spellid, BOOKTYPE_SPELL)
      if (not start) then return end
      if (not dur) then dur = 0 end
      
      if ((self.GCD.drawing) and (dur == 0)) then
        self.GCD:Hide() 
      else
      	self.GCD.drawing = true
      	self.GCD.starttime = start
      	self.GCD.duration = dur
        self.GCD:Show()
      end
    end
  end
end

local Enable = function(self)
	if (self.GCD) then
    self.GCD:Hide()
    self.GCD.drawing = false
    self.GCD.starttime = 0
    self.GCD.duration = 0
    
    self:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN', Update)
    self.GCD:SetScript('OnHide', OnHideGCD)
    self.GCD:SetScript('OnShow', OnShowGCD)
  end
end

local Disable = function(self)
	if (self.GCD) then
		self:UnregisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
    self.GCD:Hide()  
	end
end

oUF:AddElement('GCD', Update, Enable, Disable)
