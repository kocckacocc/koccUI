-- credits to Blooblahguy for bStyle

local texture="Interface\\Buttons\\WHITE8x8"

local font={"Interface\\AddOns\\koccui\\koccmedia\\fonts\\visitor.ttf",14,"OUTLINE,MONOCHROME"}

local bd={
	bgFile=texture,
	edgeFile=texture,
	tile=true,
	tileSize=1,
	edgeSize=1,
	insets={
		left=1,
		right=1,
		top=1,
		bottom=1
	}
}

local function mainbars(self)
	local name=self:GetName()
	_G[name]:SetBackdrop(bd)
	_G[name]:SetBackdropColor(1,1,1,0)
	_G[name]:SetBackdropBorderColor(1,1,1)

	_G[name.."Icon"]:SetTexCoord(.08,.92,.08,.92)
	_G[name.."Icon"]:SetDrawLayer("ARTWORK")
	_G[name.."Icon"]:SetPoint("TOPLEFT",1,-1)
	_G[name.."Icon"]:SetPoint("BOTTOMRIGHT",-1,1)

	_G[name.."Flash"]:SetTexture("")
	_G[name]:SetNormalTexture("")
	_G[name]:SetCheckedTexture("")
	_G[name]:SetHighlightTexture("")
	_G[name]:SetPushedTexture("")
	_G[name.."Border"]:Hide()
	_G[name.."Name"]:Hide()
	_G[name.."Count"]:Hide()

	
	_G[name.."HotKey"]:ClearAllPoints()
	_G[name.."HotKey"]:SetPoint("TOPLEFT")
	_G[name.."HotKey"]:SetPoint("BOTTOMRIGHT")
	
	local dummy=function() end
	_G[name.."HotKey"].ClearAllPoints=dummy
	_G[name.."HotKey"].SetPoint=dummy
	
	_G[name.."HotKey"]:SetJustifyH("CENTER")
	_G[name.."HotKey"]:SetJustifyV("MIDDLE")
	_G[name.."HotKey"]:SetFont(unpack(font))
	
	--[[
	_G[name.."Count"]:ClearAllPoints()
	_G[name.."Count"]:SetPoint("TOPLEFT")
	_G[name.."Count"]:SetPoint("BOTTOMRIGHT")
	
	_G[name.."Count"]:SetJustifyH("RIGHT")
	_G[name.."Count"]:SetJustifyV("BOTTOM")
	_G[name.."Count"]:SetFont(unpack(font))
	]]	
	
	if hidehotkeys==1 then _G[name.."HotKey"]:Hide() end
	
end

local function otherbars(name,index)
	local button=name..index
	_G[button]:SetBackdrop(bd)
	_G[button]:SetBackdropColor(0,0,0,1)
	_G[button.."Icon"]:SetTexCoord(.08,.92,.08,.92)
	_G[button.."Icon"]:SetDrawLayer("ARTWORK")
	_G[button.."Icon"]:SetPoint("TOPLEFT",1,-1)
	_G[button.."Icon"]:SetPoint("BOTTOMRIGHT",-1,1)
	_G[button.."Flash"]:SetTexture("")
	_G[button]:SetNormalTexture("")
	_G[button]:SetCheckedTexture("")
	_G[button]:SetHighlightTexture("")
	_G[button]:SetPushedTexture("")
	_G[button.."Border"]:Hide()
end

local function hotkey(self)
local name=self:GetName()
	_G[name.."HotKey"]:Hide()
	_G[name]:HookScript("OnEnter",function() _G[name.."HotKey"]:Show() end)
	_G[name]:HookScript("OnLeave",function() _G[name.."HotKey"]:Hide() end)
end

local function stylepet()
	for i=1,NUM_PET_ACTION_SLOTS do
		otherbars("PetActionButton",i)
	end
end

hooksecurefunc("ActionButton_Update",mainbars)
hooksecurefunc("PetActionBar_Update",stylepet)

if hidehotkeys==1 then
	hooksecurefunc("ActionButton_UpdateHotkeys",hotkey)
end
