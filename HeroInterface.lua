local frame = CreateFrame("Frame");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("BANKFRAME_OPENED");
frame:Hide();

local TOYS={}
TOYS[35275] = 25; -- orbe-des-sindorei
TOYS[64651] = 26; -- amulette-de-feu-follet
TOYS[118716] = 27; -- atours-de-goren
TOYS[164375] = 28; -- banane-de-mauvais-mojo
TOYS[134022] = 29; -- beau-chapeau-de-burgy-cœur-noir
TOYS[44719] = 30; -- bière-frénécœur
TOYS[66888] = 31; -- bâton-de-fourrure-et-griffes
TOYS[163736] = 32; -- visage-spectral
TOYS[118937] = 33; -- tresse-de-gamon
TOYS[88566] = 34; -- sac-des-horreurs-de-krastinov
TOYS[122117] = 35; -- plume-maudite-dikzan
TOYS[128807] = 36; -- pièce-aux-nombreuses-faces
TOYS[129113] = 37; -- pichet-dhydromel-légèrement-luminescent
TOYS[141862] = 38; -- particule-de-lumière
TOYS[64646] = 39; -- os-de-transformation
TOYS[1973] = 40; -- orbe-de-tromperie
TOYS[71259] = 41; -- médaillon-de-leyara
TOYS[163750] = 42; -- kostume-de-kovork
TOYS[127696] = 43; -- miroir-de-mascotte-magique
TOYS[122283] = 44; -- mémoire-sacrée-de-rukhmar
TOYS[127394] = 45; -- camouflage-boguelin
TOYS[129149] = 46; -- charme-de-la-porte-de-la-mort
TOYS[127659] = 47; -- chapeau-de-boucanier-de-fer-fantomatique
TOYS[156833] = 48; -- siffletimbre-de-katy

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
	
	if (event == "PLAYER_ENTERING_WORLD") then
		local update = false;
		
		if (SHOW_MULTI_ACTIONBAR_3 == nil or SHOW_MULTI_ACTIONBAR_3 == false) then
			SHOW_MULTI_ACTIONBAR_3 = true;
			update = true;
		end
		
		if (SHOW_MULTI_ACTIONBAR_4 == nil or SHOW_MULTI_ACTIONBAR_4 == false) then
			SHOW_MULTI_ACTIONBAR_4 = true;
			update = true;
		end
		
		if (GetCVar("multiBarRightVerticalLayout") ~= "1") then
			SetCVar("multiBarRightVerticalLayout", "1");
			update = true;
		end
		
		if (update == true) then
			DEFAULT_CHAT_FRAME:AddMessage('Refreshing toy bar');
			
			InterfaceOptions_UpdateMultiActionBars();
			for k, v in pairs(TOYS) do 
				ClearCursor();
				PickupItem(k)
				PlaceAction(v)
			end
		end
	end
	
	if (event == "BANKFRAME_OPENED") then
		ToggleAllBags();
	end
	
end)
