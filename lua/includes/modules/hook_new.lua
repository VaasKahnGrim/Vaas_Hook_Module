--Localized global functions(lets try to avoid needing to use these kind of things if we don't have to)
local GetGamemode = gmod.GetGamemode


--We do this because numerical tables are more effecient. This is similar to what is done with network strings in source from what I gathered. So doing it here should work just fine
local Events = {} --Event functions are stored here
local Event_Mappings = {} --Event names are stored here with a number applied to them
local Event_IDs = {} --Event IDs are stored here with a number applied to them


--[[
	Changes being made to Add and Remove:
		1. Having Events and Event ID strings being mapped with a number to represent them
			Event IDs mainly being used only for the Remove and GetTable functions. Cal and Run simply loop over the table and such
		2. Maybe add some validation checking
		3. Maybe remove the dependancy on the event ID some how safely
]]
local function Add(ev,id,func) --Should be number based now?
	if func then
		--Create Mapping to this event represented as a number
		if Event_Mappings[ev] == nil then
			Event_Mappings[ev] = #Event_Mappings+1
		end

		--Create ID mappings for event functions
		if Event_IDs[id] == nil then
			Event_IDs[id] = #Event_IDs+1
		end

		if Events[Event_Mappings[ev]] == nil then
			Events[Event_Mappings[ev]] = {}
		end

		Events[Event_Mappings[ev]][Event_IDs[id]] = func
	end
end

local function Remove(ev,id) --Should be number based now?
	if Events[Event_Mappings[ev]] and Event_IDs[id] then
		Events[Event_Mappings[ev]][Event_IDs[id]] = nil
		Event_IDs[id] = nil
	end
end


--[[
	Changes being made to Call and run:
		1. Run function will be having everything inline rather than calling the Call function inside it.
			Need to get Call function fully working first tho
		2. No use of pairs/ipairs, better to do a numerical for loop instead. Basically thanks to the Event and Event ID mappings we don't have the hook table stored as strings.
		3. Changing how the gm variable is used, this way we can keep shit running smooth
]]
local function Call(ev,gm,...) --Some things run, some don't. Look into this later
	local id = Event_Mappings[ev]

	--We did this because of the retarded gm parameter
	if gm then
		if Events[id] then
			for k = 1,#Events[id] do 
				local v = Events[id][i]
				
				if v then
					local a,b,c,d,e,f = v(k,...)

					if a then
						return a,b,c,d,e,f
					end
				end
			end
		end

		if gm[id] then
			return gm[id](gm,...)
		end
	else
		if Events[id] then
			for k = 1,#Events[id] do 
				local v = Events[id][i]
				if v then
					return v(...)
				end
			end
		end
	end
end

local function Run(ev,...) --Do not fucking use hook.Run you dipshits(This is just for compatibility stuff.) Also seems to suffer some issues like hook.Call does
	local id = Event_Mappings[ev]

	if Events[id] then
		for k = 1,#Events[id] do 
			local v = Events[id][i]
			if v then
				return v(...)
			end
		end
	end

	if GetGamemode().event then
		return GetGamemode().ev(gm,...)
	end
end


--[[
	Changes being made to GetTable:
		1. raw and cback variables added
			raw - Disables the cleaning of the table using mappings we stored.
					Events table will be returned as is. every index will be represented by its number rather than its string mapping
			cback - A optional callback function that will perform an operation on the Events table before returning it.
					Callback function has the Events table passed into it.
			
		2. When GetTable function is not returning raw we will need to use the mappings so that things are presented as a readable table for other things
]]
local function GetTable(raw,cback) --Rework this later to replace the numbers with their string mappings(it will be slower but fuck it, can't be helped. Besides hook.Call being faster is more important than this)
	if cback then
		cback(Events)
	end

	if raw then
		return Events
	else
		return Events
	end
end


--[[
	Additional functions for the hook library:
		Exists - Checks if a given hook exists based on the mappings provided
]]
local function Exists(ev,id) --Checks if a given hook has already been added
	return (Event_Mappings[ev]) and (Events_IDs[id])
end


--Make this shit accessible elsewhere
hook = {
	Add = Add,
	Remove = Remove,
	Call = Call,
	Run = Run,
	GetTable = GetTable,
	Exists = Exists
}

