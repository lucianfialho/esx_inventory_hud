ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do	
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end 
	
end)

RegisterNetEvent('esx_inventory_hud:playerLoaded')
AddEventHandler('esx_inventory_hud:playerLoaded', function(xPlayer)
	local items = GetInventoryData()
	SetNuiFocus(true, true)
	
	SendNUIMessage({
		showInventoryHud = true,
		items = items
	})
end)

RegisterNUICallback('esx_inventory_hud:UseItem', function(data, cb)

	TriggerServerEvent('esx:useItem', data.data)
	SetNuiFocus(false, false)
	
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

function GetInventoryData()
	local items, currentWeight = {}, 0
	local playerPed = PlayerPedId()
	
	ESX.PlayerData = ESX.GetPlayerData()

	for k,v in ipairs(Config.Weapons) do
		local weaponHash = GetHashKey(v.name)

		if HasPedGotWeapon(playerPed, weaponHash, false) then
			local ammo, label = GetAmmoInPedWeapon(playerPed, weaponHash)

			if v.ammo then
				label = ('%s - %s %s'):format(v.label, ammo, v.ammo.label)
			else
				label = v.label
			end

			table.insert(items, {
				label = label,
				count = 1,
				type = 'item_weapon',
				value = v.name,
				usable = false,
				rare = false,
				ammo = ammo,
				canGiveAmmo = (v.ammo ~= nil),
				canRemove = true
			})
		end
	end


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
		if v.money > 0 then
			local formattedMoney = _U('locale_currency', ESX.Math.GroupDigits(v.money))
			local canDrop = v.name ~= 'bank'
			local icon

			if v.name == 'bank' then
				icon = 'money-check-alt'
			end

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