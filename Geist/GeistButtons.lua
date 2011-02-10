-- Local Table
local aName, aTable = ...

--[[
This file is used to set the default button ids for Geist. These buttons do not conflict with known stance/form/stealth bars.
These settings are not ideal, but are the best compromise I could come up with short of writing virtual action buttons.

Default Blizzard IDs:
1-12 Main Bar (Unused by Warriors)
13-24 Second Bar
25-36 Side Bar 1
37-48 Side Bar 2
49-60 Bottom Right Bar
61-72 Bottom Left Bar
73-84 Warrior Battle, Druid Cat, Rogue Stealth, Priest Shadowform
85-96 Warrior Defensive, Druid Tree
97-108 Warrior Berserker, Druid Bear
109-120 Druid Moonkin
121-132 Possess Bar (Unusable)
]]

aTable.ButtonIDs = {
	["DEFAULT"] = {
		96, --01
		97, --02
		98, --03
		99, --04
		100, --05
		101, --06
		102, --07
		103, --08
		104, --09
		105, --10
		106, --11
		107, --12
		108, --13
		109, --14
		110, --15
		111, --16
		112, --17
		113, --18
		114, --19
		115, --20
		116, --21
		117, --22
		118, --23
		119, --24
		120, --25
	},
	["DRUID"] = {
		48, --01
		49, --02
		50, --03
		51, --04
		52, --05
		53, --06
		54, --07
		55, --08
		56, --09
		57, --10
		58, --11
		59, --12
		60, --13
		61, --14
		62, --15
		63, --16
		64, --17
		65, --18
		66, --19
		67, --20
		68, --21
		69, --22
		70, --23
		71, --24
		72, --25
	},
	["WARRIOR"] = {
		1, --01
		2, --02
		3, --03
		4, --04
		5, --05
		6, --06
		7, --07
		8, --08
		9, --09
		10, --10
		11, --11
		12, --12
		72, --13, Pesky warriors.
		109, --14
		110, --15
		111, --16
		112, --17
		113, --18
		114, --19
		115, --20
		116, --21
		117, --22
		118, --23
		119, --24
		120, --25
	},
}
