local fiend = _G.Fiend

local font="Interface\\AddOns\\!koccmedia\\fonts\\calibri.ttf"

local ADDON_NAME, Fiend = ...
Fiend.L = Fiend.L or { }
local L = setmetatable(Fiend.L, { __index = function(t, s) t[s] = s return s end })

local Display = {
}

local View = {
	texture = [[Interface\addons\Fiend\media\HalV.tga]],
	max = 0,
	isActive = false,
	total = 0,
	bg = { 0.3, 0.3, 0.3 },
}

local floor = math.floor

local tip = GameTooltip
function Display.OnEnter(self)
	if self:IsShown() and self.pos > 0 then
		tip:SetOwner(self, "ANCHOR_LEFT")

		if(fiend.trackDPS) then
			tip:AddDoubleLine(self.pos .. ". " .. self.name, self.parent:GetDPS(self.guid), self.col.r, self.col.g, self.col.b, self.col.r, self.col.g, self.col.b)
		else
			tip:AddLine(self.pos .. ". " .. self.name, self.col.r, self.col.g, self.col.b)
		end

		tip:AddDoubleLine(self.total, "(" .. math.floor(self.total / self.parent.total * 100) .. "%)", 1, 1, 1, 1, 1, 1)

		tip:Show()
		self.parent.tip = true
	end
end

local pool = setmetatable({}, {
	__mode = "k",
	__newindex = function(self, index, bar)
		bar.name = nil
		bar.guid = nil
		bar.class = nil
		bar.col = nil
		bar.total = 0
		bar.parent = nil

		rawset(self, index, bar)
	end
})

local dpsMeta
if(fiend.trackDPS) then
	--This is bad because we can have duplicate data!
	dpsMeta = {
		__index = function(self, key)
			local t = {
				time = 0,
				timer = 0,
				damage = 0,
				segment = 0,
			}

			rawset(self, key, t)
			return self[key]
		end
	}

	function View:UpdateDPS(time)
		local t
		for unit, guid in fiend:IterateUnitRoster() do
			t = self.dps[guid]
			if(fiend:InCombat(guid)) then
				if(t.reset) then
					t.damage = 0
					t.time = 0
					t.reset = false
				end

				t.damage = t.damage + t.segment

				t.time = t.time + time
			else
				t.reset = true
			end
		end
	end

	function View:GetDPS(guid)
		return math.floor(self.dps[guid].damage / (self.dps[guid].time or 1))
	end
end

function View:Update(guid, ammount, name)
	local bar = self.guids[guid]
	bar.name = string.match(name, "(.*)\-?")

	if(fiend.trackDPS) then
		self.dps[guid].damage = self.dps[guid].damage + ammount
	end

	if(fiend.trackDPS and self.showDPS) then
		bar.total = self:GetDPS(bar.guid)
	else
		bar.total = bar.total + ammount
	end

	self.total = self.total + ammount

	-- bar.per = math.floor(bar.total / self.total * 100)

	if(bar.total > 1e3) then
		bar.right:SetText(math.floor((bar.total * 10) / 100) / 100 .. "k")
	else
		bar.right:SetText(bar.total)
	end

	self.dirty = true
end

function View:UpdateDisplay()
	if not self.isActive or #self.bars == 0 or not self.display.frame:IsShown() or self.updating then return end
	self.updating = true

	if(fiend.trackDPS and self.showDPS) then
		for guid, bar in pairs(self.bars) do
			--bar.total = self:GetDPS(bar.guid)
			self:Update(bar.guid, 0, bar.name)
		end
	end

	table.sort(self.bars, function(a, b) return b.total < a.total end)

	local total = math.floor((self.display.frame:GetHeight() - 32) / self.size)
	local width = self.display.frame:GetWidth()

	local size = self.size

	local max = self.bars[1].total

	local bar
	for i = 1, #self.bars do
		bar = self.bars[i]

		if i > total then
			bar.pos = 0
			bar:Hide()
		else
			bar:SetValue(100 * (bar.total / max))

			if bar.pos ~= i then
				bar:SetPoint("TOP", self.display.frame, "TOP", 0, ((i - 1) * -size) - 15)

				bar.left:SetText(i .. ". " .. bar.name)

				bar.pos = i
			end

			bar:Show()
		end
	end

	self.dirty = false
	self.updating = false
end

function View:RemoveAllBars()
	local bar
	for i = 1, #self.bars do
		bar = table.remove(self.bars, 1)

		bar:Hide()

		self.guids[bar.guid] = nil

		table.insert(pool, bar)
	end

	self.total = 0
end

function View:Resizing(width, height)
	local total = math.floor((height or self.display.frame:GetHeight() - 32) / self.size)

	local bar
	for i = 1, #self.bars do
		bar = self.bars[i]
		if i > total then
			bar:Hide()
		else
			bar:Show()
		end
	end

	self.dirty = true
end

function View:Activate()
	if self.isActive then return end

	if self.display.currentView then
		self.display.currentView:Deactivate()
	end

	self.display.frame.title:SetText(self.title)
	self.display.frame:SetBackdropBorderColor(unpack(self.bg))

	self.display.currentView = self

	if self.display.dropDown:IsShown() then
		UIDropDownMenu_Refresh(self.display.dropDown)
	end

	self.isActive = true
	-- Update faster
	self:UpdateDisplay()
end

function View:Deactivate(clean)
	if not self.isActive then return end

	self.isActive = false

	if clean then
		self:ResetAllBars()
	else
		local bar
		for i = 1, #self.bars do
			bar = self.bars[i]
			bar:Hide()
			bar.pos = 0     -- Force update next dirty cycle
		end
	end

	self.display.currentView = nil
end

function View:Output(count, where, player)
	if #self.bars == 0 then return end

	local output

	if not where then
		output = print
	else
		output = function(str)
			SendChatMessage(str, where, nil, where == "WHISPER" and player)
		end
	end

	output("Fiend - " .. self.title .. ":")

	-- Need to do a double pass
	local bar
	for i = 1, count or #self.bars do
		if not self.bars[i] then break end
		bar = self.bars[i]

		if(fiend.trackDPS) then
			local dps = self:GetDPS(bar.guid)
		end

		if(fiend.trackDPS and dps > 0) then
			output(string.format("%d. %s - %d %d%% - %d dps", i, bar.name, bar.total, (math.floor(bar.total * 10000 / self.total) / 100), dps))
		else
			output(string.format("%d. %s - %d %d%%", i, bar.name, bar.total, (math.floor(bar.total * 10000 / self.total) / 100)))
		end
	end
end

function Display:OnUpdate(elapsed)
	if(fiend.trackDPS) then
		for i, view in pairs(self.views) do
			view:UpdateDPS(elapsed)
		end
	end

	if((self.currentView and self.currentView.dirty) or (fiend.trackDPS and self.currentView.showDPS)) then
		self.currentView:UpdateDisplay()
	end
end

function Display:CreateFrame(title)
	local frame = CreateFrame("Frame", "FiendDamage" .. title, UIParent)
	frame:SetHeight(128)
	frame:SetWidth(160)
	frame:SetPoint("BOTTOMRIGHT",UIParent,"RIGHT")
	frame:EnableMouse(true)

	frame:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			self:StopMovingOrSizing()
		end
	end)

	frame:SetScript("OnMouseDown", function(s, button)
		if IsModifiedClick("ALT") and button == "LeftButton" then
			s:StartMoving()
		elseif button == "RightButton" then
			if IsModifiedClick("SHIFT") then
				self.currentView:RemoveAllBars()
			else
				ToggleDropDownMenu(1, nil, self.dropDown, "cursor")
			end
		end
	end)

	frame:SetScript("OnSizeChanged", function(s, width, height)
		if self.currentView then
			self.currentView.dirty = true
		end
	end)

	local texture="Interface\\Buttons\\WHITE8x8"
	frame:SetBackdrop({bgFile=texture})
	frame:SetBackdropColor(0,0,0,0.1)

	local title = frame:CreateFontString(nil, "OVERLAY")
	title:SetFont(font,12)
	title:SetText("Fiend")
	title:SetJustifyH("LEFT")
	title:SetPoint("LEFT")
	title:SetPoint("TOP",0,0)

	frame.title = title


	self.frame = frame
end

function fiend:NewDisplay(title)
	title = title or #self.displays + 1
	if self.displays[title] then return end

	local t = {
		views = {},
		menu = {},
		events = {},
		numViews = 0,
		title = title,
	}

	local display = setmetatable(t, { __index = Display } )

	display:CreateFrame(title)
	display:ToolTip()

	self.displays[title] = display

	return display
end

function Display:CombatEvent(event, guid, ammount, name, overHeal)
	if not self.events[event] then
		return
	end

	for i, d in pairs(self.events[event]) do
		if overHeal and d.overHeal then
			d:Update(guid, overHeal, name)
		elseif ammount > 0 then
			d:Update(guid, ammount, name)
		end
	end
end

function Display:NewView(title, events, size, bg, color, dps)
	if self.views[title] then return self.views[title] end

	local t = setmetatable({}, { __index = View })

	t.bars = {}
	t.size = size
	t.title = title
	t.bg = bg or self.bg
	t.color = color
	t.display = self
	t.total = 0

	if(fiend.trackDPS) then
		t.dps = setmetatable({}, dpsMeta)

		if dps then
			t.showDPS = true
		end
	elseif(dps) then
		print("DPS tracking disabled, bailing!")
		return
	end

	for i, event in pairs(events) do
		self.events[event] = self.events[event] or {}
		table.insert(self.events[event], t)
	end

	t.guids = setmetatable({}, { __index = function(s, guid)
		local bar
		if next(pool) then
			bar = table.remove(pool, 1)
		else
			local texture="Interface\\Buttons\\WHITE8x8"
	
			bar = CreateFrame("Statusbar", nil, self.frame)
			bar:SetStatusBarTexture(texture)
			bar:SetMinMaxValues(0, 100)
			bar:SetPoint("LEFT", 1, 0)
			bar:SetPoint("RIGHT", - 1, 0)
			bar:EnableMouse(true)
			bar:Hide()

			bar:SetScript("OnEnter", self.OnEnter)
			bar:SetScript("OnLeave", function(self) tip:Hide(); self.tip = false end)

			local bg = bar:CreateTexture(nil, "BACKGROUND")
			bg:SetTexture(texture)
			bg:SetAllPoints(bar)

			bar.bg = bg

			local left = bar:CreateFontString(nil, "OVERLAY")
			left:SetFont(font, size - 2)
			left:SetPoint("LEFT", bar, "LEFT", 0, 0)
			left:SetPoint("BOTTOM")
			left:SetPoint("TOP")

			bar.left = left

			local right = bar:CreateFontString(nil, "OVERLAY")
			right:SetFont(font, size - 2)
			right:SetPoint("RIGHT", self.frame, "RIGHT", -5, 0)
			right:SetPoint("TOP")
			right:SetPoint("BOTTOM")
			right:SetJustifyH("RIGHT")


			bar.right = right
		end

		local col = t.color

		if not col then
			local unit = fiend:GetUnit(guid)
			local class = select(2, GetPlayerInfoByGUID(guid)) or "WARRIOR"
			col = RAID_CLASS_COLORS[class]
		end

		bar:SetHeight(size)
		bar:SetStatusBarColor(col.r, col.g, col.b, 0.2)
		bar.bg:SetVertexColor(col.r, col.g, col.b, 0.1)

		bar.left:SetText(name)
		bar.right:SetText(0)

		bar.guid = guid
		bar.parent = t
		bar.total = 0
		bar.pos = 0
		bar.col = col

		table.insert(t.bars, bar)
		rawset(s, guid, bar)

		bar:Hide()

		return bar
	end})

	local drop = self.dropDown

	local menu = {
		text = title,
		owner = drop,
		func = function(self)
			t:Activate()
		end,
	}

	self.menu[1][4].menuList[#self.menu[1][4].menuList + 1] = menu

	if self.dropDown:IsShown() then
		UIDropDownMenu_Refresh(self.dropDown)
	end

	if self.numViews == 0 then
		t:Activate()
	end

	self.numViews = self.numViews + 1

	self.views[title] = t

	return t
end

function Display:ToolTip()
	local drop = CreateFrame("Frame", "FiendDropDown_" .. self.title, UIParent, "UIDropDownMenuTemplate")

	local title = "Fiend"

	if self.currentView then
		title = "Fiend - " .. self.currentView.title
	end

	-- </3
	self.menu = {
		{
			{
				text = title,
				owner = drop,
				isTitle = true,
			}, {
				text = L["Reset"],
				owner = drop,
				func = function()
					if self.currentView then
						self.currentView:RemoveAllBars()
					end
				end,
			}, {
				text = L["Reset All"],
				owner = drop,
				func = function()
					for i, d in pairs(self.views) do
						d:RemoveAllBars()
					end
				end,
			}, {
				text = L["Displays"],
				owner = drop,
				hasArrow = true,
				menuList = {
				},
			}
		},
	}


	UIDropDownMenu_Initialize(drop, function(horse, level, menuList)
		if not (menuList or self.menu[level]) then return end
		for k, v in ipairs(menuList or self.menu[level]) do
			v.value = k
			UIDropDownMenu_AddButton(v, level)
		end
	end, "MENU", 1)

	if fiend.menu then
		count = #fiend.menu[1][2].menuList
		fiend.menu[1][2].menuList[count + 1] = {
			text = self.title,
			hasArrow = true,
			menuList = self.menu[1]
		}
	end

	self.dropDown = drop

	return drop
end
