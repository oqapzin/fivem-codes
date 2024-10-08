-----------------------------------------------------------------------------------------------------------------------------------------
-- QAP - CODE BY QAP 
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL 
-----------------------------------------------------------------------------------------------------------------------------------------
vQAPZIN = {}
Tunnel.bindInterface("qarestart",vQAPZIN)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local restarttime = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION START RESTART
-----------------------------------------------------------------------------------------------------------------------------------------
function vQAPZIN.startRestart(returnTime)

    restarttime = returnTime

    print("[QAP DEV] QARESTART STARTED")

    CreateThread(function()
        while true do
            Wait(0)

			if restarttime > 0 then 
           	 	AddText("~o~[QAPDEV]~w~ TEMPO PARA REINICIALIZAÇÃO: ~r~"..restarttime.." ~w~")
			end 

			if restarttime < 1 then 
				AddText("~o~[QAPDEV]~w~ SERVIDOR EM PROCESSO DE REINICIALIZAÇÃO.")
			end 
        end 
    end)

    CreateThread(function()
        while restarttime > 0 do 
            Wait(1000)
            restarttime = restarttime - 1
            print("[QAP DEV] THREAD: "..restarttime.." | CODE BY QAP")
        end 
    end)
end 
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION KICK PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function vQAPZIN.startKick()
    CreateThread(function()
        while true do 
            Wait(1000)

            print("[QAP DEV] PLAYER DENTRO DO CONTADOR.")


            if restarttime == 0 then 
                RestartGame()
                break
            end 
        end 
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION ADD TEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function AddText(TextType)
	SetTextFont(4)
	SetTextScale(0.50,0.50)
	SetTextColour(255,255,255,180)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(TextType)
	DrawText(0.5,0.93)
end


print("[QAP DEV] QAP-RESTART-CODE LOAD")