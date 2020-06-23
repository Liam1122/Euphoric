-- Helper Functions
-- AspectType
-- June 23, 2020



local HelperFunctions = {}

function HelperFunctions:GetPlayerPlot(Player)
    for _, Plot in pairs(workspace.Properties:GetChildren()) do
        if Plot.Info.Owner.Value == Player then
            return Plot
        end
    end
    return nil
end


return HelperFunctions