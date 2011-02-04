-- credits to Blooblahguy for bActionbars

local debug=false

if globaldebug then debug=true end

local bar1_1=CreateFrame("Frame","Bar1_1",UIParent)
local bar1_2=CreateFrame("Frame","Bar1_2",UIParent)
local bar1_3=CreateFrame("Frame","Bar1_3",UIParent)

local bar2=CreateFrame("Frame","Bar2",UIParent)
local bar3=CreateFrame("Frame","Bar3",UIParent)
local bar4=CreateFrame("Frame","Bar4",UIParent)
local bar5=CreateFrame("Frame","Bar5",UIParent)
local bar6=CreateFrame("Frame","Bar6",UIParent) 
local bar7=CreateFrame("Frame","Bar7",UIParent)

bar1w=(((bs+bsp)*4))-bsp
bar1h=bs

for i=1,7 do
		if i==1 then
		
			for j=1,3 do
				local bar=_G["Bar1_"..j]
				bar:SetFrameStrata("BACKGROUND")
				bar:SetPoint(bp[1][j].a,UIParent,bp[1][j].p,bp[1][j].x,bp[1][j].y)
				bar:SetSize(bar1w,bar1h)
				if debug then
					bar:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8"})
					bar:SetBackdropColor(0,0,0,0.5)
				end
			end
			
		else
			local bar=_G["Bar"..i]
			bar:SetFrameStrata("BACKGROUND")
			bar:SetPoint(bp[i].a,UIParent,bp[i].p,bp[i].x,bp[i].y)
			if debug then
				bar:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8"})
				bar:SetBackdropColor(0,0,0,0.5)
			end
		end
end

local gdir=(((bs+bsp)*12))-bsp
local wdir=bs

local g2dir=(((bs+bsp)*6))-bsp
local w2dir=((bs*2))+bsp

bwidth=(bs+bsp)*4-bsp
bheight=(bs+bsp)*3-bsp

bar2:SetWidth(bwidth)
bar2:SetHeight(bheight)

bar3:SetWidth(bwidth)
bar3:SetHeight(bheight)

bar4:SetWidth(bwidth)
bar4:SetHeight(bheight)

bar5:SetWidth(gdir)
bar5:SetHeight(wdir)

bar7:SetWidth(bwidth)
bar7:SetHeight(bheight)

-- Bars
MainMenuBar:ClearAllPoints()
MainMenuBar:EnableMouse(false)
BonusActionBarFrame:ClearAllPoints()
BonusActionBarFrame:EnableMouse(false)
UIPARENT_MANAGED_FRAME_POSITIONS["ShapeshiftBarFrame"]=nil
ShapeshiftBarFrame:SetAlpha(0)
ShapeshiftBarFrame:ClearAllPoints()
ShapeshiftBarFrame:EnableMouse(false)
PossessBarFrame:SetAlpha(0)
PetActionBarFrame:ClearAllPoints()

for i=1,NUM_SHAPESHIFT_SLOTS do
		_G["ShapeshiftButton"..i]:EnableMouse(false)
end

for i=1,10 do
	_G["PetActionButton"..i]:ClearAllPoints()
	_G["PetActionButton"..i]:SetHeight(bs)
	_G["PetActionButton"..i]:SetWidth(bs)
	_G["PetActionButton"..i]:SetFrameStrata("LOW")
	if i==1 then
	
		_G["PetActionButton"..i]:SetPoint("TOPLEFT",bar7,"TOPLEFT",0,0)
		
	elseif i==5 or i==9 then

		_G["PetActionButton"..i]:SetPoint("TOPLEFT",bar7,"TOPLEFT",0,-(i-1)/4*(bsp+bs))
	
	else
	
		_G["PetActionButton"..i]:SetPoint("LEFT",_G["PetActionButton"..i-1],"RIGHT",bsp,0)

	end
end

for i=1,NUM_ACTIONBAR_BUTTONS do
	local function setbars(f)
		f:ClearAllPoints()
		f:SetHeight(bs)
		f:SetWidth(bs)
		f:SetFrameStrata("LOW")
	end
	setbars(_G["ActionButton"..i])
	setbars(_G["BonusActionButton"..i])
	setbars(_G["MultiBarBottomLeftButton"..i])
	setbars(_G["MultiBarBottomRightButton"..i])
	setbars(_G["MultiBarRightButton"..i])
	setbars(_G["MultiBarLeftButton"..i])

	_G["ActionButton"..i]:SetParent(MainMenuBar)
	_G["BonusActionButton"..i]:SetFrameStrata("Medium")
	
	
	if i<5 then
		_G["ActionButton"..i]:SetAlpha(bar1_1alpha)
		_G["BonusActionButton"..i]:SetAlpha(bar1_1alpha)
	elseif i>4 and i<9 then 
		_G["ActionButton"..i]:SetAlpha(bar1_2alpha)
		_G["BonusActionButton"..i]:SetAlpha(bar1_2alpha)
	else
		_G["ActionButton"..i]:SetAlpha(bar1_3alpha)
		_G["BonusActionButton"..i]:SetAlpha(bar1_3alpha)
	end
	
	if i==1 then

		_G["ActionButton"..i]:SetPoint("BOTTOMLEFT",bar1_1,"BOTTOMLEFT",0,0)
		_G["BonusActionButton"..i]:SetPoint("BOTTOMLEFT",bar1_1,"BOTTOMLEFT",0,0)
		
		_G["MultiBarBottomLeftButton"..i]:SetPoint("TOPLEFT",bar2,"TOPLEFT",0,0)
		_G["MultiBarBottomRightButton"..i]:SetPoint("TOPLEFT",bar3,"TOPLEFT",0,0)
		_G["MultiBarRightButton"..i]:SetPoint("TOPLEFT",bar4,"TOPLEFT",0,0)
		_G["MultiBarLeftButton"..i]:SetPoint("TOPLEFT",bar5,"TOPLEFT",0,0)
	
	else
	
		if i==5 then 

			_G["ActionButton"..i]:SetPoint("BOTTOMLEFT",bar1_2,"BOTTOMLEFT",0,0)
			_G["BonusActionButton"..i]:SetPoint("BOTTOMLEFT",bar1_2,"BOTTOMLEFT",0,0)
			
		elseif i==9 then 

			_G["ActionButton"..i]:SetPoint("BOTTOMLEFT",bar1_3,"BOTTOMLEFT",0,0)
			_G["BonusActionButton"..i]:SetPoint("BOTTOMLEFT",bar1_3,"BOTTOMLEFT",0,0)
			
		else
	
			_G["ActionButton"..i]:SetPoint("LEFT",_G["ActionButton"..i-1],"RIGHT",bsp,0)
			_G["BonusActionButton"..i]:SetPoint("LEFT",_G["BonusActionButton"..i-1],"RIGHT",bsp,0)

		end


		if i==5 or i==9 then

			_G["MultiBarBottomLeftButton"..i]:SetPoint("TOPLEFT",bar2,"TOPLEFT",0,-(i-1)/4*(bsp+bs))
			_G["MultiBarBottomRightButton"..i]:SetPoint("TOPLEFT",bar3,"TOPLEFT",0,-(i-1)/4*(bsp+bs))
			_G["MultiBarRightButton"..i]:SetPoint("TOPLEFT",bar4,"TOPLEFT",0,-(i-1)/4*(bsp+bs))				
			
			
		else 					
			_G["MultiBarBottomLeftButton"..i]:SetPoint("LEFT",_G["MultiBarBottomLeftButton"..i-1],"RIGHT",bsp,0)
			_G["MultiBarBottomRightButton"..i]:SetPoint("LEFT",_G["MultiBarBottomRightButton"..i-1],"RIGHT",bsp,0)
			_G["MultiBarRightButton"..i]:SetPoint("LEFT",_G["MultiBarRightButton"..i-1],"RIGHT",bsp,0)				
		end			
		_G["MultiBarLeftButton"..i]:SetPoint("LEFT",_G["MultiBarLeftButton"..i-1],"RIGHT",bsp,0)
		
	end
	
end

local function hideactionbuttons(alpha)
	local f="ActionButton"
	for i=1,12 do
		_G[f..i]:SetAlpha(alpha)
	end
end

local function sh2(alpha)	for j=1,12 do _G["MultiBarBottomLeftButton"..j]:SetAlpha(alpha) end end
local function sh3(alpha) for j=1,12 do _G["MultiBarBottomRightButton"..j]:SetAlpha(alpha) end end
local function sh4(alpha) for j=1,12 do _G["MultiBarRightButton"..j]:SetAlpha(alpha) end end
local function sh5(alpha) for j=1,12 do _G["MultiBarLeftButton"..j]:SetAlpha(alpha) end end
local function sh7(alpha) for j=1,10 do _G["PetActionButton"..j]:SetAlpha(alpha) end end

bar2:EnableMouse(true)
bar2:SetScript("OnEnter",function(self) sh2(bar2alpha) end)
bar2:SetScript("OnLeave",function(self) sh2(fadedalpha) end)
for i=1,12 do
	_G["MultiBarBottomLeftButton"..i]:SetAlpha(fadedalpha)
	_G["MultiBarBottomLeftButton"..i]:HookScript("OnEnter",function(self) sh2(bar2alpha) end)
	_G["MultiBarBottomLeftButton"..i]:HookScript("OnLeave",function(self) sh2(fadedalpha) end)
end

bar3:EnableMouse(true)
bar3:SetScript("OnEnter",function(self) sh3(bar3alpha) end)
bar3:SetScript("OnLeave",function(self) sh3(fadedalpha) end)
for i=1,12 do
	_G["MultiBarBottomRightButton"..i]:SetAlpha(fadedalpha)
	_G["MultiBarBottomRightButton"..i]:HookScript("OnEnter",function(self) sh3(bar3alpha) end)
	_G["MultiBarBottomRightButton"..i]:HookScript("OnLeave",function(self) sh3(fadedalpha) end)
end

bar4:EnableMouse(true)
bar4:SetScript("OnEnter",function(self) sh4(bar4alpha) end)
bar4:SetScript("OnLeave",function(self) sh4(fadedalpha) end)
for i=1,12 do
	_G["MultiBarRightButton"..i]:SetAlpha(fadedalpha)
	_G["MultiBarRightButton"..i]:HookScript("OnEnter",function(self) sh4(bar4alpha) end)
	_G["MultiBarRightButton"..i]:HookScript("OnLeave",function(self) sh4(fadedalpha) end)
end

bar5:EnableMouse(true)
bar5:SetScript("OnEnter",function(self) sh5(bar5alpha) end)
bar5:SetScript("OnLeave",function(self) sh5(fadedalpha) end)
for i=1,12 do
	_G["MultiBarLeftButton"..i]:SetAlpha(fadedalpha)
	_G["MultiBarLeftButton"..i]:HookScript("OnEnter",function(self) sh5(bar5alpha) end)
	_G["MultiBarLeftButton"..i]:HookScript("OnLeave",function(self) sh5(fadedalpha) end)
end

bar7:EnableMouse(true)
bar7:SetScript("OnEnter",function(self) sh7(petbaralpha) end)
bar7:SetScript("OnLeave",function(self) sh7(fadedalpha) end)
for i=1,10 do
	_G["PetActionButton"..i]:SetAlpha(fadedalpha)
	_G["PetActionButton"..i]:HookScript("OnEnter",function(self) sh7(petbaralpha) end)
	_G["PetActionButton"..i]:HookScript("OnLeave",function(self) sh7(fadedalpha) end)
end

VehicleMenuBarActionButton1:ClearAllPoints()
VehicleMenuBarActionButton1:SetPoint("BOTTOMLEFT",VehicleMenuBarActionButtonFrame,80,0)
VehicleMenuBarHealthBar:SetParent(VehicleMenuBar)
VehicleMenuBarPowerBar:SetParent(VehicleMenuBar)

for _,texture in next,{
	MainMenuXPBarTexture0,
	MainMenuXPBarTexture1,
	MainMenuXPBarTexture2,
	MainMenuXPBarTexture3,
	MainMenuMaxLevelBar0,
	MainMenuMaxLevelBar1,
	MainMenuMaxLevelBar2,
	MainMenuMaxLevelBar3,
	MainMenuBarTexture0,
	MainMenuBarTexture1,
	MainMenuBarTexture2,
	MainMenuBarTexture3,
	MainMenuBarLeftEndCap,
	MainMenuBarRightEndCap,
	ReputationWatchBarTexture0,
	ReputationWatchBarTexture1,
	ReputationWatchBarTexture2,
	ReputationWatchBarTexture3,
	ReputationXPBarTexture0,
	ReputationXPBarTexture1,
	ReputationXPBarTexture2,
	ReputationXPBarTexture3,
	BonusActionBarTexture0,
	BonusActionBarTexture1,
	ShapeshiftBarLeft,
	ShapeshiftBarMiddle,
	ShapeshiftBarRight,
	PossessBackground1,
	PossessBackground2,
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	BonusActionBarTexture0,
	BonusActionBarTexture1,
} do
	texture:Hide()
end

for _,hide in next,{
	ShapeshiftBarLeft,
	ShapeshiftBarMiddle,
	ShapeshiftBarRight,
	PossessBarLeft,
	PossessBarRight,
	CharacterMicroButton,
	TalentMicroButton,
	CharacterMicroButton,
	SpellbookMicroButton,
	QuestLogMicroButton,
	SocialsMicroButton,
	MainMenuMicroButton,
	HelpMicroButton,
	LFGMicroButton,
	PVPMicroButton,
	--AchievementMicroButton,
	MainMenuBarBackpackButton,
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
	MainMenuBarPageNumber,
	MainMenuBarPerformanceBarFrame,
	ActionBarUpButton,
	ActionBarDownButton,
	KeyRingButton,
	MainMenuBarLeftEndCap,
	MainMenuBarRightEndCap,
	ReputationWatchBar,
	MainMenuExpBar,
	ExhaustionTick,
	LFDMicroButton,
	MainMenuBarArtFrame,
	VehicleMenuBarArtFrame,
	ReputationWatchStatusBar
} do
	hide:Hide()
	hide:SetAlpha(0)
	hide:SetWidth(0.001)
	if hide:IsShown() then
		hide:Hide()
	end
end

MainMenuExpBar:SetFrameStrata("BACKGROUND")
MainMenuBarExpText:SetAlpha(0)
ReputationWatchStatusBarText:SetAlpha(0)
