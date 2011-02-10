-- credits to: Edgerin for movablebags

local frame=CreateFrame("FRAME","FooAddonFrame");

Bags_Positions={
	[1]={"CENTER",0,200},
	[2]={"TOPRIGHT",0,0},
	[3]={"TOPRIGHT",-190,0},
	[4]={"TOPRIGHT",-190,-280},
	[5]={"TOPRIGHT",0,-280},

	[6]={"BOTTOMLEFT",250,300},
	[7]={"BOTTOMLEFT",450,300},
	[8]={"BOTTOMLEFT",80,270},
	[9]={"BOTTOMLEFT",280,270},
	[10]={"BOTTOMLEFT",480,270},
	[11]={"BOTTOMLEFT",500,240},
	[12]={"BOTTOMLEFT",500,240},
	[13]={"BOTTOMLEFT",500,240},
};

frame:RegisterEvent("PLAYER_ENTERING_WORLD");

function My_updateContainerFrameAnchors()
	for i=1,NUM_CONTAINER_FRAMES,1 do
		local containerFrame=getglobal("ContainerFrame"..i);
		local pos=Bags_Positions[i]
		containerFrame:SetPoint(pos[1],pos[2],pos[3]);
		containerFrame:SetScale(0.75);
	end

	local frame = ContainerFrame1

	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart",frame.StartMoving)
	frame:SetScript("OnDragStop",frame.StopMovingOrSizing)

end


local function eventHandler(self,event,...)

	updateContainerFrameAnchors=My_updateContainerFrameAnchors;

end
frame:SetScript("OnEvent",eventHandler);

