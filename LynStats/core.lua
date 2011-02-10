-- Credits to Lyn for LYNSTATS

local addon=CreateFrame("Button","LynStats",UIParent)

local frame_anchor="TOPLEFT"
local frame_parent="UIParent"
local pos_x=3
local pos_y=-3

local text_anchor="TOPLEFT"
local font="Interface\\AddOns\\!koccmedia\\fonts\\calibri.ttf"
local size=18
local addonlist=30
local classcolors=true
local shadow=false
local outline=false
local time24=true

local tip_anchor="TOPLEFT"
local tip_x=0
local tip_y=-30

local color,mail,hasmail,ticktack,lag,fps,ep,xp_cur,xp_max,text,blizz,memory,entry,i,nr,xp_rest,ep,before,after,hours,minutes

if classcolors==true then
	color=RAID_CLASS_COLORS[select(2,UnitClass("player"))]
else
	color={r=0,g=0.8,b=1}
end

local memformat=function(number)
	if number>1024 then
		return string.format("%.2f mb",(number/1024))
	else
		return string.format("%.1f kb",floor(number))
	end
end

local addoncompare=function(a,b)
	return a.memory>b.memory
end

function addon:new()
	text=self:CreateFontString(nil,"OVERLAY")
	if outline==true then
		text:SetFont(font,size,"OUTLINE")
	else
		text:SetFont(font,size,nil)
	end
	if shadow==true then
		text:SetShadowOffset(1,-1)
		text:SetShadowColor(0,0,0)
	end
	text:SetPoint(text_anchor,self)
	text:SetTextColor(color.r,color.g,color.b)

	self:SetPoint(frame_anchor,frame_parent,frame_anchor,pos_x,pos_y)
	self:SetWidth(50)
	self:SetHeight(13)
	
	self:SetScript("OnUpdate",self.update)
	self:SetScript("OnEnter",self.enter)
	self:SetScript("OnLeave",function() GameTooltip:Hide() end)
end

local last=0
function addon:update(elapsed)
	last=last+elapsed

	if last>1 then	

		if time24==true then
			ticktack=date("%H:%M")
		else
			ticktack=date("%I:%M")
		end
		ticktack="|c00ffffff"..ticktack.."|r"
		
		hasmail=(HasNewMail() or 0);
		if hasmail>0 then
			mail=" | |c00ffffffnyúmél|r"
		else
			mail=""
		end
		
		fps=GetFramerate()
		fps="|c00ffffff"..floor(fps).."|r | "
		
		lag=select(3,GetNetStats())
		lag="|c00ffffff"..lag.."|r | "

		xp_cur=UnitXP("player")
		xp_max=UnitXPMax("player")
		xp_rest=GetXPExhaustion("player") or nil
		if UnitLevel("player") < MAX_PLAYER_LEVEL then
			ep="|c00ffffff"..floor(xp_max - xp_cur).."|r | |c00ffffff"..floor((xp_cur/xp_max)*100).."%|r | "
			if xp_rest ~= nil then	
				ep=ep.."|c0000ff11"..floor((xp_rest/xp_max)*100).."%|r | "
			else
				ep=ep
			end
		else
			ep=""
		end

		last=0

		text:SetText(fps..lag..ep..ticktack..mail)
		self:SetWidth(text:GetStringWidth())
	end
end

function addon:enter()
	GameTooltip:SetOwner(self,"ANCHOR_NONE")
	GameTooltip:SetPoint(tip_anchor,UIParent,tip_anchor,tip_x,tip_y)
	blizz=collectgarbage("count")
	addons={}
	total=0
	nr=0
	UpdateAddOnMemoryUsage()
	GameTooltip:AddDoubleLine(select(3,GetNetStats()).." ms",floor(GetFramerate()).." fps",color.r,color.g,color.b,color.r,color.g,color.b)
	GameTooltip:AddLine(" ")
	for i=1,GetNumAddOns(),1 do
		if (GetAddOnMemoryUsage(i) > 0 ) then
			memory=GetAddOnMemoryUsage(i)
			entry={name=GetAddOnInfo(i),memory=memory}
			table.insert(addons,entry)
			total=total+memory
		end
	end
	table.sort(addons,addoncompare)
	for _,entry in pairs(addons) do
		if nr<addonlist then
			GameTooltip:AddDoubleLine(entry.name,memformat(entry.memory),1,1,1,1,1,1)
			nr=nr+1
		end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("Total",memformat(total),color.r,color.g,color.b,color.r,color.g,color.b)
	GameTooltip:AddDoubleLine("Total incl. Blizzard",memformat(blizz),color.r,color.g,color.b,color.r,color.g,color.b)
	GameTooltip:Show()
end


addon:new()