-- Interaction Controller
-- AspectType
-- June 16, 2020



local InteractionController = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local TweenService = game:GetService("TweenService")

local Character = Player.Character or Player.CharacterAdded:Wait()
local HumRoot = Character:WaitForChild("HumanoidRootPart")

local MainUI
local InteractUI


local InteractionModules;



function Disable()
    for i,v in pairs(InteractUI.Main:GetChildren()) do
		if v:IsA("ImageLabel") then
			v.Visible = false
		end
	end
end

function InteractionController:ForceQuit()
    InteractUI.Adornee = nil
end

function InteractionController:Start()
    RunService.Heartbeat:Connect(function()
        if self.Modules.PlacementModule:IsActive() then return end
        if Mouse.Target == nil then InteractUI.Adornee = nil Disable() return end
        local PossibleInteraction = Mouse.Target.Name == "Interact" and Mouse.Target.Parent:FindFirstChild("Info") and Mouse.Target
		if not PossibleInteraction then InteractUI.Adornee = nil Disable() return end
		local Model = PossibleInteraction.Parent
		if (Model.Interact.Position - HumRoot.Position).magnitude > 5.9 then InteractUI.Adornee = nil Disable() return end
		if self.ItemInfo[Model.Name].ItemType == "Door" or self.ItemInfo[Model.Name].ItemType == "Window" then
			InteractUI.Main.E.InteractText.Text = Model.Info.Open.Value and "CLOSE" or "OPEN"
			InteractUI.Main.F.InteractText.Text = Model.Info.Locked.Value and "UNLOCK" or "LOCK"
		--elseif Model.Info.ItemType.Value == "car" then
        end
        
		for index,KeyName in pairs(self.ItemInfo[Model.Name].Interactions) do
			InteractUI.Main[KeyName].Visible = true
        end
        InteractUI.Adornee = Model.Interact
    end)

    local Keyboard = self.Input:Get("Keyboard")
    Keyboard.KeyDown:Connect(function(KeyCode)
        if self.Modules.PlacementModule:IsActive() then return end
        if InteractUI.Adornee == nil then return end
        local InteractionObject = InteractUI.Adornee.Parent
        if KeyCode == Enum.KeyCode.E then
            local Result = self.Services.InteractionService:Interact(InteractionObject)
            if Result == nil then return end -- Because the server noticed the door is on cooldown or they dont have access, so we won't do anything.
            InteractionModules[self.ItemInfo[InteractionObject.Name].ItemType]:InteractWith(InteractionObject, Result, true)
        elseif KeyCode == Enum.KeyCode.F then
            if not InteractUI.Main.F.Visible then return end
            self.Services.InteractionService:LockUnlock(InteractionObject)
        end
    end)

    self.Services.InteractionService.InteractionReplication:Connect(function(InteractionObject, OpenClose)
        print(InteractionObject.Name .. " || " .. OpenClose)
        local IsNearby = (InteractionObject.Interact.Position - HumRoot.Position).magnitude < 120 and true or false
        print(IsNearby)
        local Info = self.ItemInfo[InteractionObject.Name]
        InteractionModules[Info.ItemType]:InteractWith(InteractionObject, OpenClose, IsNearby)
   end)

    wait(5)
    self.Modules.PlacementModule:StartPlacing("Door")
    wait(10)
    self.Modules.PlacementModule:StopPlacing()
    wait(10)
    self.Modules.PlacementModule:ActivateDeleteMode()
    wait(10)
    self.Modules.PlacementModule:DeactivateDeleteMode()
end


function InteractionController:Init()
    self.ItemInfo = self.Shared.ItemInfo
    self.Input = self.Controllers.UserInput
    MainUI = Player:WaitForChild("PlayerGui"):WaitForChild("MainUI")
    InteractUI = MainUI:WaitForChild("Interact")

    print(self.Modules.InteractionModules.Door)
    InteractionModules = self.Modules.InteractionModules;
     
end

return InteractionController