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
    if Info.Locked.Value then
        print("Door is locked")
        return nil
    end
    return InteractionModules[ItemType]:InteractWith(Player, InteractionObject)
end

function InteractionService.Client:LockUnlock(Player, InteractionObject)
    local Info = InteractionObject.Info

    if InteractionObject == nil then return end
    print(Player.Name .. ", wants to lock or unlock" .. InteractionObject.Name)

    --Check if owner first...
    if Info.Owner.Value ~= Player then
        print("You don't have permission to do this")
        return
    end
    Info.Locked.Value = not Info.Locked.Value
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