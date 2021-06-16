QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

-- Open ID card
RegisterServerEvent('badge:open')
AddEventHandler('badge:open', function(ID, targetID, type)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
	local show       = false
	local _PED_ID = PED_ID

	exports['ghmattimysql']:execute('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			exports['ghmattimysql']:execute('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
				if type ~= nil then
					for i=1, #licenses, 1 do
						if type == 'driver' then
							if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
								show = true
							end
						elseif type =='weapon' then
							if licenses[i].type == 'weapon' then
								show = true
							end
						end
					end
				else
					show = true
				end

				if show then
					local array = {
						user = user,
						licenses = licenses
					}
					TriggerClientEvent('badge:open', _source, array, type)
					TriggerClientEvent( 'badge:shot', _source, source )
				else
					TriggerClientEvent('esx:showNotification', _source, "You don't have that type of license..")
				end
			end)
		end
	end)
end)

ESX.RegisterUsableItem('pdbadge', function()
    TriggerClientEvent('badge:openPD', source, true)
end)