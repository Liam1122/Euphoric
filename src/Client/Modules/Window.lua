-- Window
-- AspectType
-- June 18, 2020



local Window = {}


function Window:HandleTween(InteractionObject, OpenClose, IsNearby)
    print(InteractionObject.Name, OpenClose, IsNearby)
end

return Window