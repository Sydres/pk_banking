--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


function logMoney(enviador,receptor,cantidad)

	MySQL.Async.execute("INSERT INTO pk_logTransacciones (Remitente,Receptor,Cantidad) VALUES (@remitente,@receptor,@cantidad)",{['@remitente'] = enviador, ['@receptor'] = receptor, ['@cantidad'] = cantidad})

end

RegisterServerEvent('bank:logMoney')
AddEventHandler('bank:logMoney', function(toPlayer,quantity)
	local xPlayerTo = ESX.GetPlayerFromId(toPlayer)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	logMoney(tostring(xPlayer.identifier),tostring(xPlayerTo.identifier),tonumber(quantity))

end)

RegisterServerEvent('bank:depositarPk')
AddEventHandler('bank:depositarPk', function(amount)
	local _source = source
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('chatMessage', _source, "Cantidad inválida")
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))
	end
end)


RegisterServerEvent('bank:quitarPk')
AddEventHandler('bank:quitarPk', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('chatMessage', _source, "Cantidad inválida")
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
	end
end)

RegisterServerEvent('bank:balancePk')
AddEventHandler('bank:balancePk', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('currentbalance1', _source, balance)
	
end)

RegisterServerEvent('bank:transferir')
AddEventHandler('bank:transferir', function(to, amountt)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(to)
    local balance = 0
    local ip = GetPlayerEndpoint(_source)
    local steamhex = GetPlayerIdentifier(_source)
    if zPlayer ~= nil then
        balance = xPlayer.getAccount('bank').money
        zbalance = zPlayer.getAccount('bank').money
        if tonumber(_source) == tonumber(to) then
            -- advanced notification with bank icon
            TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank',
                               'Transferencia',
                               '¡No puedes hacer transferencias a ti mismo!',
                               'CHAR_BANK_MAZE', 9)
        else
            if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <=
                0 then
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Banco', 'Transferencia',
                                   '¡No tienes suficiente dinero!',
                                   'CHAR_BANK_MAZE', 9)
            else
                xPlayer.removeAccountMoney('bank', tonumber(amountt))
                zPlayer.addAccountMoney('bank', tonumber(amountt))
                logMoney(tostring(xPlayer.identifier),tostring(zPlayer.identifier),tonumber(amountt))
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Banco', 'Transferencia',
                                   'Has transferido ~r~$' .. amountt ..
                                       '~s~ a ~r~' .. to .. ' .',
                                   'CHAR_BANK_MAZE', 9)
                TriggerClientEvent('esx:showAdvancedNotification', to, 'Banco',
                                   'Transferencia', 'Has recibido ~r~$' ..
                                       amountt .. '~s~ de ~r~' .. _source ..
                                       ' .', 'CHAR_BANK_MAZE', 9)
                local connect = {
                {
                    ["color"] = "23295",
                    ["title"] = "Han realizado una transferencia bancaria",
                    ["description"] = "Desde: **"..xPlayer.identifier.."**(".._source..")**\nHacia: **"..zPlayer.identifier.."**("..to..")**\nCantidad: **"..amountt.."$**",
                    },
                }                              
                PerformHttpRequest('https://discordapp.com/api/webhooks/637277595838185493/JVKDO-IOAsb_cSD8rWM-4JCm243ypl1ciEt9y3CBe71pUqm_wSDAFs6WI6jHVwDlxJgK', function(err, text, headers) end, 'POST', json.encode({username = "LOG TRANSFERENCIAS", embeds = connect}), { ['Content-Type'] = 'application/json' }) 
            end
        end
    end
end)





