ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 

local ESX = GetResourceState('es_extended'):find('start') and exports.es_extended:getSharedObject()
if not ESX then return end

ESX_data = {
    GetExtendedPlayers = ESX.GetExtendedPlayers,
    RegisterServerCallback = ESX.RegisterServerCallback,
}
do
    Players = {}
    local xPlayers = ESX_data.GetExtendedPlayers()

    for i = 1, #xPlayers do
        local xPlayer = xPlayers[i]
        Players[xPlayer.source] = xPlayer.identifier
    end
end


--
-- Gets player's xp value from database and returns xp
--


ESX.RegisterServerCallback('jmodz_xp:GetPlayerXP_data', function(source, cb)
    local identifier = Players[source]
    local xp_data = MySQL.scalar.await('SELECT xp FROM users WHERE identifier = ?', { identifier })
    cb(xp_data)
end)

--
-- Gets player's xp value from database and returns rank
--

ESX.RegisterServerCallback('jmodz_xp:GetPlayerRank_data', function(source, cb)
    local identifier = Players[source]
    local xp_data = MySQL.scalar.await('SELECT xp FROM users WHERE identifier = ?', { identifier })

    local ranks = {}
    for i, rank in ipairs(Config.Ranks) do
      table.insert(ranks, {xp = rank.xp, rank = rank.rank})
    end
    
    result = {xp = 0, rank = ""}
    for i = 1, #ranks do
      if ranks[i].xp <= xp_data and ranks[i].xp > result.xp then
        result = ranks[i]
      end
    end

    local rank_data = result.rank
    cb(rank_data)
end)

--
-- Adds xp for player
--

RegisterNetEvent("jmodz_xp:addXP")
AddEventHandler("jmodz_xp:addXP", function(xp)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    
    local xp_current = MySQL.scalar.await('SELECT xp FROM users WHERE identifier = ?', { identifier })
    local xp_set = xp_current + xp
    MySQL.Async.execute('UPDATE users SET xp = xp WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@xp'] = xp_set
    }, function(result)
    end)
end)

--
-- Removes xp for player
--

RegisterNetEvent("jmodz_xp:removeXP")
AddEventHandler("jmodz_xp:removeXP", function(xp)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    
    local xp_current = MySQL.scalar.await('SELECT xp FROM users WHERE identifier = ?', { identifier })
    local xp_set = xp_current - xp
    MySQL.Async.execute('UPDATE users SET xp = @xp WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['xp'] = xp_set
    }, function(result)
    end)
end)
