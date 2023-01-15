--[[ ===================================================== ]]--
--[[           MH NPC Services Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

local QBCore = exports['qb-core']:GetCoreObject()
local passengers = {}

local function GetUsername(id)
    return QBCore.Functions.GetPlayer(id).PlayerData.charinfo.firstname ..' '.. QBCore.Functions.GetPlayer(id).PlayerData.charinfo.lastname
end

local function comma_value(amount)
    local formatted = tostring(amount)
    while true do
        formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

local function isEMSService(id)
    local isAllowed = false
    local Player = QBCore.Functions.GetPlayer(id)
    if Player then
        if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "mechanic" or Player.PlayerData.job.name == "taxi" and Player.PlayerData.job.onduty then
            isAllowed = true
        end
    end
    return isAllowed
end

local function GetOnlinePlayers()
    local sources = {}	
    for k, id in pairs(QBCore.Functions.GetPlayers()) do
		local target = QBCore.Functions.GetPlayer(id)
        if target then 
            sources[#sources + 1] = {
                source = target.PlayerData.source, 
                fullname = target.PlayerData.charinfo.firstname.." "..target.PlayerData.charinfo.lastname
            } 
        end
    end
    return sources
end

local function CanIPayTheBill(id, company, price)
    local Player = QBCore.Functions.GetPlayer(id)
    local topay = math.floor(price)
    if Player then
        if Player.PlayerData.money["cash"] >= topay then
            return true
        else
            if Player.PlayerData.money["bank"] >= topay then
                return true
            end
        end
    end
    return false
end

QBCore.Functions.CreateCallback('mh-npcservices:server:isEMSServices', function(source, cb)
    local src = source
    cb(isEMSService(src))
end)

QBCore.Functions.CreateCallback('mh-npcservices:server:emsOnline', function(source, cb, job)
    local count = QBCore.Functions.GetDutyCount(job)
	cb(count)
end)

QBCore.Functions.CreateCallback("mh-npcservices:server:GetOnlinePlayers", function(source, cb)
	cb(GetOnlinePlayers())
end)

QBCore.Functions.CreateCallback("mh-npcservices:server:CanIPayTheBill", function(source, cb, company, price)
    local src = source
    cb(CanIPayTheBill(src, company, price))
end)

QBCore.Functions.CreateCallback('mh-npcservices:server:IsVehicleOwner', function(source, cb, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?', {plate, citizenid}, function(result)
		if result[1] ~= nil then
		    cb(true)
		else
			cb(false)
		end
	end)
end)

RegisterServerEvent('mh-npcservices:server:sendService', function(callData)
    local src = source
    local num = nil
    if not id then id = src end
    if src == callData.targetId then num = src else num = callData.targetId end
    if not isEMSService(num) then
        local count = QBCore.Functions.GetDutyCount(job)
        if count >= Config.MinOnlineEMS then
            TriggerClientEvent('QBCore:Notify', num, "Je kunt deze services niet gebruiken als er een speler in de stad is met deze job.", "error", 10000)
        else
            if CanIPayTheBill(num, callData.job, callData.price) then
                TriggerClientEvent("mh-npcservices:client:sendService", num, callData)
            else
                TriggerClientEvent('QBCore:Notify', num, Lang:t('notify.cant_pay',{price = callData.price}), "error", 10000)
            end
        end
    else
        if isEMSService(num) then
            TriggerClientEvent("mh-npcservices:client:sendService", num, callData)
        end
    end
end)

RegisterServerEvent('mh-npcservices:server:getin', function(job, vehicle)
    local src = source
    passengers[#passengers + 1] = {company = job, vehicle = vehicle, passenger = src}
    TriggerClientEvent('mh-npcservices:client:getinvehicle', src, vehicle)
end)

RegisterServerEvent('mh-npcservices:server:leavevehicle', function(vehicle)
    for i = 0, #passengers do
        if passengers[i] then
            if passengers[i].passenger ~= nil then 
                local fullname = QBCore.Functions.GetPlayer(passengers[i].passenger).PlayerData.charinfo.firstname ..' '.. QBCore.Functions.GetPlayer(passengers[i].passenger).PlayerData.charinfo.lastname
                TriggerClientEvent('mh-npcservices:client:leavevehicle', passengers[i].passenger, passengers[i].vehicle)
                TriggerClientEvent('QBCore:Notify', passengers[i].passenger, Lang:t('notify.left_vehicle'), "success")
                passengers[i].passenger = nil
            end
        end
    end
end)

RegisterServerEvent('mh-npcservices:server:pay', function(company, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.money["cash"] >= price then
        Player.Functions.RemoveMoney("cash", price, "pay-"..company)
    else
        if Player.PlayerData.money["bank"] >= price then
            Player.Functions.RemoveMoney("bank", price, "pay-"..company)
        end
    end
end)
