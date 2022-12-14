-----------------------------------------------------------------------------------------------------------------------------------------
-- QAP - CODE BY QAP 
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("qawater")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local InWater = false 
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
		Wait(2500)
		local Swimming = IsPedSwimming(PlayerPedId(),false)
		if Swimming and not InWater then
			InWater = true 
			vSERVER.removeItens()
		elseif InWater and not Swimming then 
			InWater = false 
		end
	end	
end)


print("[QAP DEV] QAWATER-LOAD")