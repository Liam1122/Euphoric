-- Window
-- AspectType
-- June 18, 2020



local Window = {}

function Window:InteractWith(Player, InteractionObject)
    print(Player.Name .. ", wants to Interact with '" .. InteractionObject.Name .. "', thus been sent to " .. script.Name)

    local Info = InteractionObject:FindFirstChild("Info")

    Info.Debounce.Value = true
    Info.Open.Value = not Info.Open.Value

    local OpenClose = Info.Open.Value and "Open" or "Close" 

    --Without Line 21, we'd see that when users join, the door will not be correctly synced with the client & other clients..
    --So, to get around this, we will wait for the client's animations to finish, then CFrame it directly on the server to update the Status of the Door.
    delay(1.1, function()
        InteractionObject.Main.CFrame = InteractionObject.Main.CFrame * CFrame.new(0, OpenClose == "Open" and 2.6 or -2.6, 0)
        Info.Debounce.Value = false
    end)

    self.Services.InteractionService:FireOtherClients("InteractionReplication", Player,  InteractionObject, OpenClose)
    return OpenClose
    
end

return Window