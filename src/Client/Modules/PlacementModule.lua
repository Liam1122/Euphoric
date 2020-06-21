-- Placement Module
-- AspectType
-- June 21, 2020



local PlacementModule = {}
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Debounce

local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Items = ReplicatedStorage:WaitForChild("Placements")

function GetItemFromName(Name)
    local Item = Items:FindFirstChild(Name):Clone()
    Item.Parent = workspace.Placing
    for index,Part in pairs(Item:GetDescendants()) do
        if Part:IsA("BasePart") or Part:IsA("MeshPart") and Part.Transparency ~= 1 then
            Part.Transparency = 0.85
            Part.CanCollide = false
            Part.Color = Color3.fromRGB(98,255,98)
        end
    end
    PlacementModule.Maid:GiveTask(Item)
    return Item
end


function PlacementModule:StartPlacing(PlacementItemName)
    self.SelectedPlacement = GetItemFromName(PlacementItemName)
    self.Placing = true
    self.Deleting = false
    self.CurrentRot = 0
    self.Maid:GiveTask(RunService.RenderStepped:Connect(function()
        if Mouse.Target == nil then return end
        local ScreenPointRay = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
        local ray = Ray.new(ScreenPointRay.Origin, ScreenPointRay.Direction * 100)
        local HitPart, Position, Normal = workspace:FindPartOnRayWithWhitelist(ray, {workspace.Properties})
        if HitPart == nil then return end
        if HitPart:IsDescendantOf(workspace.Properties) then
            self.SelectedPlacement:SetPrimaryPartCFrame(CFrame.new(Position, Position+Normal*15) * CFrame.Angles(math.rad(-90), math.rad(self.CurrentRot), 0))
            self.CurrentPlacementCFrame = self.SelectedPlacement:GetPrimaryPartCFrame()
        else
            self.SelectedPlacement:SetPrimaryPartCFrame(CFrame.new(0,-70,0))
            self.CurrentPlacementCFrame = nil
        end
    end))

    local Keyboard = self.Input:Get("Keyboard")
    self.Maid:GiveTask(Keyboard.KeyDown:Connect(function(Key)
        print("Rotation is being changed...")
        if Key == Enum.KeyCode.E then
            self.CurrentRot = self.CurrentRot + 5
        elseif Key == Enum.KeyCode.Q then
            self.CurrentRot = self.CurrentRot - 5
        end
    end))

   local InputMouse = self.Input:Get("Mouse")
   self.Maid:GiveTask(InputMouse.LeftDown:Connect(function()
        if self.CurrentPlacementCFrame == nil then return end
        if Debounce then return end
        Debounce = true
        print("Place at: " .. tostring(self.CurrentPlacementCFrame))
        self.Services.PlacementService.PlaceObject:Fire(self.SelectedPlacement.Name, self.CurrentPlacementCFrame)
        wait(0.4)
        Debounce = false
   end))
   --[[self.MaidGiveTask(InputMouse.Scrolled:Connect(function(amt)
        if not Keyboard:IsDown(Enum.KeyCode.LeftShift) then return end
        if amt == -1 then
            self.CurrentRot = self.CurrentRot - 10
        else
            self.CurrentRot = self.CurrentRot + 10
        end
    end))]]
end

function PlacementModule:StopPlacing()
    self.Maid:DoCleaning()
end



function PlacementModule:Init()
    self.SelectedPlacement = nil
    self.CurrentPlacementCFrame = nil
    self.Placing = false
    self.Deleting = false
    Debounce = false
    self.CurrentRot = 0
    self.Maid = self.Shared.Maid.new()
    self.Input = self.Controllers.UserInput
end


return PlacementModule