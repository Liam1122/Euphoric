-- Door
-- AspectType
-- June 18, 2020



local Door = {}
local TweenService = game:GetService("TweenService")

function Tween(InteractionObject, Result)
    InteractionObject.Main.CanCollide = Result == "Close" and true or false
    TweenService:Create(InteractionObject.Hinge, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
        CFrame = InteractionObject.Hinge.CFrame * CFrame.Angles(0, math.rad(Result == "Open" and 90 or -90), 0)
   }):Play()
end

function SetCFrame(InteractionObject, Result)
    for i,v in pairs(InteractionObject:GetChildren()) do
        print(v.Name)
    end
    InteractionObject.Hinge.CFrame = InteractionObject.Hinge.CFrame * CFrame.Angles(0, math.rad(Result == "Open" and 90 or -90), 0)
end

function Door:InteractWith(...)
    local args = {...}
    print(args[3])
    if args[3] then
        Tween(...)
    else
        SetCFrame(...)
    end
end


return Door