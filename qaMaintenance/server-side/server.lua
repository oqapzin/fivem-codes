-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local maintenance = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.command, function(source,args,rawCommand)
    if source == 0 then 

        maintenance = not maintenance

        print(maintenance and "[QAP - MAINTENANCE Manutenção ativa" or "[QAP] Manutenção desativada")
    end

    if source > 0 then 
        if hasPermission(source,Config.commandPermission) then 
            maintenance = not maintenance

            print(maintenance and "[QAP - MAINTENANCE] Manutenção ativa" or "[QAP] Manutenção desativada")

            Notify(source,Config.notify.sucessColor,Config.notify.GameMessage..(manutencao and "Ativado" or "Desativado"))
        else
            Notify(source,Config.notify.errorColor,Config.notify.noPermMessage)
        end 
    end 
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler(Config.queueEventName or "Queue:playerConnecting",function(source,identifiers,deferrals)
	local steam = getUserSteamHex(source)
	if steam then
        if manutencao then 
            if Config.alowlist[steam] then
                print("[QAP - MAINTENANCE] Jogador "..steam.." acaba de logar no servidor.")
            else
                deferrals.done(Config.queueMessageError)
            end 
		end
	else
		deferrals.done("Conexão perdida com a Steam.")
	end

	TriggerEvent("Queue:removeQueue",identifiers)
end)