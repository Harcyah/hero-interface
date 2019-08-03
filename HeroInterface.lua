local frame = CreateFrame("Frame");
frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("BANKFRAME_OPENED");
frame:RegisterEvent("AUCTION_HOUSE_SHOW");
frame:RegisterEvent("VIGNETTE_MINIMAP_UPDATED");
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

local TRACKED_ACHIEVEMENTS = {
	9527,
	9598,
	9824,
	9900,
	10167,
	11738,
	12028,
	12078
}

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
		
		local trackedAchievements = { GetTrackedAchievements() }
	    for i = 1, #trackedAchievements do
			local achievementID = trackedAchievements[i];
			RemoveTrackedAchievement(achievementID);
		end
		
		for i = 1, #TRACKED_ACHIEVEMENTS do
			id = TRACKED_ACHIEVEMENTS[i];
			AddTrackedAchievement(id);
		end
	end
	
	if (event == "BANKFRAME_OPENED") then
		OpenAllBags();
	end
	
	if (event == "AUCTION_HOUSE_SHOW") then
		OpenAllBags();
	end
	
	if (event == "VIGNETTE_MINIMAP_UPDATED") then
		local guid = select(1, ...);
		local onMinimap = select(2, ...);
		if (onMinimap) then
			local info = C_VignetteInfo.GetVignetteInfo(guid)
			PlaySound(SOUNDKIT.RAID_WARNING, "Master");
			DEFAULT_CHAT_FRAME:AddMessage('Rare mob alert -> ' .. info.name .. ' !!', 1, 0, 1);
		end
	end
	
	if (event == "CHAT_MSG_LOOT") then
		local text = select(1, ...);
		local id = string.match(text, "Hitem:(.-):");
		local eventPlayerName  = select(2, ...);
			
		local playerName = UnitName("Player");
		local realmName = string.gsub(GetRealmName(), "%s+", "");
		local fullPlayerName = playerName .. "-" .. realmName;
		
		local itemName = select(1, GetItemInfo(id));
		local itemRarity = select(3, GetItemInfo(id));
		local itemType = select(6, GetItemInfo(id));
		local itemSlot = select(9, GetItemInfo(id));
		local itemBind = select(14, GetItemInfo(id));
		
		if (itemRarity == nil) then
			itemRarity = 'N/A'
		end
		
		if (itemType == nil) then
			itemType = 'N/A'
		end
		
		if (itemSlot == nil) then
			itemSlot = 'N/A'
		end
		
		if (itemBind == nil) then
			itemBind = 'N/A'
		end
		
		if (fullPlayerName == eventPlayerName and itemRarity >= 3 and itemBind == 2) then
			PlaySound(SOUNDKIT.AUCTION_WINDOW_OPEN, "Master");
			DEFAULT_CHAT_FRAME:AddMessage('Bind on equip loot : Looted ' .. itemName .. ' type ' .. itemType, 1, 0, 1);
		end
	end
		
end)
