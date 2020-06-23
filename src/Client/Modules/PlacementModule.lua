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
    PlacementModule.PlacementMaid:GiveTask(Item)
    return Item
end

function PlacementModule:IsActive()
    if self.Placing or self.Deleting then
        return true
    end
    return false
end

function PlacementModule:StartPlacing(PlacementItemName)
    self.Controllers.InteractionController:ForceQuit()
    self.SelectedPlacement = GetItemFromName(PlacementItemName)
    self.Placing = true
    self.Deleting = false
    self.CurrentRot = 0
    self.PlacementMaid:GiveTask(RunService.RenderStepped:Connect(function()
        if Mouse.Target == nil then return end
        local ScreenPointRay = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
        local ray = Ray.new(ScreenPointRay.Origin, ScreenPointRay.Direction * 100)
        local HitPart, Position, Normal = workspace:FindPartOnRayWithWhitelist(ray, {workspace.Properties})
        if HitPart == nil then return end
        if HitPart:IsDescendantOf(workspace.Properties) then
            --self.SelectedPlacement:SetPrimaryPartCFrame(CFrame.new(Position, Position+Normal*15) * CFrame.Angles(math.rad(-90), math.rad(self.CurrentRot), 0))
            self.SelectedPlacement:SetPrimaryPartCFrame(CFrame.new(Position, Position+Normal*15) * CFrame.Angles(math.rad(-90), math.rad(self.CurrentRot), 0))
            self.CurrentPlacementCFrame = self.SelectedPlacement:GetPrimaryPartCFrame()
        else
            self.SelectedPlacement:SetPrimaryPartCFrame(CFrame.new(0,-70,0))
            self.CurrentPlacementCFrame = nil
        end
    end))

    
    self.PlacementMaid:GiveTask(self.Keyboard.KeyDown:Connect(function(Key)
        print("Rotation is being changed...")
        if Key == Enum.KeyCode.E then
            self.CurrentRot = self.CurrentRot + 5
        elseif Key == Enum.KeyCode.Q then
            self.CurrentRot = self.CurrentRot - 5
        end
    end))

   self.PlacementMaid:GiveTask(self.Mouse.LeftDown:Connect(function()
        if self.SelectedPlacement == nil then return end
        if Debounce then return end
        Debounce = true
        print("Place at: " .. tostring(self.CurrentPlacementCFrame))
        self.Services.PlacementService.PlaceObject:Fire(self.SelectedPlacement.Name, self.CurrentPlacementCFrame)
        wait(0.4)
        Debounce = false
   end))
   --[[self.PlacementMaidGiveTask(InputMouse.Scrolled:Connect(function(amt)
        if not Keyboard:IsDown(Enum.KeyCode.LeftShift) then return end
        if amt == -1 then
            self.CurrentRot = self.CurrentRot - 10
        else
            self.CurrentRot = self.CurrentRot + 10
        end
    end))]]
end

function CreateSelectionBox()
    local SelectionBox = Instance.new("SelectionBox")
    SelectionBox.LineThickness = -1
    SelectionBox.SurfaceTransparency = 0
    SelectionBox.SurfaceColor3 = Color3.fromRGB(255,98,98)
    SelectionBox.Transparency = 0
    SelectionBox.Parent = script
    SelectionBox.Parent = workspace.Placing
    return SelectionBox
end

function PlacementModule:ActivateDeleteMode()
    self.Controllers.InteractionController:ForceQuit()
    self.Placing = false
    self.Deleting = true
    local SelectionBox = CreateSelectionBox()
    self.DeleteMaid:GiveTask(SelectionBox)
    self.DeleteMaid:GiveTask(RunService.RenderStepped:Connect(function()
        if Mouse.Target == nil then SelectionBox.Adornee = nil return end
        local PossiblePlacementModel = Mouse.Target.Parent:IsA("Model") and Mouse.Target.Parent or Mouse.Target:IsA("Model") and Mouse.Target
        if PossiblePlacementModel.Name == "Decor" then
            PossiblePlacementModel = PossiblePlacementModel.Parent
        else
            SelectionBox.Adornee = nil
        end
        if PossiblePlacementModel.Parent.Name ~= "Placements" then SelectionBox.Adornee = nil return end
        if Mouse.Target:IsDescendantOf(workspace.Properties) and PossiblePlacementModel then
            SelectionBox.Adornee = PossiblePlacementModel
        else
            SelectionBox.Adornee = nil
        end
    end))

    self.DeleteMaid:GiveTask(self.Mouse.LeftDown:Connect(function()
        if SelectionBox == nil or SelectionBox.Adornee == nil then return end
        --Client side test
        self.Services.PlacementService.DestroyObject:Fire(SelectionBox.Adornee)
        SelectionBox.Adornee:Destroy()
    end))
end

function PlacementModule:StopPlacing()
    self.Placing = false
    self.PlacementMaid:DoCleaning()
end

function PlacementModule:Init()
    self.SelectedPlacement = nil
    self.CurrentPlacementCFrame = nil
    self.Placing = false
    self.Deleting = false
    Debounce = false
    self.CurrentRot = 0
    self.PlacementMaid = self.Shared.Maid.new()
    self.DeleteMaid = self.Shared.Maid.new()
    self.Input = self.Controllers.UserInput
    self.Keyboard = self.Controllers.UserInput:Get("Keyboard")
    self.Mouse = self.Controllers.UserInput:Get("Mouse")
end


return PlacementModule