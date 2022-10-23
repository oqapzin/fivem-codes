-----------------------------------------------------------------------------------------------------------------------------------------
-- QAP - CODE BY QAP 
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL 
-----------------------------------------------------------------------------------------------------------------------------------------
vCLIENT = Tunnel.getInterface("qarestart")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local restart = false
local restartkick = false
local restarttime = config["restartTime"] 
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({content = message}), { ["Content-Type"] = "application/json" })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND RR KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(config["commandName"],function(source,args,rawCommand)
    if not restart then 
        if source == 0 then

            restart = true

            CreateThreadRestart()

            if config["webhook"] ~= "" then 
                SendWebhookMessage(config["webhook"],"```prolog\n[============== RESTART SYSTEM - ALERTA SONORO ==============]\n[ADMIN]: CONSOLE "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").." \r```")
            end  

            for k,v in pairs(vRP.userList()) do
                local nplayer = vRP.userSource(k)
                if nplayer then
                    vCLIENT.startRestart(nplayer,restarttime)
                    TriggerClientEvent("Notify",nplayer,"sucesso","Atenção jogador, o sistema de restart acaba de ser iniciado! Dentro de 5 minutos o servidor será desligado.",50000)
                    TriggerClientEvent("vrp_sound:source",nplayer,"warning",0.5)
                end
            end
        end 

        if source > 0 then 
            local user_id = vRP.getUserId(source)
            if vRP.hasPermission(user_id,config["permission"]) then

                restart = true

                CreateThreadRestart()

                if config["webhook"] ~= "" then 
                    SendWebhookMessage(config["webhook"],"```prolog\n[============== RESTART SYSTEM - ALERTA SONORO ==============]\n[ADMIN]: "..user_id.." "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").." \r```")
                end 

                for k,v in pairs(vRP.userList()) do
                    local nplayer = vRP.userSource(k)
                    if nplayer then
                        vCLIENT.startRestart(nplayer,restarttime)
                        TriggerClientEvent("Notify",nplayer,"sucesso","Atenção jogador, o sistema de restart acaba de ser iniciado! Dentro de 5 minutos o servidor será desligado.",50000)
                        TriggerClientEvent("vrp_sound:source",nplayer,"warning",0.5)
                    end
                end
            end
        end 

        if config["weather"] then 
            TriggerEvent("setWeather")
        end 
    end 
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION CREATE THREAD RR
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateThreadRestart()

    print("[QAP SYSTEM] - THE RESTART SYSTEM STARTED SUCCESSFULLY!")

    CreateThread(function()
        while restart do 
            Wait(1000)
            if restarttime > 0 then 
                restarttime = restarttime - 1
            end 

            if restarttime < 1 then 
                if not restartkick then 
                    vCLIENT.startKick(-1)
                    restartkick = true 
                end 

                if GetNumPlayerIndices() == 0 then
                    Wait(10000) -- 10S
                    os.exit()
                    restart = false 
                end 
            end 
        end 
    end)
end 
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENT vRP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Queue:playerConnecting",function(source,identifiers,deferrals)
    if restart then 
        deferrals.done("Servidor está sendo reiniciado.")
		TriggerEvent("Queue:removeQueue",identifiers)
    end
end)