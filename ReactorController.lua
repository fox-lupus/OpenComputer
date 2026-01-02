local componet = require("component")
local sides = require("sides")
local reactors = {}
local adapters = {}

local function set_reactors_active(reactors, running) 
    for _, reactor in pairs(reactors) do
     reactor.setActive(running)
    end
end

for address, name in componet.list("reactor") do
    table.insert(reactors, componet.proxy(address))
end
for address, name in componet.list("transposer") do
    table.insert(adapters, componet.proxy(address))
end

while true do
    --check all inventory controllers
    for _, adapter in pairs(adapters) do
        for slot=1, adapter.getInventorySize(0) do
            local item = adapter.getStackInSlot(0, slot)
            if item then 
                --print(item.name)
                --print(item.damage)
                if item.name == "gregtech:gt.360k_Helium_Coolantcell" and item.damage > 80 then
                    print("swapping " .. slot)
                    set_reactors_active(reactors, false) --stop all reactors
                    for destSlots=1, adapter.getInventorySize(1) do
                        local empty = adapter.getStackInSlot(1, destSlots)
                        if empty then
                            adapter.transferItem(0, 1, 1, slot, destSlots)
                            break
                        end
                    end
                    for destSlots=1, adapter.getInventorySize(1) do
                        local empty = adapter.getStackInSlot(1, destSlots)
                        if empty ~= nil and empty.name == "gregtech:gt.360k_Helium_Coolantcell" and empty.damage == 0 then
                            adapter.transferItem(1, 0, 1, destSlots, slot)
                            break
                        end
                    end

                    set_reactors_active(reactors, true) 
                end
            else
                --print("slot " .. slot .. " is empty")
            end
        end
    end

    for _, reactor in pairs(reactors) do
        reactor.setActive(reactor.getHeat() < 2000)
    end
end
