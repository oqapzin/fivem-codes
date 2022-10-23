-----------------------------------------------------------------------------------------------------------------------------------------
-- QAP - CODE BY QAP 
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped", function(reason)
    local user_id = vRP.getUserId(source)
    local coords = GetEntityCoords(GetPlayerPed(source))

    if user_id ~= nil then 
        TriggerClientEvent("qap_events:update_log",-1,user_id,coords,reason)
    else
        TriggerClientEvent("qap_events:update_log",-1,"Não identificado",coords,reason)
    end 
end)