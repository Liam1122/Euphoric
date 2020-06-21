-- Placement Service
-- AspectType
-- June 21, 2020



local PlacementService = {Client = {}}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Items = ReplicatedStorage:WaitForChild("Placements")

function PlacementService:Start()
    self:ConnectClientEvent("PlaceObject", function(Player, ItemName, CFrame)
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

        local Debounce = false

        local CanPlace = false
        local Plot

        checkpart.Touched:Connect(function(hit)
            if hit.Name == "Hitbox" then
                print("asdsadsad")
                if hit.Parent.Info.Owner.Value == Player then
                    Plot = hit.Parent
                    CanPlace = true
                end
            end
        end)
        wait(0.2)
        if CanPlace then
            local Placement = Items:FindFirstChild(ItemName):Clone()
            Placement.Parent = Plot:WaitForChild("Placements")
            Placement:SetPrimaryPartCFrame(CFrame)
            print("Can place!")
        else
            print("Can't place!")
        end

    end)
end


function PlacementService:Init()
	self:RegisterClientEvent("PlaceObject")
end


return PlacementService