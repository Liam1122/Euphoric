-- Interaction Service
-- AspectType
-- June 16, 2020



local InteractionService = {Client = {}}

local Door;

local InteractionModules = {
    Door;
    Window;
}

local ItemInfo;

function InteractionService.Client:Interact(Player, InteractionObject)
    print("Interact has been called from the client!")
    print(Player.Name .. " wants to open " .. InteractionObject.Name)
    local Info = InteractionObject.Info
    if Info.Debounce.Value then return end
    local ItemType = ItemInfo[InteractionObject.Name].ItemType
    return InteractionModules[ItemType]:InteractWith(Player, InteractionObject)
    --return OpenClose
end

function InteractionService:Start()
    
end


function InteractionService:Init()
    self:RegisterClientEvent("InteractionReplication")
    ItemInfo = self.Shared.ItemInfo
    InteractionModules.Door = self.Modules.Door
    InteractionModules.Window = self.Modules.Window
end


return InteractionService