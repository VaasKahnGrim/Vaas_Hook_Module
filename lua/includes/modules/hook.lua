local old = true

if SERVER then
	AddCSLuaFile("includes/modules/hook.lua")

	if old then
		AddCSLuaFile("includes/modules/hook_old.lua")
	else
		AddCSLuaFile("includes/modules/hook_new.lua")
	end
end

if old then
	include("includes/modules/hook_old.lua")
else
	include("includes/modules/hook_new.lua")
end

