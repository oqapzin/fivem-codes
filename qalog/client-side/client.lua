-----------------------------------------------------------------------------------------------------------------------------------------
-- QAP - CODE BY QAP 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("qap_events:update_log")
AddEventHandler("qap_events:update_log",function(returnId,returnCoords,returnReason)
    local displaying = true

    CreateThread(function()
        Wait(60000)
        displaying = false
    end)

    CreateThread(function()
        while displaying do
            local timeDistance = 1000
            local plyCoords = GetEntityCoords(PlayerPedId())
            
            if #(plyCoords - vector3(returnCoords["x"],returnCoords["y"],returnCoords["z"])) <= 15.0 then
                timeDistance = 5
                Text3D(returnCoords["x"],returnCoords["y"],returnCoords["z"]+0.15, "~o~[QADEV - JOGADOR DESLOGOU]")
                Text3D(returnCoords["x"],returnCoords["y"],returnCoords["z"], "~o~ID: ~w~"..returnId.." | ~o~Motivo: ~w~"..returnReason)
            end
            Wait(timeDistance)
        end
    end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function Text3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(82, 0, 0, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end


print("[QAP DEV] QALOGS-LOAD")