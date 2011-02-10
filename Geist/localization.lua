-- Local Table
local aName, aTable = ...

-- Not to be localized, just in here for general message purposes.
local green="|cff20ff20"
local yellow="|cffffff40"
local white="|cffffffff"

local version = GetAddOnMetadata("Geist", "Version")
local prettyName = green..aName..white
local prettySlash = yellow.."/geist "

-- Keybindings
local localKeybind = {
	FRAMEBINDSET = "Show Geist",
	BUTTONBINDSET = "Geist Button ",
}

-- Chat messages.
aTable.localChat = {
	SCALERESET = prettyName..": Scale reset.",
	SCALESET = prettyName..": Scale set to ",
	SCALEAT = prettyName..": Scale is at ",
	BUTTON = prettyName..": Button ",
	SETBUTTONID = " set to ID ",
	IDGUIDE = prettyName..": Button ID guide is now ",
	TOGGLEMODE = prettyName..": Toggle behaviour is now ",
	NUMBUTTONSET = prettyName..": Number of buttons now set to ",
	NUMBUTTONAT = prettyName..": Number of buttons currently set to: ",
}

-- Chat commands.
aTable.localCommand = {
	SCALE = "scale",
	RESET = "reset",
	HELP = "help",
	ASSIGN = "assign",
	GUIDE = "guide",
	BUTTON = "buttons",
	TOGGLE = "toggle",
	ON = "on",
	OFF = "off",
}

aTable.chatUsage = {
	prettyName.." "..version.." Usage:",
	prettySlash..aTable.localCommand["BUTTON"]..white..": Tells you the current number of buttons Geist is set to use.",
	prettySlash..aTable.localCommand["BUTTON"].." X"..white..": Set the number of buttons for Geist to use between 1 and 25. This command requires a UI reload to take effect.",
	prettySlash..aTable.localCommand["SCALE"]..white..": Tells you the current Geist scale.",
	prettySlash..aTable.localCommand["SCALE"].." X"..white..": Set the scale of Geist to between 0.5 and 1.5.",
	prettySlash..aTable.localCommand["SCALE"].." "..aTable.localCommand["RESET"]..white..": Reset Geist to match your UI scale.",
	prettySlash..aTable.localCommand["GUIDE"]..white..": Enables or disables the button ID guide. When enabled, two numbers lay over your buttons. The top number is the Geist button number. The bottom is the ID currently assigned to it.",
	prettySlash..aTable.localCommand["TOGGLE"]..white..": Enables or disables toggle behaviour. When enabled, Geist does not automagically close when releasing the button. Turning toggle mode off while Geist is open will cause Geist to act incorrectly.",
	prettySlash..aTable.localCommand["ASSIGN"].."X"..white..": Tells you what Button X's ID currently is.",
	prettySlash..aTable.localCommand["ASSIGN"].."X Y"..white..": Sets Button X to ID Y. This command requires a UI reload to take effect.",
}

-- deDE localization courtesy Hannesz (http://wowui.incgamers.com/?p=profile&u=375109).
if (GetLocale() == "deDE") then

-- Keybindings.
local localKeybind = {
	FRAMEBINDSET = "Geist anzeigen",
	BUTTONBINDSET = "Geist-Button ",
}

-- Chat messages.
aTable.localChat = {
	SCALERESET = prettyName..": Skalierung zurückgesetzt",
	SCALESET = prettyName..": Skalierung gesetzt auf ",
	SCALEAT = prettyName..": Skalierung beträgt ",
	BUTTON = prettyName..": Button ",
	SETBUTTONID = " gesetzt auf ID ",
	IDGUIDE = prettyName..": Button-ID-Anzeige (Hilfe) ist nun ",
	TOGGLEMODE = prettyName..": Toggle behaviour is now ",
	NUMBUTTONSET = prettyName..": Anzahl der Buttons gesetzt auf: ",
	NUMBUTTONAT = prettyName..": Anzahl der momentan gezeigten Buttons: ",
}

-- Chat commands.
aTable.localCommand = {
	SCALE = "skalierung",
	RESET = "reset",
	HELP = "hilfe",
	ASSIGN = "festlegen",
	GUIDE = "hilfe",
	TOGGLE = "toggle",
	BUTTON = "buttons",
	ON = "an",
	OFF = "aus",
}


aTable.chatUsage = {
	prettyName.." "..version.." Bedienung:",
	prettySlash..aTable.localCommand["BUTTON"]..white..": Teilt die Anzahl der Buttons mit, die Geist anzeigen soll.",
	prettySlash..aTable.localCommand["BUTTON"].." X"..white..": Setzt die Anzahl der durch Geist zu verwendenden Buttons fest. (Zulässige Werte: 1 - 25)",
	prettySlash..aTable.localCommand["SCALE"]..white..": Zeigt die momentane Skalierung von Geist an.",
	prettySlash..aTable.localCommand["SCALE"].." X"..white..": Legt die Skalierung von Geist fest. (Zulässige Werte: 0.5 - 1.5)",
	prettySlash..aTable.localCommand["SCALE"].." "..aTable.localCommand["RESET"]..white..": Die Skalierung von Geist so einstellen, dass sie mit der UI-Skallierung übereinstimmt.",
	prettySlash..aTable.localCommand["GUIDE"]..white..": Schaltet die Button-ID-Anzeige (Hilfe) an oder aus. Die Hilfe zeigt zwei Nummern über den Buttons an. Die Obere ist die Geist-Buttonnummer; die untere beschreibt die momentan zugewiesene ID.",
	prettySlash..aTable.localCommand["TOGGLE"]..white..": Enables or disables toggle behaviour. When enabled, Geist does not automagically close when releasing the button. Turning toggle mode off while Geist is open will cause Geist to act incorrectly.",
	prettySlash..aTable.localCommand["ASSIGN"].."X"..white..": Zeigt die momentan dem Button X zugewiesene ID an.",
	prettySlash..aTable.localCommand["ASSIGN"].."X Y"..white..": Setzt die ID von Button X auf den Wert Y.",
}
end

-- Bindings.
BINDING_HEADER_GEISTHEADER = aName
_G["BINDING_NAME_CLICK GeistHeader:LeftButton"] = localKeybind["FRAMEBINDSET"]
