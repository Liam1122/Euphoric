-- Placement Service
-- AspectType
-- June 21, 2020



local PlacementService = {Client = {}}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Items = ReplicatedStorage:WaitForChild("Placements")

function PlacementService:Start()
    self:ConnectClientEvent("PlaceObject", function(Player, ItemName, CFrame)
        if CFrame == nil then return end
        --print(Player.Name .. ", wants to place something!")
        local checkpart = Instance.new("Part")
        checkpart.Name = "CheckPart"
        checkpart.Transparency = 0
        checkpart.CanCollide = false
        checkpart.Parent = workspace
        if ItemName == nil then return end
        checkpart.CFrame = CFrame
        if string.find(ItemName, "Sign") then
            checkpart.Size = Vector3.new(4, 4, 4)
        else
            print("not sign")
            checkpart.Size = Vector3.new(0.2, 0.2, 0.2)
        end

        local CanPlace = false
        local Plot

        self.Maid:GiveTask(checkpart.Touched:Connect(function() end))

        for i,v in pairs(checkpart:GetTouchingParts()) do
            if v.Name == "Hitbox" then
                CanPlace = true
                Plot = v.Parent
                break
            end
            CanPlace = false
        end

        if CanPlace then
            local Placement = Items:FindFirstChild(ItemName):Clone()
            Placement.Parent = Plot:WaitForChild("Placements")
            Placement:SetPrimaryPartCFrame(CFrame)
            local NewData, PlotType = self.PlotManager:RegisterItem(Player, Placement)
            print(PlotType)
            print("Can place!")
        else
            print("Can't place!")
        end
        self.Maid:DoCleaning()
    end)

    self:ConnectClientEvent("DestroyObject", function(Player, Object)
        if Object == nil then return end
        print(Player.Name .. ", wants to destroy " .. Object.Name)
        if not Object.Parent.Name == "Placements" and Object:IsDescendantOf(workspace.Properties) then return end
        Object:Destroy()
    end)
end


function PlacementService:Init()
    self:RegisterClientEvent("PlaceObject")
    self:RegisterClientEvent("DestroyObject")
    self.PlotManager = self.Modules.PlotManager
    self.Maid = self.Shared.Maid.new()
end


return PlacementService