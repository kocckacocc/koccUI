-- credits to Blooblahguy for bChat

chfont={"Interface\\AddOns\\!koccmedia\\fonts\\calibri.ttf",12}

chwidth=(bs+bsp)*8
chheight=(bs+bsp)*8
chpoint="BOTTOMLEFT"
chposx=0
chposy=1

ebwidth=(bs+bsp)*12
ebheight=bs
ebpoint="CENTER"
ebanchor=UIParent
ebxpos=0
ebypos=0

local debug=false

local texture="Interface\\Buttons\\WHITE8x8"

Officer=1
Raid=1
Guild=1
Party=1
Channel=1
Battleground=1
Whisper=1

CHAT_FONT_HEIGHTS={8,10,11,12,13,14,15,16,17,18,19,20}


ChatTypeInfo["CHANNEL"].sticky=Channel
ChatTypeInfo["GUILD"].sticky=Guild
ChatTypeInfo["OFFICER"].sticky=Officer
ChatTypeInfo["PARTY"].sticky=Party
ChatTypeInfo["RAID"].sticky=Raid
ChatTypeInfo["BATTLEGROUND"].sticky=Battleground
ChatTypeInfo["BATTLEGROUND_LEADER"].sticky=Battleground
ChatTypeInfo["WHISPER"].sticky=Whisper

ChatFrameMenuButton.Show=ChatFrameMenuButton.Hide 
ChatFrameMenuButton:Hide()
FriendsMicroButton.Show=FriendsMicroButton.Hide 
FriendsMicroButton:Hide()
BNToastFrame:SetClampedToScreen(true)

CHAT_FRAME_FADE_OUT_TIME=0
CHAT_TAB_HIDE_DELAY=0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA=1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA=0
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA=1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA=0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA=1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA=0

local gsub=_G.string.gsub
local newAddMsg={}
_G.CHAT_WHISPER_INFORM_GET="T %s:\32"
_G.CHAT_WHISPER_GET="F %s:\32"
_G.CHAT_YELL_GET="%s:\32"
_G.CHAT_SAY_GET="%s:\32"
_G.CHAT_BATTLEGROUND_GET="|Hchannel:Battleground|hBG |h %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET="|Hchannel:Battleground|hBG |h %s:\32"
_G.CHAT_GUILD_GET="|Hchannel:Guild|hG|h %s:\32"
_G.CHAT_PARTY_GET="|Hchannel:Party|hP|h %s:\32"
_G.CHAT_PARTY_LEADER_GET="|Hchannel:party|hP |h %s:\32"
_G.CHAT_PARTY_GUIDE_GET="|Hchannel:PARTY|hP |h %s:\32"
_G.CHAT_OFFICER_GET="|Hchannel:o|hO |h %s:\32"
_G.CHAT_RAID_GET="|Hchannel:raid|hR |h %s:\32"
_G.CHAT_RAID_LEADER_GET="[|Hchannel:raid|hL|h] %s:\32"
_G.CHAT_RAID_WARNING_GET="[RW] %s:\32"
local function AddMessage(frame,text,...)
	text=gsub(text,"|Hplayer:([^%|]+)|h%[([^%]]+)%]|h","|Hplayer:%1|h%2|h")
	text=gsub(text,"<Away>","")
	text=gsub(text,"<Busy>","")
	text=gsub(text,"%[%d+%. General.-%]","G ")
	text=gsub(text,"%[%d+%. Trade.-%]","T ")
	text=gsub(text,"%[%d+%. WorldDefense%]","D ")
	text=gsub(text,"%[%d+%. LocalDefense.-%]","D ")
	text=gsub(text,"%[%d+%. LookingForGroup%]","L ")
	text=gsub(text,"%[%d+%. GuildRecruitment.-%]","R ")
	text=gsub(text,"Joined Channel:","+")
	text=gsub(text,"Left Channel:","- ")
	text=gsub(text,"Changed Channel:",">")
	text=gsub(text,"%[(%d0?)%. .-%]","%1 ")
	return newAddMsg[frame:GetName()](frame,text,...)
end

for i=1,NUM_CHAT_WINDOWS do
	local editbox=_G["ChatFrame"..i.."EditBox"]
	local tex=({_G["ChatFrame"..i.."EditBox"]:GetRegions()})
	local cf=_G["ChatFrame"..i]
	local f=_G["ChatFrame"..i.."ButtonFrame"]
	local resize=_G["ChatFrame"..i.."ResizeButton"]
	f.Show=f.Hide
	f:Hide()
	editbox:SetAltArrowKeyMode(false)
	editbox:ClearAllPoints()

	editbox:SetPoint(ebpoint,ebanchor,ebpoint,ebxpos,ebypos)
	editbox:SetWidth(ebwidth)
	editbox:SetHeight(ebheight)

	editbox:SetShadowOffset(0,0)
	editbox:SetBackdrop({
		bgFile=texture,edgeFile=texture,edgeSize=2,insets={
			top=2,left=2,bottom=2,right=2
		}
	})
	editbox:SetBackdropColor(0,0,0,.8)
	editbox:SetBackdropBorderColor(0,0,0,1)
	editbox:SetFont(chfont[1],14)

	tex[6]:SetAlpha(0)
	tex[7]:SetAlpha(0)
	tex[8]:SetAlpha(0)
	tex[9]:SetAlpha(0)
	tex[10]:SetAlpha(0)
	tex[11]:SetAlpha(0)
	cf:SetMinResize(0,0)
	cf:SetMaxResize(0,0)
	cf:SetFading(false)
	cf:SetClampRectInsets(0,0,0,0)
	cf:SetFrameStrata("LOW")
	_G["ChatFrame"..i.."TabLeft"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabMiddle"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabRight"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabSelectedMiddle"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabSelectedRight"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabSelectedLeft"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabHighlightLeft"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabHighlightRight"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabHighlightMiddle"]:SetTexture(nil)
	resize:SetPoint("BOTTOMRIGHT",cf,"BOTTOMRIGHT",9,-5)
	resize:SetScale(1)
	resize:SetAlpha(1)
	for g=1,#CHAT_FRAME_TEXTURES do
		_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[g]]:SetTexture(nil)
	end
	if i ~= 2 then
		local f=_G[format("%s%d","ChatFrame",i)]
		newAddMsg[format("%s%d","ChatFrame",i)]=f.AddMessage
		f.AddMessage=AddMessage
	end

	if debug then
		cf:SetBackdrop({bgFile=texture})
		cf:SetBackdropColor(0,0,0,0.5)
	end

end

local EventFrame=CreateFrame("Frame");
EventFrame:RegisterEvent("ADDON_LOADED");
local function EventHandler(self,event,...)

	local f=ChatFrame1
	
	f:SetFont(unpack(chfont))
	
	f:ClearAllPoints()
	f:SetWidth(chwidth)
	f:SetHeight(chheight)
	f:SetPoint(chpoint,chposx,chposy)
	f:SetUserPlaced(nil)
	
	local dummy=function() end
	f.ClearAllPoints=dummy
	f.SetPoint=dummy

end
EventFrame:SetScript("OnEvent",EventHandler);
