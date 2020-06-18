-- Window
-- AspectType
-- June 18, 2020



local Window = {}
local TweenService = game:GetService("TweenService")

function Tween(InteractionObject, Result)
    InteractionObject.Main.CanCollide = Result == "Close" and true or false
    TweenService:Create(InteractionObject.Main, TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
        CFrame = InteractionObject.Main.CFrame * CFrame.new(0, Result == "Open" and 2.6 or -2.6, 0)
   }):Play()
end

function SetCFrame(InteractionObject, Result)
    InteractionObject.Main.CFrame = InteractionObject.Main.CFrame * CFrame.new(0, math.rad(Result == "Open" and 2.6 or -2.6), 0)
end

function Window:HandleTween(...)
    local args = {...}
    print(args[3])
    if args[3] then
        Tween(...)
    else
        SetCFrame(...)
    end
end

return Window