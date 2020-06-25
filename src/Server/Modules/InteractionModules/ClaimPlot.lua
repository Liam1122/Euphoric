-- Claim Plot
-- AspectType
-- June 25, 2020



local ClaimPlot = {}

function ClaimPlot:InteractWith(Player, InteractionObject)
    print(Player.Name .. ", wants to Interact with '" .. InteractionObject.Name .. "', thus been sent to " .. script.Name)
    local Plot = InteractionObject.Parent
    print(Plot.Info.Owner.Value)
    return InteractionObject.Parent.Name
end


return ClaimPlot