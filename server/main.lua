ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterCommand('kk', 'admin', function(xPlayer, args, showError)
    xPlayer.triggerEvent('esx_inventory_hud:playerLoaded')
end, false)