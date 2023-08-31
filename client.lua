
  CreateThread(function()
    TriggerServerEvent(GetCurrentResourceName())
  end)
  RegisterNetEvent(GetCurrentResourceName())
  AddEventHandler(GetCurrentResourceName(), function(state)
    if (state) then
      local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
VServer = {}
Tunnel.bindInterface("bsPolice", VServer)
Server = Tunnel.getInterface("bsPolice")
Police = Tunnel.getInterface("police")
vRP = Proxy.getInterface("vRP")
local promise = {}
local tabletState = false
local isArrest = false
local fineValue = false

RegisterCommand(Config.Command, function()
    VServer.Open()
end)

function VServer.Open()
    if (Config.Item ~= "") then
        if Server.GetInventoryItem(Server.GetUserId(), Config.Item) then
            Open()
        else
            Server.Notify(Config.NotHasItem)
        end
    else
        Open()
    end
end

function Open()
    if (Server.IsExistPermission()) then
        if not (Server.Alive()) then return Server.Notify(Config.NotAlive) end
        vRP.removeObjects()
		vRP.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@base","base","prop_cs_tablet",50,28422)
        ToogleTablet(true)
    else
        Server.Notify(Config.NotPermission)
    end
end

RegisterNetEvent("bsPolice:res:backend", function(promiseId, ...)
    if not promise[promiseId] then return end
    promise[promiseId](...)
    promise[promiseId] = nil
end)

local eventId = 1
RegisterNetEvent("bsPolice:res:event", function(event)
    if not (tabletState) then return end
    if not (type(event) == "table") then
        SendEvent(event)
        return
    end

    for _, singleEvent in pairs(event) do
        SendEvent(singleEvent)
    end
end)

function SendEvent(event)
    SendNUIMessage({ action = event, data = eventId })
    eventId = eventId + 1
end

RegisterNUICallback("bsPolice:backend", function(data, cb)
    if (data["action"] == "language") then
      return cb(Config.Languages[Config.Language])
    end

    local promiseId = #promise + 1
    promise[promiseId] = cb
    TriggerServerEvent("bsPolice:req:backend", promiseId, data.action, data.args)
end)

local takePhoto = false
RegisterNUICallback("close", function(_, cb)
    VServer.Close()
    cb(true)
end)

RegisterNetEvent("TabletClose", function()
    VServer.Close()
end)

function VServer.Close()
    takePhoto = false
    SetFollowPedCamViewMode(0)
    ToogleTablet(false)
    vRP.removeObjects()
end

SetFollowPedCamViewMode(0)

RegisterNUICallback("bsPolice:onPhoto", function(_, cb)
    SetNuiFocus(true, true)
    --[[ CreateMobilePhone(1)
    CellCamActivate(true, true) ]]
    SetFollowPedCamViewMode(4)
    takePhoto = true
    Wait(4)
    while takePhoto do
        Wait(100)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
    end
    Wait(800)
    if (takePhoto) then cb(true) end
end)

CreateThread(function()
    while Config.PoliceInServiceState() do
        Wait(1000 * 60)
        Server.updateWorkTime()
    end
end)

function ToogleTablet(state)
    SendNUIMessage({ action = "tablet", data = state })
    SetNuiFocus(state, state)
    tabletState = state
end

local function GetPlayers()
    local pedList = {}

    for _, _player in ipairs(GetActivePlayers()) do
        pedList[GetPlayerServerId(_player)] = true
    end

    return pedList
end

function VServer.NearestPlayers(vDistance, source)
    local userList = {}
    local ped = PlayerPedId()
    local userPlayers = GetPlayers()
    local coords = GetEntityCoords(ped)

    for playerSource, _ in pairs(userPlayers) do
       --[[  if playerSource ~= source then ]]
            local uPed = GetPlayerPed(GetPlayerFromServerId(playerSource))
            local uCoords = GetEntityCoords(uPed)
            local distance = #(coords - uCoords)
            if distance <= vDistance then
                userList[playerSource] = playerSource
            end
        --[[ end ]]
    end

    return userList
end

function VServer.PlayersOn(source)
    local userList = {}
    local userPlayers = GetPlayers()

    for playerSource, _ in pairs(userPlayers) do
        --[[ if playerSource ~= source then ]]
            userList[playerSource] = playerSource
        --[[ end ]]
    end

    return userList
end

function VServer.PrisionPlayer(time, value)
    local Ped = GetPlayerPed(GetPlayerFromServerId(source))
    DoScreenFadeOut(500)
    Wait(400)
    SetEntityCoords(Ped, 1775.65,2552.06,45.56)
    SetEntityHeading(Ped, 85.04)
    Wait(500)
    Wait(1000)
    DoScreenFadeIn(1000)
    SendNUIMessage({ action = "prison", data = { time = time, value = value } })
    isArrest = true
    fineValue = value
end

function VServer.PrisionPolice(playerId, totalTime, totalFine, description)
    Police.initPrison(playerId, totalTime, totalFine, description)
end

CreateThread(function()
    while true do
        if (exports["police"]:checkPrison()) then
            if (fineValue) then
                SendNUIMessage({ action = "prison", data = { time = Server.GetPrison(), value = fineValue } })
            else
                SendNUIMessage({ action = "prison", data = { time = Server.GetPrison() } })
            end
        else
            if (isArrest) then
                isArrest = false
                fineValue = false
                SendNUIMessage({ action = "prison", data = false })
            end
        end
        Wait(500)
    end
end)
    end
  end)
  