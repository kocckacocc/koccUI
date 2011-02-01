globaldebug=false

sw=1024 --math.ceil(GetScreenWidth())
sh=768 --math.ceil(GetScreenHeight())

bsp=sw/256 --buttonsize
bs=bsp*7 --buttonspacing


--Minimap
mmposition={a="BOTTOM",x=0,y=0}
mmsize=(bsp+bs)*3-bsp
mmalpha=0.5

--Actionbars
bp={
	[1]={
		[1]={a="BOTTOMRIGHT",p="CENTER",x=sw/4,y=-sh/4+bs+bsp},
		[2]={a="BOTTOMRIGHT",p="CENTER",x=sw/4,y=-sh/4},
		[3]={a="TOPRIGHT",p="CENTER",x=sw/4,y=0},
	},
	[2]={a="BOTTOMRIGHT",p="BOTTOMRIGHT",x=0,y=0},
	[3]={a="BOTTOMRIGHT",p="BOTTOMRIGHT",x=-sw/4,y=0},
	[4]={a="BOTTOMRIGHT",p="BOTTOMRIGHT",x=-sw/4+(bs+bsp)*4,y=0},
	[5]={a="TOP",p="TOP",x=0,y=0}, --hor
	[6]={a="TOPLEFT",p="TOPLEFT",x=0,y=0}, --dump
	[7]={a="BOTTOMRIGHT",p="BOTTOMRIGHT",x=0,y=(bs+bsp)*3}, --pet
}

bar1_1alpha=1
bar1_2alpha=0.5
bar1_3alpha=0.25

bar2alpha=1
bar3alpha=1
bar4alpha=1
bar5alpha=1
petbaralpha=1
fadedalpha=0.25

--Chat
chfont={"Interface\\AddOns\\koccui\\koccmedia\\fonts\\calibri.ttf",12}

chwidth=(bs+bsp)*8
chheight=(bs+bsp)*8
chpoint="BOTTOMLEFT"
chposx=0
chposy=1

ebwidth=(bs+bsp)*12
ebheight=bs
ebpoint="CENTER"
ebanchor=UIParent
ebxpos=0
ebypos=0

--Fonts
smallfont={"Interface\\AddOns\\koccui\\koccmedia\\fonts\\visitor.ttf",12,"OUTLINE,MONOCHROME"}
medfont={"Interface\\AddOns\\koccui\\koccmedia\\fonts\\calibri.ttf",16,"OUTLINE"}
bigfont={"Interface\\AddOns\\koccui\\koccmedia\\fonts\\calibri.ttf",24,"OUTLINE"}
