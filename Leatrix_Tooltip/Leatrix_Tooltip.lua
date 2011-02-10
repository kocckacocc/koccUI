----------------------------------------------------------------------
-- 	Leatrix Tooltip 4.51
-- 	Last updated: 16th November 2010
----------------------------------------------------------------------

----------------------------------------------------------------------
-- 	Colors (you can change these values if you wish)
----------------------------------------------------------------------

	local LeaTipNoneCol = "ff00aaff"	-- Unflagged player or NPC (blue)
	local LeaTipFlagCol = "ff00ff00"	-- Flagged player (green)
	local LeaTipDeadCol = "88888888"	-- Dead units (grey)
	local LeaTipMmobCol = "ffff3333"	-- Hostile mob (red)
	local LeaTipMtapCol = "8888bbbb"	-- Tapped hostile mob (steel blue)
	local LeaTipRareCol = "00e066ff"	-- Rare spawn (normal or elite)
	local LeaTipTypeCol = "ffffffff"	-- Creature type (white)
	local LeaTipGildCol = "00aaaaff"	-- Guild name (purple)
	
----------------------------------------------------------------------
-- 	Script code
----------------------------------------------------------------------

-- 	Create tables to store configuration
	if not LeaTipOptionsDB then LeaTipOptionsDB = {} end
	local LeaTipOptionsLC = {}

--	Initialise variables
	local r, g, b = 1.0, 0.85, 0.0
	local LeaTipLocale = GetLocale()	-- Local for class color
	local LeaTipNdata, LeaTipNcolr		-- Name data and color
	local LeaTipIline, LeaTipIdata		-- Info line and data
	local LeaTipMline, LeaTipMcolr		-- Mob data and color
	local LeaTipCcolr, LeaTipLcolr		-- Class and level color
	local LeaTipXcolr					-- Pure class color
	local LeaTipRelativeTo				-- Relative anchor
	local LeaTipUnit, LeaTipClass		-- Unit and class
	local LeaTipName2					-- The name is back
	local LeaTipGuild					-- Guild name	
	local LeaTipGline, LeaTipGdata		-- Guild line and data

	-- Options panel
	local LeaTipOptMobType
	local LeaTipOptBackSame, LeaTipOptBackHost
	local LeaTipOptClassName, LeaTipOptClassTarget, LeaTipOptCombat
	local LeaTipOptMobType, LeaTipOptMouse, LeaTipOptRace, LeaTipOptRealm
	local LeaTipOptScaleCheck, LeaTipOptTarget, LeaTipOptTitle
	local LeaTipOptGuild

--	Set default tooltip
	local function LeatrixTipDefaultAnchor(tooltip, parent,LeaTipUnit)
		if (LeaTipOptionsLC["LeaTipOptMouse"] == "On") then	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		else GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");
			 GameTooltip:SetPoint(LeaTipOptionsLC["Leatrix_Anchor"], UIParent, LeaTipOptionsLC["Leatrix_Relative"], LeaTipOptionsLC["Leatrix_XOffset"], LeaTipOptionsLC["Leatrix_YOffset"]);
		end
	end
	GameTooltip_SetDefaultAnchor = LeatrixTipDefaultAnchor;

----------------------------------------------------------------------
--	Functions
----------------------------------------------------------------------	

--	Move the tooltip
	local function LeaTipFuncMove()
		local LeaTipMove = CreateFrame("Frame", "Leatrix_Tooltip", UIParent)
		local LeaTipText = "Leatrix Tooltip\n\nPosition the blue box where\nyou want the tooltip to go.\n\nHover over something to see\nif the tooltip looks right.\n\nClick OK to save the location.";
		StaticPopupDialogs["LeaTipMoveCheck"] = {
		text = LeaTipText,
		button1 = "Ok",
		OnAccept = function() 
			LeaTipMove:Hide();
			DEFAULT_CHAT_FRAME:AddMessage("Tooltip saved at " .. (format("%.0f", LeaTipOptionsLC['Leatrix_XOffset'])) .. ", " .. (format("%.0f", LeaTipOptionsLC['Leatrix_YOffset'])) .. ".",  r,g,b)
			InterfaceOptionsFrame:Show();
		end,
		sound = "TalentScreenOpen",
		timeout = 0,
		hideOnEscape = false,
		whileDead = 1
		};

		StaticPopup_Show ("LeaTipMoveCheck");

		LeaTipMove:Show();
		if LeaTipOptionsLC["LeaTipOptScaleCheck"] == "On" then
			LeaTipMove:SetScale(LeaTipOptionsLC["LeaTipOptScaleSlider"])
		else
			LeaTipMove:SetScale(1.00)
		end
		LeaTipMove:SetMovable(true)
		LeaTipMove:EnableMouse(true)
		LeaTipMove:RegisterForDrag("LeftButton")
		LeaTipMove:SetScript("OnDragStart", LeaTipMove.StartMoving)
		LeaTipMove:SetToplevel(true);
		LeaTipMove:SetClampedToScreen();
		LeaTipMove:SetWidth(130);
		LeaTipMove:SetHeight(64);
		LeaTipMove:SetPoint(LeaTipOptionsLC["Leatrix_Anchor"], UIParent, LeaTipOptionsLC["Leatrix_Relative"], LeaTipOptionsLC["Leatrix_XOffset"], LeaTipOptionsLC["Leatrix_YOffset"]);

		local tex = LeaTipMove:CreateTexture("ARTWORK");
		tex:SetAllPoints();
		tex:SetTexture(0.0, 0.5, 1.0); tex:SetAlpha(0.7);

		LeaTipMove:SetScript("OnDragStop", function ()
			LeaTipMove:StopMovingOrSizing();
			LeaTipOptionsLC["Leatrix_Anchor"], LeaTipRelativeTo, LeaTipOptionsLC["Leatrix_Relative"], LeaTipOptionsLC["Leatrix_XOffset"], LeaTipOptionsLC["Leatrix_YOffset"] = LeaTipMove:GetPoint()
		end)
	end

--	Reset the tooltip position
	local function LeaTipReset()
		LeaTipOptionsLC["Leatrix_XOffset"] = "-13";
		LeaTipOptionsLC["Leatrix_YOffset"] = "94";
		LeaTipOptionsLC["Leatrix_Anchor"] = "BOTTOMRIGHT";
		LeaTipOptionsLC["Leatrix_Relative"] = "BOTTOMRIGHT";
		DEFAULT_CHAT_FRAME:AddMessage("Tooltip reset to " .. (format("%.0f", LeaTipOptionsLC['Leatrix_XOffset'])) .. ", " .. (format("%.0f", LeaTipOptionsLC['Leatrix_YOffset'])) .. ".",  r,g,b)
	end
			
-- 	Replace line in the tooltip
	local function repline(line,text)
		_G["GameTooltipTextLeft"..line]:SetText(text)
	end

--	Show or hide the tooltip
	local function LeaTipVanish(status)
		if status == "hide" then
			GameTooltip:SetScript("OnShow", function() GameTooltip:Hide() end)
		elseif status == "show" then
			GameTooltip:SetScript("OnShow", function() GameTooltip:Show() end)
		end
	end

--	Set scale
	local function LeaTipSetScale()
		if LeaTipOptionsLC["LeaTipOptScaleCheck"] == "On" then
			GameTooltip:SetScale(LeaTipOptionsLC["LeaTipOptScaleSlider"])
		elseif LeaTipOptionsLC["LeaTipOptScaleCheck"] == "Off" then 
			GameTooltip:SetScale("1.00")
		end
		return
	end

----------------------------------------------------------------------
-- 	Show Tooltip
----------------------------------------------------------------------

	local function ShowTip(update)

		-- If Leatrix Tooltip is disabled, go back!
		if LeaTipOptionsLC["LeaTipOptEnable"] == "Off" then return end

		-- If tooltips are hidden in combat, hide them and go back!
		if LeaTipOptionsLC["LeaTipOptCombat"] == "On" and (UnitAffectingCombat("player") == 1) then
			GameTooltip:Hide()
			return
		end

		-- Get unit information
		if GetMouseFocus() == WorldFrame then
			LeaTipUnit = "mouseover"
		else
			LeaTipName2, LeaTipUnit = GameTooltip:GetUnit()
			if not (LeaTipUnit) then return end
		end

		-- If something is wrong, get the hell of out here!
		if (UnitReaction(LeaTipUnit,"player")) == nil then return end

		-- Setup variables
		local LeaName, LeaRealm = UnitName(LeaTipUnit)
		local LeaPlayer 		= UnitIsPlayer(LeaTipUnit)
		local LeaLevel			= UnitLevel(LeaTipUnit)
		local _,fclass 			= UnitClassBase(LeaTipUnit)

		-- Get guild information
		if (LeaPlayer) then
			if (GetGuildInfo(LeaTipUnit)) then
				LeaTipGline, LeaTipIline = 2, 3
				LeaTipGuild = GetGuildInfo(LeaTipUnit)
			else
				LeaTipGuild = nil
				LeaTipGline, LeaTipIline = 0,2
			end
		end

		-- Sort out the class color
		if (fclass) then
			if (LeaTipLocale == "enUS") then
				LeaTipClass = LOCALIZED_CLASS_NAMES_MALE[fclass]
			else
				LeaTipClass = LOCALIZED_CLASS_NAMES_FEMALE[fclass]
			end
			LeaTipXcolr = RAID_CLASS_COLORS[fclass]
			LeaTipCcolr = "|cff" .. string.format('%02x%02x%02x',LeaTipXcolr.r * 255, LeaTipXcolr.g * 255, LeaTipXcolr.b * 255)
		end

----------------------------------------------------------------------

		-- Name line (name and realm for friendly or higher players, pets and npcs)
		if ((LeaPlayer) or (UnitPlayerControlled(LeaTipUnit))) or (UnitReaction(LeaTipUnit,"player")) > 4 then

			-- If it's a player and name color is class color
			if (LeaPlayer) and LeaTipOptionsLC["LeaTipOptClassName"] == "On" then
				LeaTipNcolr = LeaTipCcolr
			else
				-- If not, set to green or blue depending on PvP status
				if (UnitIsPVP(LeaTipUnit)) then
					LeaTipNcolr = "|c" .. LeaTipFlagCol
				else
					LeaTipNcolr = "|c" .. LeaTipNoneCol
				end
			end

			-- Show title
			if LeaTipOptionsLC["LeaTipOptTitle"] == "On" then
				LeaTipNdata = UnitPVPName(LeaTipUnit)
			else
				LeaTipNdata = LeaName
			end

			-- Show realm
			if not (LeaRealm == nil) and LeaTipOptionsLC["LeaTipOptRealm"] == "On" then
				LeaTipNdata = LeaTipNdata .. " - " .. LeaRealm
			end
		
			-- Show dead units in grey
			if UnitIsDeadOrGhost(LeaTipUnit) then
				LeaTipNcolr = "|c" .. LeaTipDeadCol
			end

			-- Show name line in color (alive) or grey (dead)
			repline(1, LeaTipNcolr .. LeaTipNdata .. "|cffffffff|r")
			
		elseif UnitIsDeadOrGhost(LeaTipUnit) then

			-- Show grey name for other dead units
			repline(1,"|c" .. LeaTipDeadCol .. _G["GameTooltipTextLeft1"]:GetText() .. "|cffffffff|r")

		return end

----------------------------------------------------------------------

		-- Guild line
		if (LeaPlayer) and not (LeaTipGuild == nil) and LeaTipOptionsLC["LeaTipOptGuild"] == "On" then
			
			-- Show guild name in purple
			repline (LeaTipGline, "|c" .. LeaTipGildCol .. LeaTipGuild .. "|cffffffff|r")

		end
	
----------------------------------------------------------------------
			
		-- Information line (level, class, race)
		if (LeaPlayer) then

			-- Show level
			if (UnitReaction(LeaTipUnit,"player")) < 5 then
				if LeaLevel == -1 then
					LeaTipIdata = ("|cffff3333Level ??|cffffffff")
				else
					LeaTipLcolr = (GetQuestDifficultyColor(UnitLevel(LeaTipUnit)))
					LeaTipLcolr = string.format('%02x%02x%02x', LeaTipLcolr.r * 255, LeaTipLcolr.g * 255, LeaTipLcolr.b * 255)
					LeaTipIdata = ("|cff" .. LeaTipLcolr .. "Level " .. LeaLevel .. "|cffffffff")
				end
			else
				LeaTipIdata = "Level " .. LeaLevel
			end

			-- Show race
			if (LeaTipOptionsLC["LeaTipOptRace"] == "On") then
				LeaTipIdata = LeaTipIdata .. " " .. UnitRace(LeaTipUnit)
			end

			-- Show class
			LeaTipIdata = LeaTipIdata .. " " .. LeaTipCcolr .. LeaTipClass

			-- Show information line
			repline (LeaTipIline, LeaTipIdata .. "|cffffffff|r")

		end

----------------------------------------------------------------------

		-- Mob name in brighter red (alive) and steel blue (tapped)
		if not (LeaPlayer) and (UnitReaction(LeaTipUnit,"player")) < 4 and not (UnitPlayerControlled(LeaTipUnit)) then
			if (UnitIsTapped(LeaTipUnit) and not (UnitIsTappedByPlayer(LeaTipUnit))) then
				LeaTipNdata = "|c" .. LeaTipMtapCol .. LeaName .. "|r"
			else
				LeaTipNdata = "|c" .. LeaTipMmobCol .. LeaName .. "|r"
			end
			repline(1,LeaTipNdata)
		end

----------------------------------------------------------------------

		-- Mob level in color (neutral or lower)
		if not (LeaPlayer) and (UnitReaction(LeaTipUnit,"player")) < 5 and not (UnitPlayerControlled(LeaTipUnit)) then

			-- Level ?? mob
			if LeaLevel == -1 then
				LeaTipIdata = "|cffff3333Level ??|cffffffff "

			-- Mobs within level range
			else
				LeaTipMcolr = (GetQuestDifficultyColor(UnitLevel(LeaTipUnit)))
				LeaTipMcolr = string.format('%02x%02x%02x', LeaTipMcolr.r * 255, LeaTipMcolr.g * 255, LeaTipMcolr.b * 255)
				LeaTipIdata = "|cff" .. LeaTipMcolr .. "Level " .. LeaLevel .. "|cffffffff "
			end

			-- Find the line with level information on it
			if not (strsplit(" ", string.lower(_G["GameTooltipTextLeft2"]:GetText()),2) == "level") then LeaTipMline = 3 else LeaTipMline = 2 end

			-- Show creature type and classification (find a happy place!)
			local LeaLeaTipOptMobType = UnitCreatureType(LeaTipUnit)
			if LeaTipOptionsLC["LeaTipOptMobType"] == "On" and (LeaLeaTipOptMobType) and not (LeaLeaTipOptMobType == "Not specified") then
				LeaTipIdata = LeaTipIdata .. "|c" .. LeaTipTypeCol .. LeaLeaTipOptMobType .. "|cffffffff "
			end

			-- Sort out the special mobs
			local LeaElite = UnitClassification(LeaTipUnit)
			if (LeaElite) then
				if LeaElite == "elite" then LeaElite = "(Elite)"
				elseif LeaElite == "rare" then LeaElite = "|c" .. LeaTipRareCol .. "(Rare)"
				elseif LeaElite == "rareelite" then LeaElite = "|c" .. LeaTipRareCol .. "(Rare Elite)"
				elseif LeaElite == "worldboss" then LeaElite = "(Boss)"
				else LeaElite = nil end
				if (LeaElite) then
					LeaTipIdata = LeaTipIdata .. LeaElite
				end
			end
			repline(LeaTipMline, LeaTipIdata)
		end

----------------------------------------------------------------------

		-- Backdrops
		if (LeaTipOptionsLC["LeaTipOptBackdrop"]) == "On" or LeaTipOptionsLC["LeaTipOptBackHost"] == "On" or LeaTipOptionsLC["LeaTipOptBackSame"] == "On" then
			local LeaFaction = UnitFactionGroup(LeaTipUnit)
			if UnitCanAttack("player",LeaTipUnit) and not (UnitIsDeadOrGhost(LeaTipUnit)) and not (LeaFaction == nil) and not (LeaFaction == UnitFactionGroup("player")) then
				if (LeaPlayer) and LeaTipOptionsLC["LeaTipOptBackHost"] == "On" then
					GameTooltip:SetBackdropColor(LeaTipXcolr.r, LeaTipXcolr.g, LeaTipXcolr.b);
				elseif (LeaTipOptionsLC["LeaTipOptBackdrop"]) == "On" then
						GameTooltip:SetBackdropColor(0.5, 0.0, 0.0);
				end
			else
				if (LeaPlayer) and LeaTipOptionsLC["LeaTipOptBackSame"] == "On" then
					GameTooltip:SetBackdropColor(LeaTipXcolr.r, LeaTipXcolr.g, LeaTipXcolr.b);
				elseif (LeaTipOptionsLC["LeaTipOptBackdrop"]) == "On" then
					GameTooltip:SetBackdropColor(0, 0, 0.5);
				end
			end
		end

----------------------------------------------------------------------

		--	Show target
		if LeaTipOptionsLC["LeaTipOptTarget"] == "On" then
			local target = UnitName(LeaTipUnit.."target");
			if target == nil or target == "" then return end
			if (UnitIsUnit(target, "player")) then target = ("|c12ff4400YOU") end

			-- Show target in class color
			if LeaTipOptionsLC["LeaTipOptClassTarget"] == "On" then
				if not (UnitIsUnit(target, "player")) and (UnitIsPlayer(LeaTipUnit.."target")) and (LeaTipOptionsLC["LeaTipOptClassTarget"] == "On") then
					local _,tar_g = UnitClassBase(LeaTipUnit.."target");
					local LeaTcolr = RAID_CLASS_COLORS[tar_g]
					local LeaTcolr = "|cff" .. string.format('%02x%02x%02x',LeaTcolr.r * 255, LeaTcolr.g * 255, LeaTcolr.b * 255)
					target = (LeaTcolr .. target)
				end
			end
			GameTooltip:AddLine("Target: " .. target)
		end
	end

----------------------------------------------------------------------
-- 	Events
----------------------------------------------------------------------

	local function eventHandler(self, event, arg1, ...)

		-- Load saved variables or set to default if none exist
		if (event == "ADDON_LOADED" and arg1 == "Leatrix_Tooltip") then
			LeaTipOptionsLC["LeaTipOptTitle"] 		= "Off"
			LeaTipOptionsLC["LeaTipOptMouse"] 		= "Off"
			LeaTipOptionsLC["LeaTipOptScaleSlider"] = "1.25"
			LeaTipOptionsLC["LeaTipOptScaleCheck"] 	= "Off"
			LeaTipOptionsLC["LeaTipOptBackdrop"] 	= "On"
			LeaTipOptionsLC["LeaTipOptRealm"] 		= "On"
			LeaTipOptionsLC["LeaTipOptClassName"] 	= "On"
			LeaTipOptionsLC["LeaTipOptBackSame"] 	= "Off"
			LeaTipOptionsLC["LeaTipOptBackHost"] 	= "Off"
			LeaTipOptionsLC["LeaTipOptTarget"] 		= "On"
			LeaTipOptionsLC["LeaTipOptClassTarget"] = "On"
			LeaTipOptionsLC["Leatrix_XOffset"] 		= "0"
			LeaTipOptionsLC["Leatrix_YOffset"] 		= "-30"
			LeaTipOptionsLC["Leatrix_Anchor"] 		= "TOPLEFT"
			LeaTipOptionsLC["Leatrix_Relative"] 	= "TOPLEFT"
			LeaTipOptionsLC["LeaTipOptCombat"] 		= "Off"
			LeaTipOptionsLC["LeaTipOptRace"] 		= "On"
			LeaTipOptionsLC["LeaTipOptEnable"] 		= "On"
			LeaTipOptionsLC["LeaTipOptMobType"] 	= "On"
			LeaTipOptionsLC["LeaTipOptGuild"] 		= "On"
			DEFAULT_CHAT_FRAME:AddMessage("Leatrix Tooltip loaded successfully.", 1.0,0.85,0.0)
			wipe(LeaTipOptionsDB)
			LeaTipSetScale();
		end

		-- Save locals back to globals on logout
		if (event == "PLAYER_LOGOUT") then
			--[[
			LeaTipOptionsDB["LeaTipOptTitle"] 			= LeaTipOptionsLC["LeaTipOptTitle"]
			LeaTipOptionsDB["LeaTipOptMouse"] 			= LeaTipOptionsLC["LeaTipOptMouse"]
			LeaTipOptionsDB["LeaTipOptScaleSlider"] 	= LeaTipOptionsLC["LeaTipOptScaleSlider"]
			LeaTipOptionsDB["LeaTipOptScaleCheck"] 		= LeaTipOptionsLC["LeaTipOptScaleCheck"]
			LeaTipOptionsDB["LeaTipOptBackdrop"] 		= LeaTipOptionsLC["LeaTipOptBackdrop"]
			LeaTipOptionsDB["LeaTipOptRealm"] 			= LeaTipOptionsLC["LeaTipOptRealm"]
			LeaTipOptionsDB["LeaTipOptClassName"] 		= LeaTipOptionsLC["LeaTipOptClassName"]
			LeaTipOptionsDB["LeaTipOptBackSame"] 		= LeaTipOptionsLC["LeaTipOptBackSame"]
			LeaTipOptionsDB["LeaTipOptBackHost"] 		= LeaTipOptionsLC["LeaTipOptBackHost"]
			LeaTipOptionsDB["Leatrix_XOffset"] 			= LeaTipOptionsLC["Leatrix_XOffset"]
			LeaTipOptionsDB["Leatrix_YOffset"] 			= LeaTipOptionsLC["Leatrix_YOffset"]
			LeaTipOptionsDB["Leatrix_Anchor"] 			= LeaTipOptionsLC["Leatrix_Anchor"]
			LeaTipOptionsDB["Leatrix_Relative"]			= LeaTipOptionsLC["Leatrix_Relative"]
			LeaTipOptionsDB["LeaTipOptCombat"] 			= LeaTipOptionsLC["LeaTipOptCombat"]
			LeaTipOptionsDB["LeaTipOptTarget"] 			= LeaTipOptionsLC["LeaTipOptTarget"]
			LeaTipOptionsDB["LeaTipOptClassTarget"] 	= LeaTipOptionsLC["LeaTipOptClassTarget"]
			LeaTipOptionsDB["LeaTipOptRace"] 			= LeaTipOptionsLC["LeaTipOptRace"]
			LeaTipOptionsDB["LeaTipOptEnable"] 			= LeaTipOptionsLC["LeaTipOptEnable"]
			LeaTipOptionsDB["LeaTipOptMobType"] 		= LeaTipOptionsLC["LeaTipOptMobType"]
			LeaTipOptionsDB["LeaTipOptGuild"] 			= LeaTipOptionsLC["LeaTipOptGuild"]
			]]--
		end
	end

----------------------------------------------------------------------
-- Slash commands
----------------------------------------------------------------------

--	Slash command handler
	local function slashCommand(str)
		local key, var1, var2, var3, var4 = strsplit(" ", string.lower(str))
		if str == '' then
			InterfaceOptionsFrame_OpenToCategory("Leatrix Tooltip");
		elseif str == "reset" then
			LeaTipReset();
		elseif str == 'help' then DEFAULT_CHAT_FRAME:AddMessage("Leatrix Tooltip\n/ltt mouse - Toggle mouse anchor\n/ltt hide - Hide all tooltips\n/ltt show - Show all tooltips\n/ltt reset - Reset position\n/ltt pos <x> <y> <anchor> <relative> - Set position manually", r,g,b)
		elseif str == "hide" then 
			LeaTipVanish("hide");
			DEFAULT_CHAT_FRAME:AddMessage("All tooltips will now be hidden.", r,g,b)
		elseif str == "show" then 
			LeaTipVanish("show");
			DEFAULT_CHAT_FRAME:AddMessage("All tooltips will now be shown.", r,g,b)
		elseif str == "LeaTipOptMouse" then
			if LeaTipOptionsLC["LeaTipOptMouse"] == "On" then LeaTipOptionsLC["LeaTipOptMouse"] = "Off"
			elseif LeaTipOptionsLC["LeaTipOptMouse"] == "Off" then LeaTipOptionsLC["LeaTipOptMouse"] = "On" end
		elseif key == "pos" then
			if not (var1) or not (var2) or not (var3) or not (var4) then
				DEFAULT_CHAT_FRAME:AddMessage("Wrong number of arguments.  To position a frame, enter '/ltt pos <x> <y> <anchor> <relative>'.\neg. /ltt pos 100 100 top bottomright.",  r,g,b)
			elseif not (var1:match("%d+")) or not (var2:match("%d+")) or not (var3:match("%a+")) or not (var4:match("%a+")) then
				DEFAULT_CHAT_FRAME:AddMessage("Invalid format.  To position a frame, enter '/ltt pos <x> <y> <anchor> <relative>'.\neg. /ltt pos 100 100 top bottomright",  r,g,b)
			else
				LeaTipOptionsLC["Leatrix_XOffset"] = var1;
				LeaTipOptionsLC["Leatrix_YOffset"] = var2;
				LeaTipOptionsLC["Leatrix_Anchor"] = var3;
				LeaTipOptionsLC["Leatrix_Relative"] = var4;
				DEFAULT_CHAT_FRAME:AddMessage("Tooltip position saved to " .. LeaTipOptionsLC['Leatrix_XOffset'] .. ", " .. LeaTipOptionsLC['Leatrix_YOffset'] .. ".",  r,g,b)
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage("Invalid command.  Type '/ltt help' for help.",  r,g,b)
		end
	end

--	Create frames so we can watch events
	local frame = CreateFrame("FRAME", "Leatrix_Tooltip");
	frame:RegisterEvent("ADDON_LOADED");
	frame:RegisterEvent("PLAYER_LOGOUT");
	frame:SetScript("OnEvent", eventHandler);

	-- Tooltip hook and events
	GameTooltip:HookScript("OnTooltipSetUnit", function(self) ShowTip(true) end)
	SLASH_Leatrix_Tooltip1 = '/ltt'
	SlashCmdList["Leatrix_Tooltip"] = function(str) slashCommand(string.lower(str)) end

----------------------------------------------------------------------
-- 	Options panel (last but not least)
----------------------------------------------------------------------
	
-- 	Define the options panel
	local LeaTipOptionsPanel = CreateFrame('Frame', 'Leatrix_Tooltip_Options', UIParent)

	function LeaTipOptionsPanel:OptionsPanel()
		self.name = "Leatrix Tooltip"

		local function OptionsTitle(title,subtitle)
			local text = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
			text:SetPoint('TOPLEFT', 16, -16)
			text:SetText(title)

			local subtext = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
			subtext:SetHeight(32)
			subtext:SetPoint('TOPLEFT', text, 'BOTTOMLEFT', 0, -8)
			subtext:SetPoint('RIGHT', self, -32, 0)
			subtext:SetNonSpaceWrap(true)
			subtext:SetJustifyH('LEFT')
			subtext:SetJustifyV('TOP')
			subtext:SetText(subtitle)
		end
 
		local function OptionsText(title,x,y)
			local text = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
			text:SetPoint("TOPLEFT",x,y)
			text:SetText(title)
		end
	 
		-- Define slider control
		local function LeaSlider(LeaTipSliderName,field,caption,low, high, step, x,y, form, LeaTipSliderLText, LeaTipSliderRText)
			local function slider_OnMouseWheel(self, arg1)
				local step = self:GetValueStep() * arg1
				local value = self:GetValue()
				local minVal, maxVal = self:GetMinMaxValues()
				if step > 0 then
					self:SetValue(min(value+step, maxVal))
				else
					self:SetValue(max(value+step, minVal))
				end
			end

			local LeaTipSliderName = CreateFrame('slider', field, LeaTipOptionsPanel, 'OptionssliderTemplate')
			getglobal(LeaTipSliderName:GetName() .. 'Text'):SetText(caption)

			LeaTipSliderName:SetScript('OnShow', function(self)
				self.onShow = true
				self:SetValue(LeaTipOptionsLC[field])
				self.onShow = nil
			end)

			-- Change the value when you drag the slider
			LeaTipSliderName:SetScript('OnValueChanged', function(self, value)
				self.valText:SetText(format(form, value))
				LeaTipOptionsLC[field] = value
				LeaTipSetScale();
			end)

			-- Setup slider layout
			LeaTipSliderName:SetMinMaxValues(low, high)
			LeaTipSliderName:SetValueStep(step)
			LeaTipSliderName:EnableMouseWheel(true)
			LeaTipSliderName:SetScript('OnMouseWheel', slider_OnMouseWheel)
			LeaTipSliderName:SetPoint('TOPLEFT', x,y)
			LeaTipSliderName.tooltipText = "Drag the slider to set the tooltip scale."
			--getglobal(LeaTipSliderName:GetName() .. 'Text'):SetText('Tooltip Scale');
			getglobal(LeaTipSliderName:GetName() .. 'Low'):SetText(LeaTipSliderLText);
			getglobal(LeaTipSliderName:GetName() .. 'High'):SetText(LeaTipSliderRText);
			LeaTipSliderName:SetWidth(100)
			LeaTipSliderName:SetHeight(20)

			-- Show text value next to the slider
			local text = LeaTipSliderName:CreateFontString(nil, 'BACKGROUND')
			text:SetFontObject('GameFontHighlight')
			text:SetPoint('LEFT', LeaTipSliderName, 'RIGHT', 12, 0)
			LeaTipSliderName.valText = text
			text:SetText(string.format("%.2f", LeaTipSliderName:GetValue()))
		end

		-- Define Checkbox control
		local function LeaTipFuncCheckbox(field,caption,x,y,tip)
			local LeaTipCheckbox = CreateFrame('CheckButton', field, self, 'ChatConfigCheckButtonTemplate')
			getglobal(LeaTipCheckbox:GetName() .. 'Text'):SetText(caption)
			LeaTipCheckbox:SetScript('OnShow', function(self) self:SetChecked(LeaTipOptionsLC[field]) end)
			LeaTipCheckbox:SetScript('OnClick', function(self)
				if LeaTipCheckbox:GetChecked() == nil then
					LeaTipOptionsLC[field] = "Off"
				elseif LeaTipCheckbox:GetChecked() == 1 then
					if field == "LeaTipOptBackSame" and LeaTipCheckbox:GetChecked() == "On" and not (LeaTipOptionsLC["LeaTipOptBackdrop"] == "On") then return end
					LeaTipOptionsLC[field] = "On"
				end
				if field == "LeaTipOptScaleCheck" then LeaTipSetScale(); end
			end)
			LeaTipCheckbox:SetPoint("TOPLEFT",x, y)
			LeaTipCheckbox.tooltip = tip;
		end

		-- Populate the options panel
		OptionsTitle("Leatrix Tooltip",(select(3, GetAddOnInfo("Leatrix_Tooltip"))));
		OptionsText("Tooltip Details",16,-72);
		LeaTipFuncCheckbox("LeaTipOptTitle", 		"Show player title", 16, -92, "Shows the target's title (if it's a player), such as Leatrix the Latency Fixer!")
		LeaTipFuncCheckbox("LeaTipOptRealm", 		"Show player realm", 16, -112, "Shows the target's realm (if it's different from your own).")
		LeaTipFuncCheckbox("LeaTipOptRace", 		"Show player race", 16, -132, "Shows the target's race (if it's a player).")
		LeaTipFuncCheckbox("LeaTipOptMobType", 		"Show creature type", 16, -152, "Shows the target's creature type (such as 'Humanoid' or 'Beast').")

		OptionsText("Colors",16,-192);
		LeaTipFuncCheckbox("LeaTipOptClassName", 	"Name in class color", 16, -212, "Shows player names in standard class colors.  If unchecked, players and NPCs will be shown in blue or green depending on PvP status.")
		LeaTipFuncCheckbox("LeaTipOptGuild", 		"Guild name in color", 16, -232, "Shows guild names in purple.")

		OptionsText("Backdrops",16,-272);
		LeaTipFuncCheckbox("LeaTipOptBackdrop", 	"Color backdrops", 16, -292, "Shows unit backdrops in dark blue (for neutral or non-hostile enemy players) or dark red (for hostile enemy players).")
		LeaTipFuncCheckbox("LeaTipOptBackSame", 	"Friendly class backdrop", 16, -312, "Shows friendly player backdrops in class color.  This includes non-hostile enemy players who are not flagged for PvP.")
		LeaTipFuncCheckbox("LeaTipOptBackHost", 	"Enemy class backdrop", 16, -332, "Shows enemy player backdrops in class color.  This only applies to hostile enemy players who are flagged for PvP.")

		OptionsText("Target of Target",200,-72);
		LeaTipFuncCheckbox("LeaTipOptTarget", 		"Show target of target", 200, -92, "Shows the target's target when you first hover over a unit.  This is not refreshed until you change target.")
		LeaTipFuncCheckbox("LeaTipOptClassTarget", 	"Show target in class color", 200, -112, "Shows the target's target in class color (if it's a player).")

		OptionsText("Miscellaneous",200,-152);
		LeaTipFuncCheckbox("LeaTipOptEnable",		"Enable Leatrix Tooltip", 200, -172, "If unchecked, tooltips will not be altered at all (other than scale), allowing you to see the exact changes which Leatrix Tooltip makes.")
		LeaTipFuncCheckbox("LeaTipOptCombat", 		"Hide unit tooltips in combat", 200, -192, "Hides unit tooltips while you are in combat.  This only applies to tooltips which Leatrix Tooltip has actually processed, not spell buttons or objects.")

		OptionsText("Tooltip Layout",200,-232);
		LeaTipFuncCheckbox("LeaTipOptMouse", 		"Anchor tooltip to cursor", 200, -252, "Anchors the tooltip to the cursor instead of a fixed point on the screen.")
		LeaTipFuncCheckbox("LeaTipOptScaleCheck", 	"Rescale the tooltip", 200, -272, "Check this box and rescale the tooltip using the slider below.  If unchecked, the default size (1.00) will be used.")
		LeaSlider("LeaTipScaleSlider",				"LeaTipOptScaleSlider","",0.50, 3.00, 0.05, 230, -296,"%.2f", "0.50", "3.00")

		local function LeaTipButton(LeaTipBtnName,LeaTipBText,LeaTipBWidth,LeaTipBHeight,LeaTipBAlpha,LeaTipBAnchor,LeaTipBX,LeaTipBY,LeaTipBClicks)
			local LeaTipBtnName = CreateFrame("Button", LeaTipBtnName, self, "UIPanelButtonTemplate") 
			LeaTipBtnName:SetWidth(LeaTipBWidth)
			LeaTipBtnName:SetHeight(LeaTipBHeight) 
			LeaTipBtnName:SetAlpha(LeaTipBAlpha)
			LeaTipBtnName:SetPoint(LeaTipBAnchor, LeaTipBX, LeaTipBY)
			LeaTipBtnName:SetText(LeaTipBText) 
			LeaTipBtnName:RegisterForClicks(LeaTipBClicks) 
		end

		LeaTipButton("LeaTipBtnDefault", "Set Defaults", 130, 25, 1.0, "BOTTOMLEFT", 10, 10, "AnyUp")	
		LeaTipBtnDefault:SetScript("OnClick", function() 
			LeaTipOptionsLC["LeaTipOptTitle"] = "Off"
			LeaTipOptionsLC["LeaTipOptMouse"] = "Off"
			LeaTipOptionsLC["LeaTipOptScaleSlider"] = "1.25"
			LeaTipOptionsLC["LeaTipOptScaleCheck"] = "Off"
			LeaTipOptionsLC["LeaTipOptBackdrop"] = "On"
			LeaTipOptionsLC["LeaTipOptRealm"] = "On"
			LeaTipOptionsLC["LeaTipOptClassName"] = "On"
			LeaTipOptionsLC["LeaTipOptBackSame"] = "Off"
			LeaTipOptionsLC["LeaTipOptBackHost"] = "Off"
			LeaTipOptionsLC["LeaTipOptCombat"] = "Off"
			LeaTipOptionsLC["LeaTipOptTarget"] = "On"
			LeaTipOptionsLC["LeaTipOptClassTarget"] = "On"
			LeaTipOptionsLC["LeaTipOptRace"] = "On"
			LeaTipOptionsLC["LeaTipOptEnable"] = "On"
			LeaTipOptionsLC["LeaTipOptMobType"] = "On"
			LeaTipOptionsLC["LeaTipOptGuild"] = "On"
			DEFAULT_CHAT_FRAME:AddMessage("All settings have been reset.", r,g,b)
			LeaTipOptionsPanel:Hide();
			LeaTipOptionsPanel:Show();
			LeaTipSetScale();
		end)

		LeaTipButton("LeaTipBtnReset", "Reset Position", 130, 25, 1.0, "BOTTOMLEFT", 140, 10, "AnyUp")	
		LeaTipBtnReset:SetScript("OnClick", function() 
			LeaTipReset();
		end)

		LeaTipButton("LeaTipBtnMover", "Move Tooltip", 130, 25, 1.0, "BOTTOMLEFT", 270, 10, "AnyUp")	
		LeaTipBtnMover:SetScript("OnClick", function() 
			InterfaceOptionsFrame:Hide();
			LeaTipFuncMove();
		end)

		-- Add panel to interface options    
		InterfaceOptions_AddCategory(self) 
	end

	-- 	Show panel
	LeaTipOptionsPanel:OptionsPanel();
