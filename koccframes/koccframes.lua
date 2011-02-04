-- credits to P3lim for OUF P3lim

local debug=false

if globaldebug then debug=true end

local oUF=oUFembed
oUFembed=nil

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

local localized,class=UnitClass('player')

fw=(bs+bsp)*4
fh=bs
ph=fh/7

if debug then
	local debugback=CreateFrame("Frame",nil)
	debugback:SetPoint("TOPLEFT",sw/4,-sh/4)
	debugback:SetPoint("BOTTOMRIGHT",-sw/4,sh/4)
	debugback:SetBackdrop({bgFile=texture})
	debugback:SetBackdropColor(0,0,0,0.5)
	local debug=debugback:CreateFontString(nil,"OVERLAY")
	debug:SetPoint("CENTER")
	debug:SetFont(unpack(smallfont))
	debug:SetText()
end

local l=CreateFrame("Frame",nil)
l:SetPoint("BOTTOM",UIParent,"CENTER",0,-sh/4)
l:SetSize(1,bs*2+bsp)
l:SetBackdrop({bgFile=texture})
l:SetBackdropColor(1,1,1,0.5)

local function ShortenValue(value)
	if(value>=1e6) then
		return ("%.2fm"):format(value/1e6):gsub("%.?0+([km])$","%1")
	elseif(value>=1e3) then
		return ("%.1fk"):format(value/1e3):gsub("%.?0+([km])$","%1")
	else
		return value
	end
end

local utf8sub=function(string,i,dots)
	local bytes=string:len()
	if (bytes<=i) then
		return string
	else
		local len,pos=0,1
		while(pos<=bytes) do
			len=len+1
			local c=string:byte(pos)
			if (c>0 and c<=127) then
				pos=pos+1
			elseif (c>=192 and c<=223) then
				pos=pos+2
			elseif (c>=224 and c<=239) then
				pos=pos + 3
			elseif (c>=240 and c<=247) then
				pos=pos+4
			end
			if (len==i) then break end
		end

		if (len==i and pos<=bytes) then
			return string:sub(1,pos-1)..(dots and "." or "")
		else
			return string
		end
	end
end

oUF.Tags["kocc:health"]=function(unit)
	local min,max=UnitHealth(unit),UnitHealthMax(unit)
	local status=not UnitIsConnected(unit) and "DC" or UnitIsGhost(unit) and "GH" or UnitIsDead(unit) and "Rip"
	if(status) then
		return "|cff808080"..status.."|r"
	else
		return ShortenValue(min)
	end
end

oUF.Tags["kocc:power"]=function(unit)
	local power=UnitPower(unit)
	if(power>0 and not UnitIsDeadOrGhost(unit)) then
		local _,type=UnitPowerType(unit)
		local colors=_COLORS.power
		return ("%s%s|r"):format(Hex(colors[type] or colors["RUNES"]),ShortenValue(power))
	else
		return "|cff808080N/A|r"
	end
end

oUF.TagEvents["kocc:name"]="UNIT_NAME_UPDATE UNIT_REACTION UNIT_FACTION"
oUF.Tags["kocc:name"]=function(unit)
	local reaction=UnitReaction(unit,"player")

	local r,g,b=1,1,1
	if((UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) or not UnitIsConnected(unit)) then
		r,g,b=3/5,3/5,3/5
	elseif(not UnitIsPlayer(unit) and reaction) then
		r,g,b=unpack(_COLORS.reaction[reaction])
	elseif(UnitFactionGroup(unit) and UnitIsEnemy(unit,"player") and UnitIsPVP(unit)) then
		r,g,b=1,0,0
	end

	return ("%s%s|r"):format(Hex(r,g,b),utf8sub(UnitName(unit),12,true))
end

oUF.Tags["kocc:shortname"]=function(u)
	local name=UnitName(u)
	return utf8sub(name,3,false)
end

local function SpawnMenu(self)
	ToggleDropDownMenu(1,nil,_G[string.gsub(self.unit,"^.",string.upper).."FrameDropDown"],"cursor")
end

local function PostCreateAura(element,button)
	button:SetBackdrop(backdrop)
	button:SetBackdropColor(0,0,0,0)
	button:SetBackdropBorderColor(1,1,1,0.5)
	button.cd:SetReverse()
	button.icon:SetTexCoord(0.08,0.92,0.08,0.92)
	button.icon:SetDrawLayer("ARTWORK")
	button.icon:SetPoint("TOPLEFT",1,-1)
	button.icon:SetPoint("BOTTOMRIGHT",-1,1)
	button.count:SetFont(unpack(smallfont))
end

local function PostUpdateDebuff(element,unit,button,index)
	if button.debuff then
		local _,_,_,_,type=UnitAura(unit,index,button.filter)
		local color=DebuffTypeColor[type] or DebuffTypeColor.none
		button:SetBackdropBorderColor(color.r*3/5,color.g*3/5,color.b*3/5)
		button.icon:SetDesaturated(false)
	else
		button:SetBackdropBorderColor(1,1,1,0.5)
		button.icon:SetDesaturated(true)
	end
end

local function PostUpdateHealth(element,unit,min,max)
	element.hb:SetMinMaxValues(0,max)
	element.hb:SetValue(UnitIsDeadOrGhost(unit) and 0 or max-min)
	element.hb:SetPoint("TOPLEFT",fw/max*min,0)
	if unit == "player" then 
		fact=1-min/max
		ss=bs*5*fact
		element.skull:SetAlpha(fact) 
		element.skull:SetSize(ss,ss)		
	end
end

local function PostUpdateHealthSmall(element,unit,min,max)
	element.hb:SetMinMaxValues(0,max)
	if UnitIsDeadOrGhost(unit) then 
		element.hb:SetValue(max)
		element.hb:SetStatusBarColor(0.8,0,0,0.5)
	elseif not UnitIsConnected(unit) then
		element.hb:SetValue(max)
		element.hb:SetStatusBarColor(1,1,1,0.5)
	else
		element.hb:SetValue(max-min)
		element.hb:SetStatusBarColor(1,1,1)
	end
end

local function PostUpdatePower(element,unit,min,max)
	element:GetParent().Health.hb:SetHeight(max~=0 and fh-ph or fh)
	element.pb:SetMinMaxValues(0,max)
	element.pb:SetValue(max-min)
	element.pb:SetPoint("TOPLEFT",fw/max*min,-(fh-ph))
end

local function createAuraWatch(self,unit)
		local auras=CreateFrame("Frame",nil,self)
		auras:SetAllPoints(self)
		auras:SetFrameStrata("HIGH")
		
		local spellIDs={}
		
		if class=="DRUID" then
			spellIDs={
				774, -- rejuvenation
				33763, -- lifebloom
				1126, -- mark of the wild
				48470, -- gift
				48438, -- wild growth
			}
		else
			spellIDs={
			}
		end
		
		auras.presentAlpha=1
		auras.missingAlpha=0
		auras.customIcons=true

		auras.icons={}
		for i,sid in pairs(spellIDs) do
			local icon=CreateFrame("Frame",nil,auras)
			icon.spellID=sid
			local cd=CreateFrame("Cooldown",nil,icon)
			cd:SetAllPoints(icon)
			cd:SetReverse()
			icon.cd=cd

			local tex=icon:CreateTexture(nil,"BACKGROUND")
			tex:SetAllPoints(icon)
			tex:SetTexture(texture)			
			if i>5 then
				icon.anyUnit=true
				icon:SetWidth(bs/2)
				icon:SetHeight(bs/2)
				icon:SetPoint("CENTER",0,0)
				tex:SetVertexColor(200/255,100/255,200/255)
			else
				icon:SetWidth(bs/2.5)
				icon:SetHeight(bs/2.5)
				if i==1 then
					icon:SetPoint("TOPLEFT",1,-1)
					tex:SetVertexColor(150/255,50/255,150/255)
				elseif i==2 then
					icon:SetPoint("TOPRIGHT",-1,-1)
					tex:SetVertexColor(50/255,170/255,30/255)
					local count=icon:CreateFontString(nil,"OVERLAY")
					count:SetFont(unpack(smallfont))
					count:SetPoint("CENTER",0,1)
					icon.count=count
				elseif i==3 or i==4 then 
					icon:SetPoint("BOTTOMRIGHT",-1,1)
					tex:SetVertexColor(160/255,60/255,160/255)
					--[[local count = icon:CreateFontString(nil,"OVERLAY")
					count:SetFont(NAMEPLATE_FONT,10,"THINOUTLINE")
					count:SetPoint("CENTER",-6,0)
					--count:SetAlpha(0)
					icon.count = count]]
				elseif i==5 then
					icon:SetPoint("BOTTOMLEFT",1,1)
					tex:SetVertexColor(50/255,170/255,30/255)
				end
				icon.icon=tex
			end
			auras.icons[sid]=icon
		end
		self.AuraWatch=auras
	end

local function PreSetPosition(buffs)
	buffs.ef:SetPoint("TOPRIGHT",UIParent,0,-(bs+bsp)*math.ceil(buffs.visibleBuffs/8))
end
	
local function Shared(self,unit)

	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter",UnitFrame_OnEnter)
	self:SetScript("OnLeave",UnitFrame_OnLeave)
	
	if self:GetParent():GetName():match"kocc_raid" or unit=="focus" or unit =="pet" then -- smallunits

		local smw=bs*2+bsp
	
		self:SetAttribute("initial-width",smw)
		self:SetAttribute("initial-height",bs)
		
		local fb=CreateFrame("Frame",nil,self)
		fb:SetFrameLevel(0)
		fb:SetPoint("TOPLEFT")
		fb:SetPoint("BOTTOMRIGHT")
		fb:SetBackdrop(backdrop)
		
		if debug then fb:SetBackdropColor(0,0,0,0.5) else fb:SetBackdropColor(0,0,0,0) end
		
		fb:SetBackdropBorderColor(1,1,1,0.5)
		
		local name=fb:CreateFontString(nil,"OVERLAY")
		name:SetFont(unpack(smallfont))
		name:SetAllPoints()
		name:SetJustifyH("CENTER")
		name:SetJustifyV("MIDDLE")
		self:Tag(name,"[kocc:shortname]")
		
		local hdummy=CreateFrame("StatusBar",nil,self)
		self.Health=hdummy
		
		local hb=CreateFrame("StatusBar",nil,self)
		hb:SetStatusBarTexture(texture)
		hb:SetStatusBarColor(1,1,1)
			
		hb:SetPoint("TOPLEFT")
		hb:SetSize(smw,bs)
		
		self.Health.hb=hb
		self.Health.PostUpdate=PostUpdateHealthSmall

		createAuraWatch(self,unit)
		
		local debuffs=CreateFrame("Frame",nil,self)
		debuffs:SetPoint("CENTER")
		debuffs:SetSize(bs/3*2,bs/3*2)
		debuffs.num=1
		debuffs.spacing=bsp/3*2
		debuffs.size=bs/3*2
		debuffs.initialAnchor="LEFT"
		debuffs["growth-x"]="RIGHT"
		debuffs.disableCooldown="TRUE"
		
		if debug then
			debuffs:SetBackdrop({bgFile=texture})
			debuffs:SetBackdropColor(0,0,0,0.5)
		end
		
		function myCustomDebuffsFilter(i,u,ic,n,r,t,c,dtype,du,ti,ca,is,sh,spi)
			if dtype=="Poison" or dtype=="Curse" then	return true	else return false	end
		end
		
		debuffs.PostCreateIcon=PostCreateAura
		debuffs.PostUpdateIcon=PostUpdateDebuff
		debuffs.CustomFilter=myCustomDebuffsFilter
		self.Debuffs=debuffs
		
		local range={
			insideAlpha=1,
			outsideAlpha=1/3,
		}
		self.Range = range

		
	end

	if unit=="player" or unit=="target" then -- framesize
		self:SetAttribute("initial-width",fw)
		self:SetAttribute("initial-height",fh)
	elseif unit=="focustarget" then
		self:SetAttribute("initial-width",(bs+bsp)*6-bsp)
		self:SetAttribute("initial-height",bs)
	end
	
	if unit=="player" or unit=="target" then -- hp, pp bar
	
		if debug then
			fb=CreateFrame("Frame",nil,self)
			fb:SetPoint("TOPLEFT")
			fb:SetPoint("BOTTOMRIGHT")
			fb:SetBackdrop({bgFile=texture})
			fb:SetBackdropColor(0,0,0,0.5)
		end
		
		local hdummy=CreateFrame("StatusBar",nil,self)
		self.Health=hdummy
		
		local hb=CreateFrame("StatusBar",nil,self)
		hb:SetStatusBarTexture(texture)
		
		if unit=="player" then
			hb:SetStatusBarColor(0.5,0,0,0.5)
		else
			hb:SetStatusBarColor(1,1,1,0.5)
		end
			
		hb:SetPoint("TOPLEFT")
		hb:SetSize(fw,fh-ph)
		
		self.Health.hb=hb
		
		if unit=="player" then --skull

			skulltex="Interface\\AddOns\\koccui\\koccmedia\\textures\\s"
			
			skull=CreateFrame("Frame",nil,self)
			skull:SetPoint("CENTER",UIParent,"CENTER",0,0)
			
			skull:SetBackdrop({bgFile=skulltex})
			skull:SetBackdropColor(1,1,1)

			self.Health.skull=skull
			
		end
		
		self.Health.PostUpdate=PostUpdateHealth
		
		local pdummy=CreateFrame("StatusBar",nil,self)
		self.Power=pdummy
		
		local pb=CreateFrame("StatusBar",nil,self)
		pb:SetStatusBarTexture(texture)
		pb:SetStatusBarColor(1,1,1,0.5)
		pb:SetPoint("TOPLEFT",0,fh-ph)
		pb:SetSize(fw,ph)

		self.Power.pb=pb
		self.Power.PostUpdate=PostUpdatePower
		
	end
	
	if unit=="player" or unit=="target" then -- castbar
	
		cbw=(bs+bsp)*7
		cbh=bs
	
		local cb=CreateFrame("StatusBar",nil,self)
		cb:SetStatusBarTexture(texture)
		cb:SetStatusBarColor(1,1,1,0.5)	
		cb:SetPoint("TOPLEFT",-cbw,0)
		cb:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",0,0)
		self.Castbar=cb
		
		local cbi=cb:CreateTexture(nil,"OVERLAY")
		cbi:SetSize(bs,bs)
		cbi:SetPoint("TOPRIGHT",cb,"TOPLEFT",-bsp,0)
		cbibg=CreateFrame("Frame",nil,cb)
		cbibg:SetAllPoints(cbi)
		cbibg:SetBackdrop(backdrop)
		
		if debug then cbibg:SetBackdropColor(0,0,0,0.5) else cbibg:SetBackdropColor(0,0,0,0) end
		
		cbibg:SetBackdropBorderColor(1,1,1,0.5)	
		self.Castbar.Icon=cbi
		
		if unit=="player" then -- gcd, sf
		
			local sf=cb:CreateTexture(nil,"OVERLAY")
			sf:SetTexture(0.5,0,0,0.5)
			self.Castbar.SafeZone=sf

			local gcdf=CreateFrame("Frame",nil)
			gcdf:SetPoint("BOTTOMLEFT",cb)
			gcdf:SetSize(cbw,cbh/2)
			self.GCD=gcdf		

			--[[
			local spark=gcd:CreateTexture(nil,"OVERLAY")
			spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			spark:SetBlendMode("ADD")
			spark:SetHeight(cbh)
			spark:SetWidth(cbh)
			spark:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT",0,0)
			self.GCD.Spark=spark
			]]

			local gcdbar=CreateFrame("StatusBar",nil,gcdf)
			gcdbar:SetStatusBarTexture(texture)
			gcdbar:SetStatusBarColor(0.5,0,0,0.75)	
			gcdbar:SetAllPoints()
			gcdbar:SetMinMaxValues(0,1)
			self.GCD.Bar=gcdbar		

			if class=="WARLOCK" then
				self.GCD.ReferenceSpellName="Corruption"
			elseif class=="DRUID" then
				self.GCD.ReferenceSpellName="Lifebloom"
			end

		end

	end

	if unit=="target" or unit=="focustarget" then -- classicon
		classbg=CreateFrame("Frame",nil,self)
		if unit=="target" then
			classbg:SetPoint("TOPLEFT",self,"TOPRIGHT",4*(bs+bsp)+bsp,0)
		else
			classbg:SetPoint("TOPRIGHT",self,"TOPLEFT",-bsp,0)
		end
		classbg:SetSize(bs,bs)
		classbg:SetBackdrop(backdrop)
		
		if debug then classbg:SetBackdropColor(0,0,0,0.5) else classbg:SetBackdropColor(0,0,0,0) end
		
		classbg:SetBackdropBorderColor(1,1,1,0.5)	
		local class=classbg:CreateTexture(nil,"OVERLAY")
		class:SetPoint("TOPLEFT",1,-1)
		class:SetPoint("BOTTOMRIGHT",-1,1)
		self.ClassIcon=class
	end

	if unit=="player" then -- buffs, debuffs
	
		local buffs=CreateFrame("Frame",nil,self)
		buffs:SetPoint("TOPRIGHT",UIParent)
		buffs:SetSize((bs+bsp)*8,(bs+bsp)*3)
		buffs.num=24
		buffs.spacing=bsp
		buffs.size=bs
		buffs.initialAnchor="TOPRIGHT"
		buffs["growth-x"]="LEFT"		
		buffs["growth-y"]="DOWN"
		
		if debug then
			buffs:SetBackdrop({bgFile=texture})
			buffs:SetBackdropColor(0,0,0,0.5)
		else
			buffs:SetAlpha(0.5)
		end
		
		buffs.PostCreateIcon=PostCreateAura
		self.Buffs=buffs
		
		local ef = CreateFrame("Frame", nil, self)
		ef:SetPoint("TOPRIGHT",UIParent,0,-(bs+bsp)*3)
		ef:SetSize((bs+bsp)*5,bs+bsp)
		ef.size=bs
		ef.spacing=bsp
		ef.initialAnchor = "TOPRIGHT"
		ef["growth-x"] = "LEFT"

		if debug then		
			ef:SetBackdrop({bgFile=texture})
			ef:SetBackdropColor(0,0,0,0.5)
		else
			ef:SetAlpha(0.5)
		end
		
		self.Enchant=ef
		self.Buffs.ef=ef
		self.Buffs.PreSetPosition=PreSetPosition
		
--[[ debug
	end
	if unit=="target" then
]]

		local debuffs=CreateFrame("Frame",nil,self)
		debuffs:SetPoint("TOPLEFT",UIParent,"CENTER",-sw/4,sh/4)
		debuffs:SetSize((bs+bsp)*1.5*6,(bs+bsp)*1.5*2)
		debuffs.num=12
		debuffs.spacing=bsp*1.5
		debuffs.size=bs*1.5
		debuffs.initialAnchor="TOPLEFT"
		debuffs["growth-x"]="RIGHT"		
		debuffs["growth-y"]="DOWN"
		
		if debug then
			debuffs:SetBackdrop({bgFile=texture})
			debuffs:SetBackdropColor(0,0,0,0.5)
		end
		
		debuffs.PostCreateIcon=PostCreateAura
		debuffs.PostUpdateIcon=PostUpdateDebuff
		self.Debuffs=debuffs
	
	end

	if unit=="target" then -- auras
	
		local auras=CreateFrame("Frame",nil,self)
		auras:SetSize((bs+bsp)*8-bsp,(bs+bsp)*3-bsp)
		auras.num=20
		auras.spacing=bsp
		auras.size=bs
		
		auras:SetPoint("BOTTOMLEFT",self,"TOPRIGHT",(bs+bsp)*4+bsp,bsp)
		auras.initialAnchor="BOTTOMLEFT"
		auras["growth-x"]="RIGHT"
		auras["growth-y"]="UP"
		
		auras.PostCreateIcon=PostCreateAura
		auras.PostUpdateIcon=PostUpdateDebuff
		
		if debug then
			auras:SetBackdrop({bgFile=texture})
			auras:SetBackdropColor(0,0,0,0.5)
		else
			auras:SetAlpha(0.5)
		end
		
		self.Auras=auras
	
	end
	
	if unit=="player" or unit=="target" then -- cfeedback
	
		local cbftbg=CreateFrame("Frame",nil,self)
		cbftbg:SetSize((bs+bsp)*3,bs+bsp)
		if debug then
			cbftbg:SetBackdrop({bgFile=texture})
			cbftbg:SetBackdropColor(0,0,0,0.5)			
		end
		
		local cbft=cbftbg:CreateFontString(nil,"OVERLAY")
		
		if unit=="player" then
			cbftbg:SetPoint("TOPLEFT",UIParent,"CENTER",-(bs+bsp)*8,(bs+bsp)*3)
			cbft:SetPoint("TOPLEFT")
		else
			cbftbg:SetPoint("TOPRIGHT",UIParent,"CENTER",(bs+bsp)*8,(bs+bsp)*3)
			cbft:SetPoint("TOPRIGHT")
		end
		
		cbft:SetFont(unpack(medfont))
		self.CombatFeedbackText=cbft		
	
	end
	
	if unit=="target" or unit=="focustarget" then -- nametext
	
		txt=CreateFrame("Frame",nil,self)
		
		if unit=="target" then
			txt:SetPoint("TOPLEFT",self,"TOPRIGHT",5*(bs+bsp)+bsp,0)
			txt:SetSize((bs+bsp)*6-bsp,bs)
		else
			txt:SetAllPoints()
		end
		
		if debug then
			txt:SetBackdrop({bgFile=texture})
			txt:SetBackdropColor(0,0,0,0.5)
		end
			
		local name=txt:CreateFontString(nil,"OVERLAY")
		name:SetFont(unpack(medfont))
		name:SetAllPoints()
		name:SetJustifyH("LEFT")
		name:SetJustifyV("MIDDLE")
		name.frequentUpdates=1/4
		self:Tag(name,"[kocc:health] | [kocc:name]")
	
	end
	
	if unit=="player" or unit=="target" then
		self.menu=SpawnMenu
		self:SetAttribute("type2","menu")
	end
	
end

oUF:RegisterStyle("kocc",Shared)

fxm=(bs+bsp)*2+bsp/2+fw/2

oUF:Factory(function(self)
	self:SetActiveStyle("kocc")
	self:Spawn("player","oUF_player"):SetPoint("BOTTOMLEFT",UIParent,"CENTER",0,-sh/4)
	self:Spawn("target"):SetPoint("BOTTOMLEFT",oUF_player,"TOPLEFT",0,bsp)
	self:Spawn("focus"):SetPoint("BOTTOMRIGHT",UIParent,"CENTER",(bs+bsp)*10,-(bs+bsp)*7)
	self:Spawn("focustarget"):SetPoint("TOPRIGHT",UIParent,"CENTER",(bs+bsp)*15,-sh/4+bs)
	self:Spawn("pet"):SetPoint("BOTTOMLEFT",UIParent,"CENTER",-(bs+bsp)*8,-(bs+bsp)*7)
	--[[
	
	]]--
	local raid=oUF:SpawnHeader(
		"kocc_raid",nil,"solo,party,raid",
		"showPlayer",true,
		"showSolo",true,
		"showParty",true,
		"showRaid",true,
		"point","RIGHT",		
		"yOffset",bsp,
		"xOffset",-bsp,		
		"unitsPerColumn",5,
		"columnSpacing",bsp,
		"columnAnchorPoint","BOTTOM"

	)
	raid:SetPoint("BOTTOMLEFT",UIParent,"CENTER",-(bs+bsp)*6,-(bs+bsp)*7)
end)

