-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP - CODE BY QAP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL
-----------------------------------------------------------------------------------------------------------------------------------------
vQAPZIN = {}
Tunnel.bindInterface("qawater",vQAPZIN)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local itens = config["Itens"]
local creative = config["creative"]
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENT REMOVE ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function vQAPZIN.removeItens()
    local source = source 
    local user_id = vRP.getUserId(source)
    if user_id then 
        for k,v in pairs(itens) do
            if creative then 
                local getItens = vRP.getInventoryItemAmount(user_id,v[1])
                if getItens[2] then 
                    if v[2] then 
                        vRP.giveInventoryItem(user_id,v[3],parseInt(getItens[1]),true)
                    end 
                    vRP.removeInventoryItem(user_id,getItens[2],parseInt(getItens[1]),true)
                end 
            else 
                local getItens = vRP.getInventoryItemAmount(user_id,v[1])
                if getItens then 
                    if v[2] then 
                        vRP.giveInventoryItem(user_id,v[3],parseInt(getItens),true)
                    end 
                    vRP.removeInventoryItem(user_id,v[1],parseInt(getItens),true)
                end 
            end 
        end 
    end 
end 