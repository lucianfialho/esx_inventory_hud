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
	TriggerEvent('esx_inventory_hud:openInventory')
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
	local loadout = ESX.PlayerData.loadout

	for k,v in ipairs(loadout) do
		local weaponHash = GetHashKey(v.name)

        _,hudDamage,hudSpeed,hudCapacity,hudAccuracy,hudRange = GetWeaponHudStats(weaponHash)

        table.insert(playerWeaponData, {
            label = v.label,
            count = 1,
            type = 'item_weapon',
            value = v.name,
            usable = false,
            rare = false,
            ammo = v.ammo,
            canGiveAmmo = (v.ammo ~= nil),
			canRemove = true,
			selected = false,
			bind = nil,
            stats = {
                damage = hudDamage,
                fireRate = hudSpeed,
                ammoCapacity = hudCapacity,
                accuracy = chudAccuracy,
                range = hudRange
            }
        })
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
AddEventHandler('esx_inventory_hud:openInventory', function(playerData)
	DeleteSkinCam()
	SetNuiFocus(false, false)
	DisplayRadar(false)

	local items = GetInventoryData()
	local loadout = GetLoadoutData()
	
	ESX.TriggerServerCallback('esx_inventory_hud:GetPlayerPersonalData', function(playerPersonalData)
		loadCamera(0, 3)
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
	
	SendNUIMessage({
		showInventoryHud = false,
	})
end)

RegisterNUICallback('esx_inventory_hud:DropItem', function(data, cb)	
	local dropQuantity = data.data.dropQuantity > 0 and data.data.dropQuantity or data.data.count

	TriggerServerEvent('esx:removeInventoryItem', data.data.type, data.data.value, tonumber(dropQuantity))
	--  TODO: Adicionar validação de sucesso
	cb(true)

	-- SetNuiFocus(false, false)
	-- SendNUIMessage({
	-- 	showInventoryHud = false,
	-- })
end)

RegisterNUICallback('esx_inventory_hud:SetWeaponBinding', function(data, cb)
	if data.data.bind ~= nil then
		fastWeapons[data.data.bind] = nil
	end

	fastWeapons[tonumber(data.data.bind)] = data.data.value
end)