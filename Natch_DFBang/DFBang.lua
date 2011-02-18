----------------------------------------------------------------------------
-- DFBang by Natch (natch@valsta.nu) 
----------------------------------------------------------------------------
-- Configuration

-- Set this to true if you want the addon to raise the volume for the sound
-- playback.
local wantLoudness   = false;
local loudnessVolume = 50; -- Volume in percent
----------------------------------------------------------------------------
-- Don't edit below unless you know what you're doing.
----------------------------------------------------------------------------
local f = CreateFrame("Frame", "DFBang");
f:RegisterEvent("LFG_PROPOSAL_SHOW");
f.tslu    = 0;
f.sndFile = "Interface\\AddOns\\Natch_DFBang\\bang.mp3";
f.sndLen  = 2.4;
f.cvON    = 1;
f.cvOFF   = 0;
f.cvSND   = "Sound_EnableAllSound";
f.cvBGS   = "Sound_EnableSoundWhenGameIsInBG";
f.cvVOL   = "Sound_MasterVolume";
f.cvSFX   = "Sound_EnableSFX";

f:SetScript("OnEvent", function(self, event, ...)
	self:PlaySound();
end)

f:SetScript("OnUpdate", function(self, elapsed)
	self.tslu = self.tslu + elapsed;

	if(self.tslu > self.sndLen) then
		self:StopSound();
		self.tslu = 0;
	end
end)

function f:PlaySound()
	-- Original mute/unmute code borrowed from NPCScan by Saiket
	if(not GetCVarBool(self.cvSND)) then
		self.SoundEnableChanged = true;
		SetCVar(self.cvSND, self.cvON);
	end

	if(not GetCVarBool(self.cvBGS)) then
		self.SoundInBGChanged = true;
		SetCVar(self.cvBGS, self.cvON);
	end

	if(not GetCVarBool(self.cvSFX)) then
		self.SoundSFXChanged = true;
		SetCVar(self.cvSFX, self.cvON);
	end

	if(wantLoudness) then
		self.oldVol = GetCVar(self.cvVOL);
		SetCVar(self.cvVOL, loudnessVolume/100);
	end

	self.tslu = 0;
	PlaySoundFile(self.sndFile);
	self.playing = true;
end

function f:StopSound()
	if(not self.playing) then
		return;
	end

	if(wantLoudness == true) then
		SetCVar(self.cvVOL, self.oldVol);
	end

	if(self.SoundSFXChanged) then
		SetCVar(self.cvSFX, self.cvOFF);
	end

	if(self.SoundInBGChanged) then
		SetCVar(self.cvBGS, self.cvOFF);
	end

	if(self.SoundEnableChanged) then
		SetCVar(self.cvSND, self.cvOFF);
	end

	self.playing = false;
end

