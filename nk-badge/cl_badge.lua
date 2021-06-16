QBCore = nil 

local plateModel = "prop_fib_badge"
local plateModel2 = "prop_fib_badge"
local animDict = "missfbi_s4mop"
local animName = "swipe_card"
local plate_net = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

local open = false

-- Rozet kimliği açma
RegisterNetEvent('badge:open')
AddEventHandler('badge:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

RegisterCommand('pdbadge', function()
    TriggerEvent('badge:openPD')
end)

-- Rozet açıkken tuş eventleri
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)

RegisterNetEvent('showbadge')
AddEventHandler('showbadge', function()
	local player, distance =  QBCore.Functions.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
		TriggerServerEvent('badge:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
        TriggerServerEvent('badge:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
	else 
		TriggerServerEvent('badge:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
	end
end)

function startAnim()
    RequestModel(GetHashKey(plateModel))
    while not HasModelLoaded(GetHashKey(plateModel)) do
        Citizen.Wait(100)
    end
	ClearPedSecondaryTask(PlayerPedId())
	RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end
    local playerPed = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, -5.0)
    local platespawned = CreateObject(GetHashKey(plateModel), plyCoords.x, plyCoords.y, plyCoords.z, 0, 0, 0)
    Citizen.Wait(1000)
    local netid = ObjToNet(platespawned)
    SetNetworkIdExistsOnAllMachines(netid, true)
    SetNetworkIdCanMigrate(netid, false)
    TaskPlayAnim(playerPed, 1.0, -1, -1, 50, 0, 0, 0, 0)
    TaskPlayAnim(playerPed, animDict, animName, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
    Citizen.Wait(800)
    AttachEntityToEntity(platespawned, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
    plate_net = netid
    Citizen.Wait(3000)
    ClearPedSecondaryTask(playerPed)
    DetachEntity(NetToObj(plate_net), 1, 1)
    DeleteEntity(NetToObj(plate_net))
    plate_net = nil
end

RegisterNetEvent('badge:openPD')
AddEventHandler('badge:openPD', function()
	TriggerEvent('showbadge')
	startAnim()
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

RegisterNetEvent('badge:shot')
AddEventHandler('badge:shot', function(playerID)

	local posx, posy = 0, 0.26
	local width, height = 0.07, 0.14
	local x, y = GetActiveScreenResolution()
		if x == 1920 and y == 1080 then
			posx, posy = 0.085, 0.35
	 		width, height = 0.07, 0.14
		elseif x == 1366 and y == 768 then
			posx, posy = 0.686, 0.366
			width, height = 0.086, 0.196
		elseif x == 1360 and y == 768 then
			posx, posy = 0.685, 0.366
			width, height = 0.087, 0.196
		elseif x == 1600 and y == 900 then
			posx, posy = 0.732, 0.3122
			width, height = 0.073, 0.168
		elseif x == 1400 and y == 1050 then
			posx, posy = 0.694, 0.267
			width, height = 0.083, 0.145
		elseif x == 1440 and y == 900 then
			posx, posy = 0.702, 0.312
			width, height = 0.082, 0.169
		elseif x == 1680 and y == 1050 then
			posx, posy = 0.745, 0.268
			width, height = 0.068, 0.1435
		elseif x == 1280 and y == 720 then
			posx, posy = 0.665, 0.3905
			width, height = 0.09, 0.2105
		elseif x == 1280 and y == 768 then
			posx, posy = 0.665, 0.366
			width, height = 0.091, 0.196
		elseif x == 1280 and y == 800 then
			posx, posy = 0.665, 0.3515
			width, height = 0.091, 0.1895
		elseif x == 1280 and y == 960 then
			posx, posy = 0.665, 0.2925
			width, height = 0.091, 0.1585
		elseif x == 1280 and y == 1024 then
			posx, posy = 0.665, 0.2745
			width, height = 0.091, 0.1475
		elseif x == 1024 and y == 768 then
			posx, posy = 0.5810, 0.366
			width, height = 0.115, 0.1965
		elseif x == 800 and y == 600 then
			posx, posy = 0.4635, 0.4685
			width, height = 0.1455, 0.251
		elseif x == 1152 and y == 864 then
			posx, posy = 0.6275, 0.325
			width, height = 0.1005, 0.175
		elseif x == 1280 and y == 600 then
			posx, posy = 0.665, 0.468
			width, height = 0.0905, 0.251
		end

	local playerPed = GetPlayerPed(GetPlayerFromServerId( playerID ))
	local handle = RegisterPedheadshot(playerPed)

	if not IsPedheadshotValid(handle) then
		print('hay un error aqui')
		print(handle)
	end

	while not IsPedheadshotReady (handle) do
		Wait (100)
	end
	local headshot = GetPedheadshotTxdString (handle)
	while open do
		Wait (5)
		DrawSprite (headshot, headshot, posx, posy, width, height, 0.0, 255, 255, 255, 1000)
	end
	if not open then
		UnregisterPedheadshot(handle)
	end
end)