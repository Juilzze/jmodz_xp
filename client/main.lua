jmodz = {}
jmodz.GetPlayerXP = {}
jmodz.GetPlayerRank = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

--
-- Gets xp from server callback
--

RegisterNetEvent('jmodz_xp:showxp')
AddEventHandler('jmodz_xp:showxp', function(source)
    ESX.TriggerServerCallback('jmodz_xp:GetPlayerXP', function(result)
		print(result)
	end)
end)

--
-- Gets level from server callback
--

RegisterNetEvent('jmodz_xp:showlevel')
AddEventHandler('jmodz_xp:showlevel', function(source)
    ESX.TriggerServerCallback('jmodz_xp:GetPlayerRank', function(result)
		print(result)
	end)
end)

--
-- Calls server function to add xp
--

RegisterNetEvent('jmodz_xp:xpgive')
AddEventHandler('jmodz_xp:xpgive', function(source)
	TriggerServerEvent("jmodz_xp:addXP", source)
end)

--
-- Calls server function to remove xp
--

RegisterNetEvent('jmodz_xp:xpremove')
AddEventHandler('jmodz_xp:xpremove', function(source)
	TriggerServerEvent("jmodz_xp:removeXP", source)
end)

--
-- Updates XP and Level to client side from server side every 10 seconds
--

Citizen.CreateThread(function()
	while true do
		ESX.TriggerServerCallback('jmodz_xp:GetPlayerRank_data', function(result)
			currentrank = result
		end)
		ESX.TriggerServerCallback('jmodz_xp:GetPlayerXP_data', function(result)
			currentxp = result
		end)
		Wait(10000)
	end
end)

local function GetPlayerXP()
	return currentxp
end

local function GetPlayerRank()
	return currentrank
end

local function GiveXP(amount)
	TriggerEvent('jmodz_xp:xpgive', amount)
end

local function RemoveXP(amount)
	TriggerEvent('jmodz_xp:xpremove', amount)
end

--
-- Exports... You can call these from another resource, example: exports.jmodz_xp:givexp(50) or exports.jmodz_xp:removexp(50)
-- You can get player's rank or xp value from another resource example: example_value = exports.jmodz_xp:getxp()
--

exports("getxp", GetPlayerXP);
exports("getrank", GetPlayerRank)

exports("givexp", GiveXP);
exports("removexp", RemoveXP);