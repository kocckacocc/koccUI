-- credits to Freebaser for ikons

local debug=false

local myname,ns=...

bs=28
bsp=4

local p1x=256
local p1y=-160 -- bp[1][1].y
local p2y=0 -- bp[1][3].y
local m=bs+bsp

local p4x=m*12

local pos={
	[1]={x=p1x,y=p1y,r=false},
	[2]={x=p1x-m,y=p1y,r=false},
	[3]={x=p1x-2*m,y=p1y,r=false},
	[4]={x=p1x-3*m,y=p1y,r=false},
	
	[5]={x=p1x-3*m,y=p1y-bsp,r=true},
	[6]={x=p1x-2*m,y=p1y-bsp,r=true},
	[7]={x=p1x-m,y=p1y-bsp,r=true},
	[8]={x=p1x,y=p1y-bsp,r=true},
	
	[9]={x=p1x,y=p2y,r=true},
	[10]={x=p1x-m,y=p2y,r=true},
	[11]={x=p1x-2*m,y=p2y,r=true},
	[12]={x=p1x-3*m,y=p2y,r=true},
	
	[13]={x=-m*4,y=m*2,r=false},
	[14]={x=-m*5,y=m*2,r=false},
	[15]={x=-m*6,y=m*2,r=false},
	[16]={x=-m*7,y=m*2,r=false},
	
	[17]={x=-m*8,y=m*2,r=false},
	[18]={x=-m*9,y=m*2,r=false},
	[19]={x=-m*10,y=m*2,r=false},
	[20]={x=-m*11,y=m*2,r=false},
	
	[21]={x=0,y=m*2,r=false},
}

--[[

12|11|10|09

04|03|02|01
05|06|07|08

20|19|18|17|16|15|14|13....21

]]

ns.cfg={
	["WARLOCK"]={
		cds={
			["Howl of Terror"]={r=0.5,g=0,b=0,xpos=pos[11].x,ypos=pos[11].y,reverse=pos[11].r,i=true},
			["Shadowfury"]={r=0.5,g=0,b=0,xpos=pos[11].x,ypos=pos[11].y,reverse=pos[11].r,i=true},
			["Death Coil"]={r=0.5,g=0,b=0,xpos=pos[10].x,ypos=pos[10].y,reverse=pos[10].r,i=true},

			["Conflagrate"]={r=0.5,g=0,b=0,xpos=pos[3].x,ypos=pos[3].y,reverse=pos[3].r},
			["Haunt"]={r=0.5,g=0,b=0,xpos=pos[2].x,ypos=pos[2].y,reverse=pos[2].r,i=true},
			["Chaos Bolt"]={r=0.5,g=0,b=0,xpos=pos[1].x,ypos=pos[1].y,reverse=pos[1].r},

			["Demonic Circle: Teleport"]={r=0.5,g=0,b=0,xpos=pos[19].x,ypos=pos[19].y,reverse=pos[19].r,bottom=true},
			["Every Man for Himself"]={r=0.5,g=0,b=0,xpos=pos[18].x,ypos=pos[18].y,reverse=pos[18].r,bottom=true},
			["Sacrifice"]={r=0.5,g=0,b=0,xpos=pos[16].x,ypos=pos[16].y,reverse=pos[16].r,bottom=true,i=true},
			["Spell Lock"]={r=0.5,g=0,b=0,xpos=pos[16].x,ypos=pos[16].y,reverse=pos[16].r,bottom=true,i=true},
			["Devour Magic"]={r=0.5,g=0,b=0,xpos=pos[15].x,ypos=pos[15].y,reverse=pos[15].r,bottom=true,i=true},
		},
		debuffs={
			["Fear"]={r=1,g=1,b=1,xpos=pos[12].x,ypos=pos[12].y,reverse=pos[12].r},
			["Howl of Terror"]={r=1,g=1,b=1,xpos=pos[11].x,ypos=pos[11].y,reverse=pos[11].r},
			["Death Coil"]={r=1,g=1,b=1,xpos=pos[10].x,ypos=pos[10].y,reverse=pos[10].r},
			["Frostweave Net"]={r=1,g=1,b=1,xpos=pos[9].x,ypos=pos[9].y,reverse=pos[9].r},
			
			["Unstable Affliction"]={r=1,g=1,b=1,xpos=pos[4].x,ypos=pos[4].y,reverse=pos[4].r},
			["Immolate"]={r=1,g=1,b=1,xpos=pos[4].x,ypos=pos[4].y,reverse=pos[4].r},
			["Corruption"]={r=1,g=1,b=1,xpos=pos[3].x,ypos=pos[3].y,reverse=pos[3].r},
			["Haunt"]={r=1,g=1,b=1,xpos=pos[2].x,ypos=pos[2].y,reverse=pos[2].r},
			
			["Curse of Exhaustion"]={r=1,g=1,b=1,xpos=pos[7].x,ypos=pos[7].y,reverse=pos[7].r},
			["Curse of Tongues"]={r=1,g=1,b=1,xpos=pos[6].x,ypos=pos[6].y,reverse=pos[6].r},
			["Curse of the Elements"]={r=1,g=1,b=1,xpos=pos[5].x,ypos=pos[5].y,reverse=pos[5].r},
			
			["Spell Lock"]={r=1,g=1,b=1,xpos=pos[15].x,ypos=pos[15].y,reverse=pos[15].r,bottom=true},
			["Seduction"]={r=1,g=1,b=1,xpos=pos[15].x,ypos=pos[15].y,reverse=pos[15].r,bottom=true}
		},
		auras={
			["Backdraft"]={r=1,g=1,b=1,xpos=pos[2].x,ypos=pos[2].y,reverse=pos[2].r},
			--["Sacrifice"]={r=1,g=1,b=1,xpos=pos[16].x,ypos=pos[16].y,reverse=pos[16].r,bottom=true},
			
			["Backlash"]={r=1,g=1,b=1,xpos=0,ypos=0,reverse=true,big=true},
			["Shadow Trance"]={r=1,g=1,b=1,xpos=0,ypos=0,reverse=true,big=true},
		},
		items={
			["Frostweave Net"]={r=0.5,g=0,b=0,xpos=pos[9].x,ypos=pos[9].y,reverse=pos[9].r,i=true},
			["Fel Healthstone"]={r=0.5,g=0,b=0,xpos=pos[20].x,ypos=pos[20].y,reverse=pos[20].r,bottom=true},
		}
	},
	["DRUID"]={
		cds={
			["Starfall"]={r=0.5,g=0,b=0,xpos=pos[12].x,ypos=pos[12].y,reverse=pos[12].r,i=true},
			["Force of Nature"]={r=0.5,g=0,b=0,xpos=pos[11].x,ypos=pos[11].y,reverse=pos[11].r,i=true},
			
			["Swiftmend"]={r=0.5,g=0,b=0,xpos=pos[4].x,ypos=pos[4].y,reverse=pos[4].r,i=true},
			["Wild Growth"]={r=0.5,g=0,b=0,xpos=pos[3].x,ypos=pos[3].y,reverse=pos[3].r,i=true},
			["Tranquility"]={r=0.5,g=0,b=0,xpos=pos[2].x,ypos=pos[2].y,reverse=pos[2].r,i=true},

			["Typhoon"]={r=0.5,g=0,b=0,xpos=pos[1].x,ypos=pos[1].y,reverse=pos[1].r,i=true},
			
			["Barkskin"]={r=0.5,g=0,b=0,xpos=pos[16].x,ypos=pos[16].y,reverse=pos[16].r,i=true,bottom=true},
			["Innervate"]={r=0.5,g=0,b=0,xpos=pos[15].x,ypos=pos[15].y,reverse=pos[15].r,i=true,bottom=true},
			
			["Rebirth"]={r=0.5,g=0,b=0,xpos=pos[21].x,ypos=pos[21].y,reverse=pos[21].r,i=true,bottom=true},
		},
		debuffs={
			["Insect Swarm"]={r=1,g=1,b=1,xpos=pos[6].x,ypos=pos[6].y,reverse=pos[6].r},
			["Moonfire"]={r=1,g=1,b=1,xpos=pos[5].x,ypos=pos[5].y,reverse=pos[5].r},
			
			["Faerie Fire"]={r=1,g=1,b=1,xpos=pos[2].x,ypos=pos[2].y,reverse=pos[2].r},
			["Typhoon"]={r=1,g=1,b=1,xpos=pos[1].x,ypos=pos[1].y,reverse=pos[1].r},
			["Cyclone"]={r=1,g=1,b=1,xpos=pos[7].x,ypos=pos[7].y,reverse=pos[7].r},
		},
		auras={
			["Wild Growth"]={r=1,g=1,b=1,xpos=pos[3].x,ypos=pos[3].y,reverse=pos[3].r},
			["Tranquility"]={r=1,g=1,b=1,xpos=pos[2].x,ypos=pos[2].y,reverse=pos[2].r},
			
			["Eclipse (Solar)"]={r=1,g=1,b=1,xpos=pos[3].x,ypos=pos[3].y,reverse=pos[3].r},
			["Eclipse (Lunar)"]={r=1,g=1,b=1,xpos=pos[4].x,ypos=pos[4].y,reverse=pos[4].r},
			
			["Barkskin"]={r=1,g=1,b=1,xpos=pos[16].x,ypos=pos[16].y,reverse=pos[16].r,bottom=true},
			["Innervate"]={r=1,g=1,b=1,xpos=pos[15].x,ypos=pos[15].y,reverse=pos[15].r,bottom=true},
			
			--[""]={r=1,g=1,b=1,xpos=0,ypos=0,reverse=true,big=true},
		},
		items={
			--[""]={r=0.5,g=0,b=0,xpos=pos[9].x,ypos=pos[9].y,reverse=pos[9].r,i=true},
		}
	},
}

local f=CreateFrame("frame")
f:SetScript("OnEvent",function(self,event,...) 
	if ns[event] then 
		return ns[event](ns,event,...) 
	end 
end)

function ns:RegisterEvent(...) 
	for i=1,select("#",...) do 
		f:RegisterEvent((select(i,...))) 
	end 
end

function ns:UnregisterEvent(...) 
	for i=1,select("#",...) 
		do f:UnregisterEvent((select(i,...))) 
	end 
end

ns.RegisterEvents,ns.UnregisterEvents=ns.RegisterEvent,ns.UnregisterEvent

ns.icons={}
local db,cds,auras,debuffs,items
local CD,AURA,DEBUFF,ITEM="CD","AURA","DEBUFF","ITEM"

local function findIcon(name,type)
	for i=#(ns.icons),1,-1 do
		if ns.icons[i].name==name and ns.icons[i].type==type then
			local frame=ns.icons[i]
			return frame
		end
	end
end

local function UnregIcon(frame,name,type)
	if frame then
		frame:Hide()
		frame.update=true
	elseif name then
		local f=findIcon(name,type)
		return UnregIcon(f)
	end
end

local fmod=math.fmod

local function OnUpdate()
	return function(self,elapsed)
		local duration=self.duration - elapsed
		if duration<=0 then
			UnregIcon(self)
			return
		end
		self.duration=duration
		local sb=self.sb
		if self.reverse==true then
			local percent=duration/self.max
			if self.big then scale=1.5 else scale=1 end
			sb:SetPoint("BOTTOMLEFT",0,((bs+bsp)*2)*(1-percent)*scale)
		end
		sb:SetValue(duration)

		--[[
		local min,sec=floor(duration/60),fmod(duration,60)
		if(min>0) then
			self.timer:SetFormattedText("%d:%02d",min,sec)
		elseif(sec<10) then
			self.timer:SetFormattedText("%.1f",sec)
		else
			self.timer:SetFormattedText("%d",sec)
		end
		]]
		
	end
end

local function CreateIcon(name,obj,type)

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
	
	local frame=CreateFrame("Frame",name.."ikon",UIParent)
	if obj.big then
		frame:SetPoint("TOP",UIParent,"TOP",obj.xpos,obj.ypos)
	elseif obj.reverse then
		frame:SetPoint("TOPRIGHT",UIParent,"CENTER",obj.xpos,obj.ypos)
	elseif obj.bottom then
		frame:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",obj.xpos,obj.ypos)
	else
		frame:SetPoint("BOTTOMRIGHT",UIParent,"CENTER",obj.xpos,obj.ypos)
	end
	
	if obj.big then scale=1.5 else scale=1 end

	frame:SetSize(bs*scale,(bs+bsp)*3*scale)
	frame:Hide()

	if debug then
		local b=CreateFrame("Frame",nil,frame)
		b:SetAllPoints()
		b:SetBackdrop({bgFile=texture})
		b:SetBackdropColor(0,0,0,0.5)
	end
	
	local h=CreateFrame("Frame",nil,frame)
	if obj.reverse then
		h:SetPoint("TOPLEFT")
	else
		h:SetPoint("BOTTOMLEFT")
	end
		
	h:SetSize(bs*scale,bs*scale)
	h:SetBackdrop(backdrop)
	h:SetBackdropColor(0,0,0,0)
	h:SetBackdropBorderColor(1,1,1,0.5)

	local icon=h:CreateTexture(nil,"OVERLAY")
	icon:SetTexCoord(.07,.93,.07,.93)
	icon:SetPoint("TOPLEFT",1,-1)
	icon:SetPoint("BOTTOMRIGHT",-1,1)

	local sb=CreateFrame"StatusBar"
	sb:SetParent(frame)

	if obj.i then	
		sb:SetFrameLevel(2)
		sb:SetAlpha(0.5)	
	else 
		sb:SetFrameLevel(1)
		sb:SetAlpha(0.5)
	end
	
	sb:SetStatusBarTexture(texture)
	sb:SetOrientation("VERTICAL")
	if obj.reverse then	
		sb:SetPoint("BOTTOMLEFT")
	else
		sb:SetPoint("TOPLEFT")
	end
		
	sb:SetSize(bs*scale,(bs+bsp)*2*scale)

	--[[
	local count=frame:CreateFontString(nil,"OVERLAY")
	count:SetFont(unpack(smallfont))
	count:SetPoint("BOTTOMRIGHT",icon,"BOTTOMRIGHT",-1,1)

	local timer=sb:CreateFontString(nil,"OVERLAY")
	timer:SetFont(unpack(smallfont))
	timer:SetPoint("CENTER",icon,"CENTER",0,0)
	]]

	frame:SetScript("OnUpdate",OnUpdate())
	frame.icon=icon
	frame.sb=sb
	frame.name=tostring(name)
	frame.type=type

	frame.r=obj.r
	frame.g=obj.g
	frame.b=obj.b

	frame.reverse=obj.reverse
	frame.big=obj.big

	table.insert(ns.icons,frame)
end

local function RegIcon(name,startTime,seconds,dura,icon,count,type)
	local frame=findIcon(name,type)
	if frame==nil then return end
	--[[
	if count and count>0 then
		frame.count:SetText(count)
	end
	]]
	if frame.update==false then
		if frame.duration and seconds<frame.duration+0.5 then return end
	end
	frame.update=false
	local duration=startTime-GetTime()+seconds
	frame.duration=duration
	frame.max=dura
	local sb=frame.sb
	sb:SetStatusBarColor(frame.r,frame.g,frame.b)
	sb:SetMinMaxValues(0,dura)
	sb:SetValue(duration)
	frame.icon:SetTexture(icon)
	frame:Show()
end

ns:RegisterEvent("SPELL_UPDATE_COOLDOWN")
function ns:SPELL_UPDATE_COOLDOWN()
	for cd,obj in pairs(cds) do
		local startTime,duration,enabled=GetSpellCooldown(cd)
		if(enabled==1 and duration>1.5) then
				RegIcon(cd,startTime,duration,duration,GetSpellTexture(cd),nil,CD)
		end
	end
end

ns:RegisterEvent("PLAYER_TARGET_CHANGED")
ns:RegisterEvent("UNIT_AURA")
function ns:UNIT_AURA()
	for aura,obj in pairs(auras) do 
		local name ,_,icon,count,_,duration,expires,caster,_,_,
			spellID=UnitAura("player",aura,nil,"HELPFUL")
		if name then
			if(caster=="player") then
				local startTime=GetTime()
				local secs=-(GetTime()-expires)
				RegIcon(aura,startTime,secs,duration,icon,count,AURA)
			end
		else
			UnregIcon(nil,aura,AURA)
		end
	end
	for debuff,obj in pairs(debuffs) do 
		local name ,_,icon,count,_,duration,expires,caster,_,_,
			spellID=UnitAura("target",debuff,nil,"HARMFUL")
		if name then
			if((not obj.player) or (obj.player and caster=="player")) then
				local startTime=GetTime()
				local secs=-(GetTime()-expires)
				RegIcon(debuff,startTime,secs,duration,icon,count,DEBUFF)
			end
		else
			UnregIcon(nil,debuff,DEBUFF)
		end
	end
end
ns.PLAYER_TARGET_CHANGED=ns.UNIT_AURA

ns:RegisterEvent("BAG_UPDATE_COOLDOWN")
function ns:BAG_UPDATE_COOLDOWN()
	for item,obj in pairs(items) do
		local startTime,duration,enabled=GetItemCooldown(item)
		if(enabled==1) then
			RegIcon(tostring(item),startTime,duration,duration,select(10,GetItemInfo(item)),nil,ITEM)
		end
	end
end

local function GetIcons()
	for cd,obj in pairs(cds) do
		CreateIcon(cd,obj,CD)
	end
	for aura,obj in pairs(auras) do
		CreateIcon(aura,obj,AURA)
	end
	for debuff,obj in pairs(debuffs) do
		CreateIcon(debuff,obj,DEBUFF)
	end
	for item,obj in pairs(items) do
		CreateIcon(item,obj,ITEM)
	end
end

ns:RegisterEvent("PLAYER_LOGIN")
function ns:PLAYER_LOGIN()
	local _,class=UnitClass("player")
	db=ns.cfg[class] or nil
	if db then
		cds=db.cds or {}
		auras=db.auras or {}
		debuffs=db.debuffs or {}
		items=db.items or {}
		GetIcons()
	else
		ns:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		ns:UnregisterEvent("UNIT_AURA")
		ns:UnregisterEvent("PLAYER_TARGET_CHANGED")
		ns:UnregisterEvent("BAG_UPDATE_COOLDOWN")
	end
	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN=nil
end
