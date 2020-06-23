-- Data Controller
-- AspectType
-- June 23, 2020



local DataController = {}


function DataController:Start()
    self.Services.DataService.UpdateData:Connect(function(DataType, NewValue)
        print(DataType, NewValue)
    end)
end


function DataController:Init()
	
end


return DataController