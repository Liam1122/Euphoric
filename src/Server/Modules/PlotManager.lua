-- Plot Manager
-- AspectType
-- June 23, 2020



local PlotManager = {}

local ItemInfo;
local DataService;
local HelperFunctions;
local CFrameSerializer;
local TableUtil;

function PlotManager:RegisterItem(Player, Item)
    local Plot = HelperFunctions:GetPlayerPlot(Player)
    if Plot == nil then return end
    local Store, Data = DataService:GetPlotData(Player, Plot.Info.PlotType.Value)
    table.insert(Data[Plot.Info.PlotType.Value], #Plot.Placements:GetChildren(), {
        I = ItemInfo[Item.Name].Id,
        C = CFrameSerializer:EncodeCFrame(Item.PrimaryPart.CFrame)
    })
    Store:Set(Data)
    return Data, Plot.Info.PlotType.Value
end

function PlotManager:Start()
end

function PlotManager:Init()
    ItemInfo = self.Shared.ItemInfo
    DataService = self.Services.DataService
    HelperFunctions = self.Shared.HelperFunctions
    CFrameSerializer = self.Shared.CFrameSerializer
    TableUtil = self.Shared.TableUtil
end

return PlotManager