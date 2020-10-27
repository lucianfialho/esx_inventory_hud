ESX              = nil
local PlayerData = {}
local Keys = {
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
	["9"] = 163
}

local fastWeapons = {
	[1] = nil,
	[2] = nil,
	[3] = nil,
    [4] = nil,
    [5] = nil
}

Citizen.CreateThread(function()
	while ESX == nil do	
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end 
	--  Disable Weapon Wheel HUD
	while true do 
		Citizen.Wait(0)
		HideHudComponentThisFrame(19 --[[ integer ]])
		
		local playerPed = PlayerPedId()
		
		if  IsDisabledControlJustReleased(1,  Keys["1"]) then
			if fastWeapons[1] ~= nil then
				-- Setando a arma do ped para a bind marcada
				SetCurrentPedWeapon(
					playerPed --[[ Ped ]], 
					fastWeapons[1] --[[ Hash ]], 
					true --[[ boolean ]]
				)
			end
		elseif IsDisabledControlJustReleased(1, Keys["2"]) then
			if fastWeapons[2] ~= nil then
				SetCurrentPedWeapon(
					playerPed --[[ Ped ]], 
					fastWeapons[2] --[[ Hash ]], 
					true --[[ boolean ]]
				)
			end
		elseif IsDisabledControlJustReleased(1, Keys["3"]) then
			if fastWeapons[3] ~= nil then
				SetCurrentPedWeapon(
					playerPed --[[ Ped ]], 
					fastWeapons[3] --[[ Hash ]], 
					true --[[ boolean ]]
				)
			end
		elseif IsDisabledControlJustReleased(1, Keys["4"]) then
			if fastWeapons[4] ~= nil then
				SetCurrentPedWeapon(
					playerPed --[[ Ped ]], 
					fastWeapons[4] --[[ Hash ]], 
					true --[[ boolean ]]
				)
			end
		elseif IsDisabledControlJustReleased(1, Keys["5"]) then
			if fastWeapons[5] ~= nil then
				SetCurrentPedWeapon(
					playerPed --[[ Ped ]], 
					fastWeapons[5] --[[ Hash ]], 
					true --[[ boolean ]]
				)
			end
		end
	end
	DisableControlAction(2, 37, true)
	SetNuiFocus(false, false)
end)



RegisterCommand("inventory", function()

	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)

	if not IsPedFalling(playerPed) and GetPedInVehicleSeat(vehicle, -1) ~= playerPed and not IsEntityInWater(playerPed) then
		print(IsPedInVehicle(playerPed, vehicle))
		TriggerEvent('esx_inventory_hud:openInventory', IsPedInVehicle(playerPed, vehicle))
	else
		ESX.ShowNotification('Are u leigo man? Did you wanna die?')
	end
		

end)

RegisterKeyMapping("inventory", "Toggle inventory", "keyboard", "tab")

function ToogleInventory() 
	inventoryIsOpen = not inventoryIsOpen

	if inventoryIsOpen == true then
		TriggerEvent('esx_inventory_hud:openInventory')
	else
		TriggerEvent('esx_inventory_hud:closeInventory')
	end
end

function GetLoadoutData()
	ESX.PlayerData, playerWeaponData = ESX.GetPlayerData(), {}
	local playerPed = PlayerPedId()

	for k,v in ipairs(Config.Weapons) do
		local weaponHash = GetHashKey(v.name)
		
		if HasPedGotWeapon(playerPed, weaponHash, false) then
			_,hudDamage,hudSpeed,hudCapacity,hudAccuracy,hudRange = GetWeaponHudStats(weaponHash)
			local ammo, label = GetAmmoInPedWeapon(playerPed, weaponHash)

			local weaponData = {
				label = v.label,
				count = 1,
				type = 'item_weapon',
				value = v.name,
				bind = false,
				usable = false,
				rare = false,
				ammo = ammo,
				canGiveAmmo = (v.ammo ~= nil),
				canRemove = true,
				selected = false,
				giveAmmoQuantity = 0,
				openMenuWeapon = false,
				stats = {
					damage = hudDamage,
					fireRate = hudSpeed,
					ammoCapacity = hudCapacity,
					accuracy = hudAccuracy,
					range = hudRange
				}
			}

			for i,j in pairs(fastWeapons) do
				if j == v.name then
					weaponData.bind = i
				end
			end
			
			table.insert(playerWeaponData, weaponData)
		end
	end

	return playerWeaponData
end

function GetInventoryData()
	local items, currentWeight = {}, 0
	local playerPed = PlayerPedId()
	
	ESX.PlayerData = ESX.GetPlayerData()

	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.count > 0 then
			currentWeight = currentWeight + (v.weight * v.count)

			table.insert(items, {
				label = ('%s x%s'):format(v.label, v.count),
				count = v.count,
				type = 'item_standard',
				value = v.name,
				usable = v.usable,
				rare = v.rare,
				canRemove = v.canRemove,
				context = false,
				dropQuantity = 0,
				giveQuantity = 0,
				openMenu = false,
				icon = v.icon
			})
		end
	end

	for k,v in pairs(ESX.PlayerData.accounts) do
		
		if v.name ~= 'bank' and v.money > 0 then
			local formattedMoney = _U('locale_currency', ESX.Math.GroupDigits(v.money))
			local canDrop = v.name ~= 'bank'
			local icon

			if v.name == 'money' then
				icon = 'money-bill-alt'
			end

			table.insert(items, {
				label = ('%s: %s'):format(v.label, formattedMoney),
				count = v.money,
				type = 'item_account',
				value = v.name,
				usable = false,
				rare = false,
				canRemove = canDrop,
				context = false,
				icon = icon
			})
		end
	end


	return items
end

RegisterNetEvent('esx_inventory_hud:openInventory')
AddEventHandler('esx_inventory_hud:openInventory', function(pedIsVehicle)
	
	SetNuiFocus(false, false)
	DisplayRadar(false)

	local items = GetInventoryData()
	local loadout = GetLoadoutData()
	
	ESX.TriggerServerCallback('esx_inventory_hud:GetPlayerPersonalData', function(playerPersonalData)
		if not pedIsVehicle then
			DeleteSkinCam()
			loadCamera(0, 3)
		end
			
		SetNuiFocus(true, true)
		SendNUIMessage({
			showInventoryHud = true,
			items = items,
			user = playerPersonalData,
			loadout = loadout
		})
	end)	
end)

RegisterNetEvent('esx_inventory_hud:closeInventory')
AddEventHandler('esx_inventory_hud:closeInventory', function(playerData)
	DeleteSkinCam()
	DisplayRadar(true)
	SetNuiFocus(false, false)
	SendNUIMessage({
		showInventoryHud = false,
	})
end)



RegisterNUICallback('esx_inventory_hud:CloseInventory', function(data, cb)
	TriggerEvent('esx_inventory_hud:closeInventory')
	cb(true)
end)


RegisterNUICallback('esx_inventory_hud:UseItem', function(data, cb)

	TriggerServerEvent('esx:useItem', data.data)
	TriggerEvent('esx_inventory_hud:closeInventory')
end)

RegisterNUICallback('esx_inventory_hud:DropItem', function(data, cb)
	local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
	ESX.Streaming.RequestAnimDict(dict)
	
	if data.data.type == 'item_weapon' then
		TriggerEvent('esx_inventory_hud:closeInventory')
		Citizen.Wait(1000)
		TriggerServerEvent('esx:removeInventoryItem', data.data.type, data.data.value)
		cb(true)
	elseif data.data.type == 'item_standard' then
		local dropQuantity = data.data.dropQuantity > 0 and data.data.dropQuantity or data.data.count
		TriggerEvent('esx_inventory_hud:closeInventory')
		Citizen.Wait(1000)
		TriggerServerEvent('esx:removeInventoryItem', data.data.type, data.data.value, tonumber(dropQuantity))
		cb(true)
	else
		cb(false)
	end
	
	TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)


end)



RegisterNUICallback('esx_inventory_hud:ToggleWeaponBinding', function(data, cb)

	if #data.data.weapon < 1 then
		cb(false)
	end

	local weaponBind = tonumber(data.data.weapon.bind)

	if  weaponBind ~= false and 'number' == type(weaponBind) then
		fastWeapons[weaponBind] = nil
		fastWeapons[tonumber(data.data.bind)] = nil
		cb(false)
		return
	end
	
	
	
	if data.data.bind ~= data.data.weapon.bind and data.data.weapon.bind then
		
		fastWeapons[data.data.bind] = nil
		fastWeapons[data.data.weapon.bind] = nil
		cb(false)
		return
	end

	fastWeapons[tonumber(data.data.bind)] = data.data.weapon.value
	cb(data.data.bind)
end)

RegisterNUICallback('esx_inventory_hud:GetClosestsPlayers', function(data, cb)
	local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
	local playerPed = PlayerPedId()

	if closestPlayer == -1 or closestPlayerDistance > 3.0 then
		cb(false)
	else
		local item, type = data.value, data.type
		local playersNearby = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
		local players, playersClosest = {}, {}


		for k, v in ipairs(playersNearby) do
			players[GetPlayerServerId(v)] = true
		end
		
		ESX.TriggerServerCallback('esx:getPlayerNames', function(returnedPlayers)
			for playerId, playerName in pairs(returnedPlayers) do
				table.insert(playersClosest, {
					name = playerName,
					playerId = playerId,
					selected = false
				})
			end

			cb({success = true, playersClosest = playersClosest})
		end, players)

		ESX.ShowNotification(('Found %s, they are %s unit(s) away'):format(GetPlayerName(closestPlayer), closestPlayerDistance))
	end
end)

RegisterNUICallback('esx_inventory_hud:GiveItemToAPlayer', function(data, cb)
	local playerPed = PlayerPedId()
	local selectedPlayer, selectedPlayerId = GetPlayerFromServerId(data.data.playerToGive), data.data.playerToGive
	local playersNearby = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
	
	playersNearby = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
	playersNearby = ESX.Table.Set(playersNearby)

	if playersNearby[selectedPlayer] then
		local selectedPlayerPed = GetPlayerPed(selectedPlayer)

		if IsPedOnFoot(selectedPlayerPed) and not IsPedFalling(selectedPlayerPed) then
			if data.data.type == 'item_weapon' then
				TriggerServerEvent('esx:giveInventoryItem', selectedPlayerId, data.data.element.type, data.data.element.value, nil)
				TriggerEvent('esx_inventory_hud:closeInventory')
			else

				local quantity = tonumber(data.data.element.giveQuantity)
				if quantity and quantity > 0 and data.data.element.count >= quantity then
					TriggerServerEvent('esx:giveInventoryItem', selectedPlayerId, data.data.element.type, data.data.element.value, quantity)
					TriggerEvent('esx_inventory_hud:closeInventory')
				else
					TriggerEvent('esx_inventory_hud:closeInventory')
					ESX.ShowNotification(_U('amount_invalid'))
				end
			end
		else

		end
	end
end)


