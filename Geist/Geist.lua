-- Geist, by Cidrei (Jazrei of Zangarmarsh-US)

-- Local Table
local aName, aTable = ...

-- OnEvent
function aTable.OnEvent(self, event, ...)
	if ( event == "ADDON_LOADED" ) then
		local addonName = ...
		if ( not addonName or (addonName and addonName ~= "Geist") ) then
			return;
		end
		SLASH_GEIST1 = "/geist"
		SLASH_GEIST2 = "/gbm" -- Legacy commands ftw.
		SlashCmdList["GEIST"] = aTable.ChatCommandHandler

		aTable.SavedVars()
		aTable.Create()
		aTable.DisplayGuide()
	end
end

-- Saved variables
function aTable.SavedVars()
Geist = {
	["ButtonIDs"] = {
		37, -- [1]
		38, -- [2]
		39, -- [3]
		40, -- [4]
		41, -- [5]
		42, -- [6]
		43, -- [7]
		44, -- [8]
		45, -- [9]
		46, -- [10]
		47, -- [11]
		48, -- [12]
	},
	["ToggleMode"] = 1,
	["Scale"] = 1,
	["Buttons"] = 5,
}

end

-- Chat output
function aTable.Print(msg) 
	if not DEFAULT_CHAT_FRAME then
		return
	end

	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

-- Scale
function aTable.SetScale(scale)
	if GeistHeader then
		GeistHeader:SetScale(scale)
		Geist["Scale"] = scale
	else
		return
	end
end

function aTable.ResetScale()
	if(GetCVar("useUiScale") == "0") then	
		Geist["Scale"] = 1
	else
		Geist["Scale"] = GetCVar("uiscale")
		GeistHeader:SetScale(GetCVar("uiscale"))
	end
end

-- Guide
function aTable.DisplayGuide()
	for i = 1, table.getn(aTable.Buttons) do
		if Geist["Guide"] then
			aTable.Buttons[i].title:Show()
		else
			aTable.Buttons[i].title:Hide()
		end
	end
end

-- Local event frame
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", aTable.OnEvent)
