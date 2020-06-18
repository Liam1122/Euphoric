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

function Disable()
    for i,v in pairs(InteractUI.Main:GetChildren()) do
		if v:IsA("ImageLabel") then
			v.Visible = false
		end
	end
end

function InteractionController:Tween(InteractionObject, Deg)
    print("aaa")
    TweenService:Create(InteractionObject, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
        CFrame = InteractionObject.CFrame * CFrame.Angles(0, math.rad(Deg), 0)
   }):Play()
end

function InteractionController:Start()
    RunService.Heartbeat:Connect(function()
        if Mouse.Target == nil then InteractUI.Adornee = nil Disable() return end
        local PossibleInteraction = Mouse.Target.Name == "Interact" and Mouse.Target.Parent:FindFirstChild("Info") and Mouse.Target
		if not PossibleInteraction then InteractUI.Adornee = nil Disable() return end
		local Model = PossibleInteraction.Parent
		if (Model.Interact.Position - HumRoot.Position).magnitude > 5.9 then InteractUI.Adornee = nil Disable() return end
		if self.ItemInfo[Model.Name].ItemType == "Door" or self.ItemInfo[Model.Name].ItemType == "Window" then
			InteractUI.Main.E.InteractText.Text = Model.Info.Open.Value and "CLOSE" or "OPEN"
			InteractUI.Main.F.InteractText.Text = Model.Info.Locked.Value and "UNLOCK" or "LOCK"
		--elseif Model.Info.ItemType.Value == "Window" then
        end
        
		for index,KeyName in pairs(self.ItemInfo[Model.Name].Interactions) do
			InteractUI.Main[KeyName].Visible = true
        end
        InteractUI.Adornee = Model.Interact
    end)

    local Keyboard = self.Input:Get("Keyboard")
    Keyboard.KeyDown:Connect(function(KeyCode)
        if KeyCode == Enum.KeyCode.E then
            if InteractUI.Adornee == nil then return end
            local InteractionObject = InteractUI.Adornee.Parent
            local Result = self.Services.InteractionService:Interact(InteractionObject)
            if Result == nil then return end -- Because the server noticed the door is on cooldown, so we won't do anything.
            if self.ItemInfo[InteractionObject.Name].ItemType == "Door" then
                InteractionObject.Main.CanCollide = Result == "Close" and true or false
                InteractionController:Tween(InteractionObject.Hinge, Result == "Open" and 90 or -90)
            --elseif asdsad
            end
        end
    end)

    self.Services.InteractionService.InteractionReplication:Connect(function(InteractionObject, OpenClose)
        print(InteractionObject.Name .. " || " .. OpenClose)
        local IsNearby = (InteractionObject.Interact.Position - HumRoot.Position).magnitude < 120 and true or false
        print(IsNearby)
        if self.ItemInfo[InteractionObject.Name].ItemType == "Door" then
            if not IsNearby then
                InteractionObject.Hinge.CFrame = InteractionObject.Hinge.CFrame * CFrame.Angles(0, math.rad(OpenClose == "Open" and 90 or -90), 0)
            else
                InteractionObject.Main.CanCollide = OpenClose == "Close" and true or false
                InteractionController:Tween(InteractionObject.Hinge, OpenClose == "Open" and 90 or -90)
            end
        --elseif IS A WINDOW..?

        end
   end)
end


function InteractionController:Init()
    self.ItemInfo = self.Shared.ItemInfo
    self.Input = self.Controllers.UserInput
    MainUI = Player:WaitForChild("PlayerGui"):WaitForChild("MainUI")
    InteractUI = MainUI:WaitForChild("Interact")
end 



return InteractionController