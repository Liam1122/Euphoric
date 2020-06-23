-- Data Service
-- AspectType
-- June 16, 2020



local DataService = {Client = {}}
local Players = game:GetService("Players")

function GetDefaultData(DataName)
    if DataName == "Inventory" then
        return {}
    end
    if DataName == "Ammo" then
        return {["GUN NAME"] = 123}
    end
    if DataName == "Plots" then
        return {
            SmallStore = {}
        }
    end
    if DataName == "Cash" then
        return 350
    end
    if DataName == "PlayTime" then
        return 0
    end
end

local DataStoreTypes = {"Cash", "Inventory", "Ammo", "Plots", "PlayTime"}

function DataService:Start()
    for _, DataName in pairs(DataStoreTypes) do
        self.DataStore2.Combine(self.MainKey, DataName)
    end

    Players.PlayerAdded:Connect(function(Player)
        for _, DataName in pairs(DataStoreTypes) do
            local Store,Data = self:GetData(Player, DataName)
            Store:OnUpdate(function(NewValue)
                print(DataName .. ", has been updated!\nNew Val: " .. NewValue)
                self:FireClient("UpdateData", Player, DataName, NewValue)
            end)
            --Test
            if DataName == "Plots" then
                local ItemName = nil
                for i,v in pairs(Data.SmallStore) do
                    for index, objName in pairs(self.Shared.ItemInfo) do
                        if objName.Id == v.I then
                            ItemName = index
                        end
                    end  
                    local ItemToPlace = game.ReplicatedStorage.Placements:FindFirstChild(ItemName):Clone()
                    ItemToPlace.Parent = workspace
                    ItemToPlace:SetPrimaryPartCFrame(self.Shared.CFrameSerializer:DecodeCFrame(v.C))
                end
            end
        end

        while wait(60) do
            self:ModifyPlaytime(Player, 1)
        end

    end)

end


function DataService:GetData(Player, DataType)
    local QueriedDataStore = self.DataStore2(DataType, Player)
    local SearchResult = QueriedDataStore:Get(GetDefaultData(DataType))
    if typeof(SearchResult) == "table" then
        self.TableUtil.Print(SearchResult, string.format("%s's %s Data", Player.Name, DataType), true)
    end
    return QueriedDataStore, SearchResult -- Returns the Store, and the data.
end

function DataService:ModifyCash(Player, Amount)
    local Store, Data = self:GetData(Player, "Cash")
    Data = Data + Amount
    Store:Set(Data)
end

function DataService:ModifyPlaytime(Player, Amount)
    local Store, Data = self:GetData(Player, "PlayTime")
    Data = Data + Amount
    Store:Set(Data)
end

function DataService:GetPlotData(Player)
    return self:GetData(Player, "Plots")
end

function DataService:UpdatePlot(NewData, PlotType)
    self.TableUtil.Print(NewData, string.format("[%s] Plot Data", PlotType), true)
end

function DataService:Init()
    self.DataStore2 = self.Modules.DataStore2
    self.TableUtil = self.Shared.TableUtil
    self.MainKey = "Testy1"
    self:RegisterClientEvent("UpdateData")
end


return DataService