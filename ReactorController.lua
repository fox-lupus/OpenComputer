local componet = require("component")
local reactors = {}
local adapters = {}
for address, name in componet.list("reactor") do
    table.insert(reactors, componet.proxy(address))
end
for address, name in componet.list("adapter") do
    table.insert(adapters, componet.proxy(address))
end

for _, adapter in pairs(adapters) do
    for i=0, adapter.getInventorySize() do
        local item = adapter.getStackInInteralSlot(i)
        print(item.name)
        print(item.damage)
    end
end

-- for _, reactor in pairs(reactors) do
--     reactor.setActive(reactor.getheat() < 1000)
-- end
