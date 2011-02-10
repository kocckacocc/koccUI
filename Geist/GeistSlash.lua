-- Local Table
local aName, aTable = ...

-- Slash commands.
function aTable.ChatCommandHandler(msg)
	if ((msg) and (strlen(msg) > 0 )) then
		msg = string.lower(msg)
	else
		msg = ""
	end

	local i, j, cmd, param = string.find(msg, "^([^ ]+) (.+)$")
	if (not cmd) then
		cmd = msg
	end

	if (not cmd) then
		cmd = ""
	end

	if (not param) then
		param = ""
	end

	if (cmd == aTable.localCommand["SCALE"]) then
		if (param == aTable.localCommand["RESET"]) then
			aTable.ResetScale()
			aTable.Print(aTable.localChat["SCALERESET"])
		elseif tonumber(param) and (tonumber(param) >= 0.5) and (tonumber(param) <=1.5) then
			aTable.SetScale(tonumber(param))
			aTable.Print(aTable.localChat["SCALESET"]..tonumber(param)..".")
		else
			aTable.Print(aTable.localChat["SCALEAT"]..Geist["Scale"]..".")
		end

	elseif (cmd == aTable.localCommand["TOGGLE"]) then
		if Geist["ToggleMode"] then
			Geist["ToggleMode"] = nil
			GeistHeader:RegisterForClicks("AnyDown","AnyUp");
			aTable.Print(aTable.localChat["TOGGLEMODE"]..aTable.localCommand["OFF"]..".")
		else
			Geist["ToggleMode"] = 1
			GeistHeader:RegisterForClicks("AnyDown");
			aTable.Print(aTable.localChat["TOGGLEMODE"]..aTable.localCommand["ON"]..".")
		end

	elseif (cmd == aTable.localCommand["GUIDE"]) then
		if Geist["Guide"] then
			Geist["Guide"] = nil
			aTable.Print(aTable.localChat["IDGUIDE"]..aTable.localCommand["OFF"]..".")
		else
			Geist["Guide"] = 1
			aTable.Print(aTable.localChat["IDGUIDE"]..aTable.localCommand["ON"]..".")
		end
		aTable.DisplayGuide()

	elseif (cmd == aTable.localCommand["BUTTON"]) then
		if tonumber(param) and (tonumber(param) >= 1) and (tonumber(param) <= 25) then
			Geist["Buttons"] = floor(tonumber(param))
			aTable.Print(aTable.localChat["NUMBUTTONSET"]..floor(tonumber(param))..".")
		else
			aTable.Print(aTable.localChat["NUMBUTTONAT"]..Geist["Buttons"]..".")
		end

	elseif string.find(cmd, aTable.localCommand["ASSIGN"]) then
		local i, j, num = string.find(cmd, "([%d*]+)")
		if tonumber(num) and (tonumber(num) >= 1) and (tonumber(num) <= 25) then
			if tonumber(param) and (tonumber(param) >= 1) and (tonumber(param) <= 120) then
				Geist["ButtonIDs"][floor(tonumber(num))] = floor(tonumber(param))
				aTable.Print(aTable.localChat["BUTTON"]..floor(tonumber(num))..aTable.localChat["SETBUTTONID"]..floor(tonumber(param))..".")
			else
				aTable.Print(aTable.localChat["BUTTON"]..floor(tonumber(num))..aTable.localChat["SETBUTTONID"]..Geist["ButtonIDs"][floor(tonumber(num))]..".")
			end
		else
			aTable.HelpPrint()
		end
	else
		aTable.HelpPrint()
	end
end

function aTable.HelpPrint()
	for i = 1, table.getn(aTable.chatUsage) do
		aTable.Print(aTable.chatUsage[i])
	end
end
