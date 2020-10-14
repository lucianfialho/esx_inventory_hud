ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do	
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end 
	
end)

function CreateSkinCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    local playerPed = PlayerPedId()

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    isCameraActive = true
    SetCamRot(cam, 0.0, 0.0, 270.0, true)
    SetEntityHeading(playerPed, 0.0)
end

function DeleteSkinCam()
    isCameraActive = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
end

function loadCamera(camOffset, zoomOffset)
    CreateSkinCam()

    DisableControlAction(2, 30, true)
    DisableControlAction(2, 31, true)
    DisableControlAction(2, 32, true)
    DisableControlAction(2, 33, true)
    DisableControlAction(2, 34, true)
    DisableControlAction(2, 35, true)
    DisableControlAction(0, 25, true) -- Input Aim
    DisableControlAction(0, 24, true) -- Input Attack

    local angle = 90
    
    if isCameraActive then
        if angle > 360 then
            angle = angle - 360
        elseif angle < 0 then
            angle = angle + 360
        end

        heading = angle + 0.0
    end

    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    local angle = heading * math.pi / 180.0
    local theta = {
        x = math.cos(angle),
        y = math.sin(angle)
    }


    local pos = {
        x = coords.x + (zoomOffset * theta.x),
        y = coords.y + (zoomOffset * theta.y)
    }


    local angleToLook = heading - 140.0
    if angleToLook > 360 then
        angleToLook = angleToLook - 360
    elseif angleToLook < 0 then
        angleToLook = angleToLook + 360
    end

    angleToLook = angleToLook * math.pi / 180.0
    local thetaToLook = {
        x = math.cos(angleToLook),
        y = math.sin(angleToLook)
    }

    local posToLook = {
        x = coords.x + (zoomOffset * thetaToLook.x),
        y = coords.y + (zoomOffset * thetaToLook.y)
    }

    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
    PointCamAtCoord(cam, posToLook.x - 6.5, posToLook.y, coords.z + camOffset)

end

local function GetIntFromBlob(b, s, o)
	r = 0
	for i=1,s,1 do
		r = r | (string.byte(b,o+i)<<(i-1)*8)
	end
	return r
end

function GetWeaponHudStats(weaponHash, none)
	blob = '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0'
	retval = Citizen.InvokeNative(0xD92C739EE34C9EBA, weaponHash, blob, Citizen.ReturnResultAnyway())
	hudDamage = GetIntFromBlob(blob,8,0)
	hudSpeed = GetIntFromBlob(blob,8,8)
	hudCapacity = GetIntFromBlob(blob,8,16)
	hudAccuracy = GetIntFromBlob(blob,8,24)
	hudRange = GetIntFromBlob(blob,8,32)
	return retval, hudDamage, hudSpeed, hudCapacity, hudAccuracy, hudRange
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




RegisterNetEvent('esx_inventory_hud:playerLoaded')
AddEventHandler('esx_inventory_hud:playerLoaded', function(playerData)
	SetNuiFocus(false,false)
	DeleteSkinCam()

	local items = GetInventoryData()
	local loadout = GetLoadoutData()
	
	ESX.TriggerServerCallback('esx_inventory_hud:GetPlayerPersonalData', function(playerPersonalData)
		loadCamera(0, 3)
		SetNuiFocus(true, true)
		SendNUIMessage({
			showInventoryHud = true,
			items = items,
			user = playerPersonalData,
			loadout = playerWeaponData
		})
	end)	
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