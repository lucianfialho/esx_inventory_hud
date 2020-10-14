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