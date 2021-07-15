local frame = CreateFrame('Frame');
frame:RegisterEvent('CHAT_MSG_LOOT');
frame:RegisterEvent('PLAYER_LOGIN');
frame:RegisterEvent('PLAYER_ENTERING_WORLD');
frame:RegisterEvent('BANKFRAME_OPENED');
frame:RegisterEvent('BANKFRAME_CLOSED');
frame:RegisterEvent('MERCHANT_SHOW');
frame:RegisterEvent('MERCHANT_CLOSED');
frame:RegisterEvent('AUCTION_HOUSE_SHOW');
frame:RegisterEvent('AUCTION_HOUSE_CLOSED');
frame:RegisterEvent('VIGNETTE_MINIMAP_UPDATED');
frame:Hide();

local TOYS={}
TOYS[35275] = 25; -- orbe-des-sindorei
TOYS[64651] = 26; -- amulette-de-feu-follet
TOYS[116115] = 27; -- ailes-flamboyantes
TOYS[164375] = 28; -- banane-de-mauvais-mojo
TOYS[134022] = 29; -- beau-chapeau-de-burgy-cœur-noir
TOYS[44719] = 30; -- bière-frénécœur
TOYS[179393] = 31; -- miroir-des-rêves-envieux
TOYS[163736] = 32; -- visage-spectral
TOYS[118937] = 33; -- tresse-de-gamon
TOYS[88566] = 34; -- sac-des-horreurs-de-krastinov
TOYS[122117] = 35; -- plume-maudite-dikzan
TOYS[128807] = 36; -- pièce-aux-nombreuses-faces
TOYS[147843] = 37; -- cape-de-rechange-de-sira
TOYS[141862] = 38; -- particule-de-lumière
TOYS[64646] = 39; -- os-de-transformation
TOYS[1973] = 40; -- orbe-de-tromperie
TOYS[71259] = 41; -- médaillon-de-leyara
TOYS[163750] = 42; -- kostume-de-kovork
TOYS[127696] = 43; -- miroir-de-mascotte-magique
TOYS[122283] = 44; -- mémoire-sacrée-de-rukhmar
TOYS[134007] = 45; -- eternal-black-diamond-ring
TOYS[129149] = 46; -- charme-de-la-porte-de-la-mort
TOYS[127659] = 47; -- chapeau-de-boucanier-de-fer-fantomatique
TOYS[156833] = 48; -- siffletimbre-de-katy

local TRACKED_ACHIEVEMENTS = {
	11573,
	8101,
	13638,
	12104,
	12026
}

local function OpenAllBagsAndBanks()
	local max = NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
	for i=0, max, 1 do
		if (IsBagOpen(i) == nil) then
			OpenBag(i, true)
		else
			CloseBag(i, true)
			OpenBag(i, true)
		end
	end
end

local function CloseAllBagsAndBanks()
	local max = NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
	for i=0, max, 1 do
		CloseBag(i, true)
	end
end

local function StartsWith(str, token)
	return str:sub(1, #token) == token
end

frame:SetScript('OnEvent', function(self, event, ...)

	if (event == 'PLAYER_LOGIN') then
		local texture = PlayerFrame:CreateTexture(nil, 'BORDER');
		texture:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame-Elite');
		texture:SetAllPoints(PlayerFrame);
		texture:SetTexCoord(1, 0.09375, 0, 0.78125);

		Minimap:SetZoom(0);
		MinimapZoomIn:Hide();
		MinimapZoomOut:Hide();

		PlayerFrame:ClearAllPoints();
		PlayerFrame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 0, -4);
		FocusFrame:SetUserPlaced(true);

		TargetFrame:ClearAllPoints();
		TargetFrame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 210, -4);
		TargetFrame:SetUserPlaced(true);
	end

	if (event == 'PLAYER_ENTERING_WORLD') then
		if (SHOW_MULTI_ACTIONBAR_1 == nil or SHOW_MULTI_ACTIONBAR_1 == false) then
			SHOW_MULTI_ACTIONBAR_1 = true;
		end

		if (SHOW_MULTI_ACTIONBAR_2 == nil or SHOW_MULTI_ACTIONBAR_2 == false) then
			SHOW_MULTI_ACTIONBAR_2 = true;
		end

		if (SHOW_MULTI_ACTIONBAR_3 == nil or SHOW_MULTI_ACTIONBAR_3 == false) then
			SHOW_MULTI_ACTIONBAR_3 = true;
		end

		if (SHOW_MULTI_ACTIONBAR_4 == nil or SHOW_MULTI_ACTIONBAR_4 == false) then
			SHOW_MULTI_ACTIONBAR_4 = true;
		end

		SetCVar('multiBarRightVerticalLayout', '1');

		InterfaceOptions_UpdateMultiActionBars();
		for toy, slot in pairs(TOYS) do
			local actionType, id = GetActionInfo(slot)
			if (actionType ~= 'item' or id ~= toy) then
				DEFAULT_CHAT_FRAME:AddMessage('Updating action slot : ' .. tostring(slot) .. ' with toy ' .. tostring(id), 1, 0, 1);
				ClearCursor();
				PickupItem(toy);
				PlaceAction(slot);
				ClearCursor();
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

		for i = 1, NUM_CHAT_WINDOWS do
			SetChatWindowSize(i, 12);
		end

		CHAT_FRAME_WIDTH = 585;
		CHAT_FRAME_HEIGHT = 250;
		CHAT_FRAME_OFFSET_X = 0;
		CHAT_FRAME_OFFSET_Y = 90;

		ChatFrame1:ClearAllPoints();
		ChatFrame1:SetWidth(CHAT_FRAME_WIDTH);
		ChatFrame1:SetHeight(CHAT_FRAME_HEIGHT);
		ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', CHAT_FRAME_OFFSET_X, CHAT_FRAME_OFFSET_Y);
		ChatFrame1:SetUserPlaced(true);

		QuickJoinToastButton:Hide();
	end

	if (event == 'BANKFRAME_OPENED') then
		OpenAllBagsAndBanks();
	end

	if (event == 'BANKFRAME_CLOSED') then
		CloseAllBagsAndBanks();
	end

	if (event == 'MERCHANT_SHOW') then
		OpenAllBagsAndBanks();
	end

	if (event == 'MERCHANT_CLOSED') then
		CloseAllBagsAndBanks();
	end

	if (event == 'AUCTION_HOUSE_SHOW') then
		OpenAllBagsAndBanks();
	end

	if (event == 'AUCTION_HOUSE_CLOSED') then
		CloseAllBagsAndBanks();
	end

	if (event == 'VIGNETTE_MINIMAP_UPDATED') then
		local onMinimap = select(2, ...);
		if (onMinimap == false) then
			return
		end

		local guid = select(1, ...);
		local info = C_VignetteInfo.GetVignetteInfo(guid)
		if (info == nil) then
			return
		end

		local name = info.name
		local atlasName = info.atlasName

		if (atlasName == 'VignetteLoot' or atlasName == 'VignetteLootElite') then
			PlaySound(SOUNDKIT.RAID_WARNING, 'Master');
			DEFAULT_CHAT_FRAME:AddMessage('Found treasure : ' .. name, 0.949, 0.109, 0.796);
		elseif (atlasName == 'VignetteEventElite' or atlasName == 'VignetteKill') then
			PlaySound(SOUNDKIT.RAID_WARNING, 'Master');
			DEFAULT_CHAT_FRAME:AddMessage('Found elite : ' .. name, 0.949, 0.109, 0.796);
		elseif (atlasName == 'QuestObjective') then
			-- Do nothing
		elseif (atlasName == 'nazjatar-nagaevent') then
			-- Do nothing
		elseif (atlasName == 'Object') then
			-- Do nothing
		elseif (atlasName == 'CrossedFlags') then
			-- Do nothing
		elseif (atlasName == 'poi-soulspiritghost') then
			-- Do nothing
		elseif (atlasName == 'VignetteEvent') then
			-- Do nothing
		elseif (atlasName == 'SmallQuestBang') then
			-- Do nothing
		elseif (atlasName == 'TeleportationNetwork-32x32') then
			-- Do nothing
		elseif (atlasName == 'ArtifactQuest') then
			-- Do nothing
		elseif (atlasName == 'DungeonSkull') then
			-- Do nothing
		elseif (atlasName == 'Portail de Néant instable') then
			-- Do nothing
		elseif (atlasName == 'VignetteKillElite') then
			-- Do nothing
		elseif (atlasName == 'HordeSymbol') then
			-- Do nothing
		elseif (atlasName == 'AllianceSymbol') then
			-- Do nothing
		elseif (atlasName == 'PortalPurple') then
			-- Do nothing
		elseif (atlasName == 'DemonInvasion5') then
			-- Do nothing
		elseif (StartsWith(atlasName, 'Warfront-')) then
			-- Do nothing
		elseif (StartsWith(atlasName, 'Islands-')) then
		-- Do nothing
		else
			DEFAULT_CHAT_FRAME:AddMessage('Unknown vignette type : ' .. atlasName .. ' -> ' .. name, 1, 0, 0);
		end
	end

	if (event == 'CHAT_MSG_LOOT') then
		local text = select(1, ...);
		local id = string.match(text, 'Hitem:(.-):');
		if id == nil then
			return
		end

		local eventPlayerName  = select(2, ...);

		local playerName = UnitName('Player');
		local realmName = string.gsub(GetRealmName(), '%s+', '');
		local fullPlayerName = playerName .. '-' .. realmName;

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
			PlaySound(SOUNDKIT.AUCTION_WINDOW_OPEN, 'Master');
			DEFAULT_CHAT_FRAME:AddMessage('Bind on equip loot : Looted ' .. itemName .. ' type ' .. itemType, 1, 0, 1);
		end
	end

end)
