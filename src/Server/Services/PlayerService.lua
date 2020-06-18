-- Player Service
-- AspectType
-- June 16, 2020



local PlayerService = {Client = {}}
local Players = game:GetService("Players")

local DataStore2;


function PlayerService:Start()

    DataStore2.Combine("TestKey", "MainData")

    Players.PlayerAdded:Connect(function(Player)
        local MainPlayerData = DataStore2("MainData", Player)
        local PlayerData = MainPlayerData:Get({
            Cash = 350,
            Inventory = {},
            Ammo = {},
            Plots = {}
        })
        self.TableUtil.Print(PlayerData, Player.Name .. "'s Data", true)
    end)

end


function PlayerService:Init()
    DataStore2 = self.Modules.DataStore2
    self.TableUtil = self.Shared.TableUtil
    self.ServerData = {}
end


return PlayerService