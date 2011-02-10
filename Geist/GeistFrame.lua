-- Local Table
local aName, aTable = ...

function aTable.Create()
	-- Create the header.
	local header = CreateFrame("Button", "GeistHeader", UIParent, "SecureHandlerClickTemplate")

	if Geist["ToggleMode"] then
		header:RegisterForClicks("AnyDown")
	else
		header:RegisterForClicks("AnyDown","AnyUp")
	end

	header:Hide()

	-- Set onClick behaviour.
	header:SetAttribute("_onclick", [[
		self:SetPoint("CENTER", "$cursor")

		if geistOpen then
			geistOpen = nil
			self:Hide()
		else
			geistOpen = 1
			self:Show()
		end]]
	)

	header:SetFrameStrata("HIGH")

	-- Create the buttons.
	aTable.Buttons = {}

	for i = 1, Geist["Buttons"] do
		local button = CreateFrame("CheckButton", "GeistButton"..i, GeistHeader, "ActionBarButtonTemplate")
		aTable.Buttons[i] = button
		if i == 1 then
			button:SetPoint("CENTER", GeistHeader, "CENTER", 0, 0)
		elseif i == 2 then
			button:SetPoint("RIGHT", aTable.Buttons[i-1], "LEFT", -2, 0)
		elseif i == 3 then
			button:SetPoint("LEFT", aTable.Buttons[i-2], "RIGHT", 2, 0)
		elseif i == 4 then
			button:SetPoint("BOTTOM", aTable.Buttons[i-3], "TOP", 0, 2)
		elseif i == 5 then
			button:SetPoint("TOP", aTable.Buttons[i-4], "BOTTOM", 0, -2)
		elseif i == 6 or i == 14 then
			button:SetPoint("RIGHT", aTable.Buttons[i-2], "LEFT", -2, 0)
		elseif i == 7 or i == 15 then
			button:SetPoint("LEFT", aTable.Buttons[i-3], "RIGHT", 2, 0)
		elseif i == 8 or i == 16 then
			button:SetPoint("RIGHT", aTable.Buttons[i-3], "LEFT", -2, 0)
		elseif i == 9 or i == 17 then
			button:SetPoint("LEFT", aTable.Buttons[i-4], "RIGHT", 2, 0)
		elseif i == 10 or i == 22 or i == 24 then
			button:SetPoint("RIGHT", aTable.Buttons[i-8], "LEFT", -2, 0)
		elseif i == 11 or i == 23 or i == 25 then
			button:SetPoint("LEFT", aTable.Buttons[i-8], "RIGHT", 2, 0)
		elseif i == 12 then
			button:SetPoint("BOTTOM", aTable.Buttons[i-8], "TOP", 0, 2)
		elseif i == 13 then
			button:SetPoint("TOP", aTable.Buttons[i-8], "BOTTOM", 0, -2)
		elseif i == 18 or i == 20 then
			button:SetPoint("RIGHT", aTable.Buttons[i-12], "LEFT", -2, 0)
		elseif i == 19 or i == 21 then
			button:SetPoint("LEFT", aTable.Buttons[i-12], "RIGHT", 2, 0)
		end

		-- Assign button ids.
		button:SetAttribute("*type*", "action")
		button:SetAttribute("*action*", Geist["ButtonIDs"][i])
		--button:SetAttribute("unit2", "player")  -- Right-click to self cast.

		-- Create button guide.
		button.title = button:CreateFontString(nil, "OVERLAY")
		button.title:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
		button.title:SetTextColor(1, 1, 0)
		button.title:SetAllPoints(button)
		button.title:SetText(i.."\n"..Geist["ButtonIDs"][i])
	end

	-- Create title box.
	local title = CreateFrame("Frame", nil, header)
	title:SetAttribute("scale", Geist["Scale"])
	title:SetFrameStrata("BACKGROUND")
	title:SetWidth(36)
	title:SetHeight(36)
	title:SetPoint("CENTER", 0, 0)

	local t = title:CreateTexture(nil,"BACKGROUND")
	t:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
	t:SetAllPoints(title)
	t:SetVertexColor(1, 1, 1, .5)
	title.texture = t

	title.title = title:CreateFontString(nil, "OVERLAY")
	title.title:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	title.title:SetTextColor(1, 1, 0, .8)
	title.title:SetPoint("TOP", title, "TOP", 0, -1)
	title.title:SetText("Geist")

	-- Set the scale.
	header:SetScale(Geist["Scale"])
end
