local frame = CreateFrame("Frame");

frame:RegisterEvent("PLAYER_LOGIN");

frame:Hide();

frame:SetScript("OnEvent", function(self, event, ...)

	if (event == "PLAYER_LOGIN") then
		local texture = PlayerFrame:CreateTexture(nil, "BORDER");
		texture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite");
		texture:SetAllPoints(PlayerFrame);
		texture:SetTexCoord(1, 0.09375, 0, 0.78125);
			
		Minimap:SetZoom(0);
		MinimapZoomIn:Hide();
		MinimapZoomOut:Hide();
		
		PlayerFrame:ClearAllPoints();
		PlayerFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -4);
		FocusFrame:SetUserPlaced(true);
		
		TargetFrame:ClearAllPoints();
		TargetFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 210, -4);
		TargetFrame:SetUserPlaced(true);	
	end
	
end)
