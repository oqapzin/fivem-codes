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
local restarttime = config["start"]["restartTime"] 
local automaticThread = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({content = message}), { ["Content-Type"] = "application/json" })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND FOR INIT RESTART
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(config["start"]["commandName"],function(source,args,rawCommand)
    if not restart then 
        if source == 0 then
            CreateThreadRestart()

            if config["webhook"] ~= "" then 
                SendWebhookMessage(config["webhook"],"```prolog\n[============== RESTART SYSTEM - ALERTA SONORO ==============]\n[ADMIN]: CONSOLE "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").." \r```")
            end  

            vCLIENT.startRestart(-1,restarttime)
            TriggerClientEvent("Notify",-1,"azul","Atenção jogador, o sistema de restart acaba de ser iniciado! Dentro de 5 minutos o servidor será desligado.",50000)
            TriggerClientEvent("sounds:source",-1,"warning",0.5)
        end 

        if source > 0 then 
            local user_id = vRP.Passport(source)
            if vRP.HasGroup(user_id,config["start"]["permission"]) then
                CreateThreadRestart()

                if config["webhook"] ~= "" then 
                    SendWebhookMessage(config["webhook"],"```prolog\n[============== RESTART SYSTEM - ALERTA SONORO ==============]\n[ADMIN]: "..user_id.." "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").." \r```")
                end 

                vCLIENT.startRestart(-1,restarttime)
                TriggerClientEvent("Notify",-1,"azul","Atenção jogador, o sistema de restart acaba de ser iniciado! Dentro de 5 minutos o servidor será desligado.",50000)
                TriggerClientEvent("sounds:source",-1,"warning",0.5)
            end
        end 
    end 
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION CREATE THREAD RR
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateThreadRestart()
    if restart then 
        return 
    end 

    restart = true

    print("[QAP SYSTEM] - THE RESTART SYSTEM STARTED SUCCESSFULLY!")
	
    if config["weather"] then 
        TriggerEvent("setWeather")
    end 

    CreateThread(function()
        while restart do 
            Wait(1000)
            if restarttime > 0 then 
                restarttime = restarttime - 1
            end 
    
            if config["start"]["restartTimeInConsole"] and restarttime > 0 then 
                print("[QAP SYSTEM] - O SERVIDOR SERÁ REINICIADO EM: "..restarttime)
            end 

            if restarttime < 1 then
                if not restartkick then 
                    if GetNumPlayerIndices() >= 1 then 
                        vCLIENT.startKick(-1)
                    end 

                    restartkick = true 
                end

                print("[QAP SYSTEM] - AINDA EXISTEM "..GetNumPlayerIndices().." PESSOAS ONLINE.")
    
                if GetNumPlayerIndices() == 0 then    
                    if config["start"]["automaticRestartAdress"] ~= "" or not config["start"]["automaticRestartAdress"] == nil then 
                        os.execute("start "..config["start"]["automaticRestartAdress"]) 
                    end 
                    
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
AddEventHandler("Queue:Connecting",function(source,identifiers,deferrals)
    if restart then 
        deferrals.done("Servidor está sendo reiniciado.")
		TriggerEvent("Queue:Remove",identifiers)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTOMATIC RESTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while automaticThread do
        Wait(1000)
        for k, v in pairs(config["automaticRestHours"]) do 
            if os.date("%H:%M") == v then 
                CreateThreadRestart()

                if config["webhook"] ~= "" then 
                    SendWebhookMessage(config["webhook"],"```prolog\n[============== RESTART SYSTEM - ALERTA SONORO ==============]\nAUTOMATIC RESTART "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").." \r```")
                end 


                if GetNumPlayerIndices() >= 1 then 
                    vCLIENT.startRestart(-1,restarttime)
                    TriggerClientEvent("Notify",-1,"azul","Atenção jogador, o sistema de restart acaba de ser iniciado! Dentro de 5 minutos o servidor será desligado.",50000)
                    TriggerClientEvent("sounds:source",-1,"warning",0.5)
                end 

                automaticThread = false
            end 
        end 
    end 
end)