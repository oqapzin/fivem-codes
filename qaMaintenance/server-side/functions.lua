function getUserSteamHex(userSource)
    return vRP.getIdentities(userSource)
end 

function hasPermission(userSource,permission)
    return vRP.hasGroup(vRP.getUserId(userSource),permission)
end

function Notify(userSource,color,message) 
    TriggerClientEvent("Notify",userSource,color or "vermelho",message,2000)
end