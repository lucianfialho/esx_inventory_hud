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
    
    
    for k,v in pairs(xPlayer.get('accounts')) do
        if v.name ~= 'bank' then
			local formattedMoney = _U('locale_currency', ESX.Math.GroupDigits(v.money))
			playerPersonalData.bank = formattedMoney
		end
    end

    cb(playerPersonalData)
end)