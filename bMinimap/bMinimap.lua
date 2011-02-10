-- credits to Blooblahguy for bMinimap

bs=28
bsp=4

mmposition={a="BOTTOM",x=0,y=0}
mmsize=(bsp+bs)*3-bsp
mmalpha=0.5

borders=true
whiteborder=false
color={r=0.6,g=0.6,b=0.6}
bordersize=1

qparent=Minimap
qanchor="BOTTOMRIGHT"
qposition_x=0
qposition_y=-80
qheight=500

local texture="Interface\\Buttons\\WHITE8x8"
local backdrop={
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

Minimap:SetMaskTexture(texture)

Minimap:SetWidth(mmsize)
Minimap:SetHeight(mmsize)

Minimap:SetFrameStrata("BACKGROUND")
Minimap:ClearAllPoints()
Minimap:SetPoint(mmposition.a,UIParent,mmposition.x,mmposition.y)

Minimap:SetBackdrop(backdrop)
Minimap:SetBackdropColor(0,0,0,0)
Minimap:SetBackdropBorderColor(1,1,1)
Minimap:SetAlpha(mmalpha)

MinimapBorder:Hide()
MinimapBorderTop:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MiniMapVoiceChatFrame:Hide()
GameTimeFrame:Hide()
MinimapZoneTextButton:Hide()
MiniMapTracking:Hide()
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetAlpha(0)
MiniMapMailBorder:Hide()
MinimapNorthTag:SetAlpha(0)

WatchFrame:ClearAllPoints()
WatchFrame.ClearAllPoints=function() end
WatchFrame:SetPoint(qanchor,qparent,qanchor,qposition_x,qposition_y)
WatchFrame.SetPoint=function() end
WatchFrame:SetClampedToScreen(true)
WatchFrame:SetHeight(qheight)

MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT",Minimap,3,0)
MiniMapBattlefieldFrame:SetFrameLevel(3)
MiniMapBattlefieldBorder:Hide()
MiniMapWorldMapButton:Hide()

MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:SetPoint("TOPLEFT",Minimap,"TOPLEFT",0,0)
function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:SetPoint("BOTTOMLEFT",Minimap,"BOTTOMLEFT",2,1)
	LFDSearchStatus:ClearAllPoints()
	LFDSearchStatus:SetPoint("BOTTOMLEFT",MiniMapLFGFrame,"BOTTOMLEFT")
	LFDSearchStatus:SetClampedToScreen(true)
end
MiniMapLFGFrameBorder:SetAlpha(0)
DropDownList1:SetClampedToScreen(true)
hooksecurefunc("MiniMapLFG_UpdateIsShown",UpdateLFG)

LoadAddOn("Blizzard_TimeManager")

local clockFrame,clockTime=TimeManagerClockButton:GetRegions()
clockFrame:Hide()
clockTime:Hide()

Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel",function(self,delta)
	if delta>0 then
		Minimap_ZoomIn()
	else
		Minimap_ZoomOut() 
	end
end)

Minimap:SetScript("OnMouseUp",function(self,button)
    if (button=="RightButton") then
        ToggleDropDownMenu(1,nil,MiniMapTrackingDropDown,self,-(Minimap:GetWidth()*0.7),-3)
    elseif (button=="MiddleButton") then
        ToggleCalendar()
    else
        Minimap_OnClick(self)
    end
end)

function GetMinimapShape() return "SQUARE" end