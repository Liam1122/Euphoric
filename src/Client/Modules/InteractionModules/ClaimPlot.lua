-- Claim Plot
-- AspectType
-- June 25, 2020



local ClaimPlot = {}
local Player = game.Players.LocalPlayer
local MainUI = Player.PlayerGui:WaitForChild("MainUI")


function ClaimPlot:InteractWith()
    MainUI.ClaimPlot.Visible = true
end


return ClaimPlot