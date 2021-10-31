require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"

local distributionTable = {

    --- StoreShelfMechanics
    {
        location = "ProceduralDistributions.list.StoreShelfMechanics.items",
        items = {
            {"CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan", 5},
        },
    },

    --- GarageMechanic
    {
        location = "ProceduralDistributions.list.GarageMechanic.items",
        items = {
            {"CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan", 3},
        },
    },

    --- GarageMechanic
    {
        location = "SuburbsDistributions.all.bin.items",
        items = {
            {"CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan", 1},
        },
    },

    --- FridgeBottles
    {
        location = "ProceduralDistributions.list.FridgeBottles.items",
        items = {
            {"CocoLiquidOverhaulItems.Coco_WaterGallonFull", 2},
        },
    },

    --- GigamartBottles
    {
        location = "ProceduralDistributions.list.GigamartBottles.items",
        items = {
            {"CocoLiquidOverhaulItems.Coco_WaterGallonFull", 4},
        },
    },

    --- KitchenBottles
    {
        location = "ProceduralDistributions.list.KitchenBottles.items",
        items = {
            {"CocoLiquidOverhaulItems.Coco_WaterGallonFull", 2},
        },
    },
}

------------------------------------------------------------------------------------------------------

--- split string by character
local function split(s)
    result = {}
    for i in string.gmatch(s, "[^%.]+") do
        table.insert(result, i)
    end
    return result
end

--- getLocation function
local function getLocation(locationParts)
    if locationParts then
        local partCount = #locationParts
        local location = ProceduralDistributions
        local locationString = locationParts[1]

        if locationParts[1] == "SuburbsDistributions" then
            location = SuburbsDistributions
        elseif locationParts[1] == "ProceduralDistributions" then
            location = ProceduralDistributions
        else
            return nil
        end

        for i=2, #locationParts do
            if location[locationParts[i]] then
                locationString = locationString .. "-" .. locationParts[i]
                location = location[locationParts[i]]
            end
            if i >= partCount then
                return location
            end
        end
    end
end

--- add function
local function add(location, item, odd)
    table.insert(location, item)
    table.insert(location, odd)
end

--- process
for t=1, #distributionTable do
    local table = distributionTable[t]
    local locationParts = split(table.location)
    local location = getLocation(locationParts)

    if location then
        for e=1, #table.items do
            local item = table.items[e][1]
            local odd = table.items[e][2]

            if not pcall(add, location, item, odd) then
                print("CLO: Error distribution adding table '"..item.."':'"..odd.."' at '"..table.location.."'!")
            else
                print("CLO: Distribution added '"..item.."':'"..odd.."' to table '"..table.location.."'!")
            end
        end
    else
        print("CLO: Error distribution invalid location at '"..table.location.."'!")
    end
end
