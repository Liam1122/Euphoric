-- Door
-- AspectType
-- June 18, 2020



local Door = {}

function Door:InteractWith(Player, InteractionObject)
    print(Player.Name .. ", wants to Interact with '" .. InteractionObject.Name .. "', thus been sent to " .. script.Name)
end

return Door