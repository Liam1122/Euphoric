-- Role Info
-- AspectType
-- June 19, 2020



local RoleInfo = {}

RoleInfo.Special = {
    Owner = {
        UserIds = {1130742011},
        Info = {
            Text = "[OWNER]",
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(255, 0, 255)
        }
    },

    Developer = {
        UserIds = {},
        Info = {
            Text = "[DEVELOPER]",
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(112, 10, 255)
        }
    },

    Admin = {
        UserIds = {},
        Info = {
            Text = "[ADMIN]",
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(255, 154, 3)
        }
    }

    --Anymore????
}


return RoleInfo