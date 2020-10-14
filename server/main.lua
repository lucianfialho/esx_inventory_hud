ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterCommand('kk', 'admin', function(xPlayer, args, showError)
    xPlayer.triggerEvent('esx_inventory_hud:playerLoaded')
end, false)


ESX.RegisterServerCallback('esx_inventory_hud:GetPlayerPersonalData', function(playerId, cb)
    local xPlayer, playerPersonalData  = ESX.GetPlayerFromId(playerId), {}

    playerPersonalData.firstName = xPlayer.get('firstName')
    playerPersonalData.lastName = xPlayer.get('lastName')
    playerPersonalData.dateOfBirth = xPlayer.get('dateofbirth')
    
    local formattedMoney = _U('locale_currency', ESX.Math.GroupDigits(xPlayer.getAccount('bank').money))
    
    playerPersonalData.bank = formattedMoney
    playerPersonalData.job = xPlayer.getJob()
    
    cb(playerPersonalData)
end)

ESX.RegisterServerCallback('esx_inventory_hud:GetPlayerWeaponData', function(playerId, cb)
    local xPlayer, playerWeaponData  = ESX.GetPlayerFromId(playerId), {}

    for k,v in ipairs(xPlayer.getLoadout()) do
		local weaponHash = GetHashKey(v.value)
        -- _,hudDamage,hudSpeed,hudCapacity,hudAccuracy,hudRange = GetWeaponHudStats(weaponHash)
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
            stats = {
                damage = hudDamage,
                fireRate = hudSpeed,
                ammoCapacity = hudCapacity,
                accuracy = chudAccuracy,
                range = hudRange
            }
        })
    end
    
    print(json.encode(playerWeaponData))
    
    cb(playerWeaponData)
end)


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