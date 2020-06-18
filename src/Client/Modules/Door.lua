-- Door
-- AspectType
-- June 18, 2020



local Door = {}

function Door:HandleTween(InteractionObject, OpenClose, IsNearby)
    print(InteractionObject.Name, OpenClose, IsNearby)
end


return Door