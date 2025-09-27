--// LocalScript - Place in StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SetClipboard = setclipboard or toclipboard -- For copying links
local player = Players.LocalPlayer

-- 🎨 Theme: Indigo Glow
local theme = {
    MainColor   = Color3.fromRGB(111, 66, 255),     -- Bright indigo glow
    Accent      = Color3.fromRGB(150, 90, 255),     -- Soft glowing violet
    Background  = Color3.fromRGB(20, 15, 40),       -- Deep night indigo background
    Header      = Color3.fromRGB(40, 25, 70),       -- Rich indigo for header
    Font        = Enum.Font.GothamBold,
    TextColor   = Color3.fromRGB(230, 220, 255)     -- Soft glowing light indigo-white text
}

-- Helpers
local function roundify(obj, rad)
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, rad or 10)
    uic.Parent = obj
end

local function addShadow(obj)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.Size = UDim2.new(1, 14, 1, 14)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = obj.ZIndex - 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(80, 50, 200) -- Indigo glow shadow
    shadow.ImageTransparency = 0.25
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = obj
end

local function hoverAnim(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.18), {
            BackgroundColor3 = theme.MainColor,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.18), {
            BackgroundColor3 = theme.Accent,
            TextColor3 = theme.TextColor
        }):Play()
    end)
end

local function clickAnim(btn)
    local originalSize = btn.Size
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            Size = originalSize - UDim2.new(0,4,0,4)
        }):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {
            Size = originalSize
        }):Play()
    end)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MakHub"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 560, 0, 400)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
mainFrame.BackgroundColor3 = theme.Background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
roundify(mainFrame, 14)
addShadow(mainFrame)

-- Topbar
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 42)
topbar.BackgroundColor3 = theme.Header
topbar.BorderSizePixel = 0
topbar.Parent = mainFrame
roundify(topbar, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Font = theme.Font
title.Text = "🌌 MakHub"
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = theme.MainColor
title.Parent = topbar

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 35, 1, -6)
minBtn.Position = UDim2.new(1, -75, 0, 3)
minBtn.Text = "—"
minBtn.Font = theme.Font
minBtn.TextSize = 22
minBtn.TextColor3 = theme.TextColor
minBtn.BackgroundColor3 = theme.Accent
minBtn.BorderSizePixel = 0
minBtn.Parent = topbar
roundify(minBtn, 8)
hoverAnim(minBtn)
clickAnim(minBtn)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 1, -6)
closeBtn.Position = UDim2.new(1, -38, 0, 3)
closeBtn.Text = "✖"
closeBtn.Font = theme.Font
closeBtn.TextSize = 20
closeBtn.TextColor3 = theme.TextColor
closeBtn.BackgroundColor3 = theme.Accent
closeBtn.BorderSizePixel = 0
closeBtn.Parent = topbar
roundify(closeBtn, 8)
hoverAnim(closeBtn)
clickAnim(closeBtn)

-- Open Button
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 160, 0, 45)
openBtn.Position = UDim2.new(0, 20, 0, 20)
openBtn.Text = "🌌 Open MakHub"
openBtn.Font = theme.Font
openBtn.TextSize = 20
openBtn.TextColor3 = theme.TextColor
openBtn.BackgroundColor3 = theme.Accent
openBtn.BorderSizePixel = 0
openBtn.Visible = false
openBtn.Parent = gui
roundify(openBtn, 12)
hoverAnim(openBtn)
clickAnim(openBtn)

-- Minimize & Close Logic
minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Hotkey Toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- Tabs
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(0, 160, 1, -42)
tabFrame.Position = UDim2.new(0, 0, 0, 42)
tabFrame.BackgroundColor3 = theme.Accent
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame
roundify(tabFrame, 14)

local pages = Instance.new("Frame")
pages.Size = UDim2.new(1, -160, 1, -42)
pages.Position = UDim2.new(0, 160, 0, 42)
pages.BackgroundColor3 = theme.Background
pages.BorderSizePixel = 0
pages.Parent = mainFrame
roundify(pages, 14)

local tabs = {"Gamepasses","Settings","About"}
local tabButtons = {}
local pageFrames = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 42)
    btn.Position = UDim2.new(0, 10, 0, (i-1)*50 + 15)
    btn.Text = name
    btn.Font = theme.Font
    btn.TextSize = 20
    btn.TextColor3 = theme.TextColor
    btn.BackgroundColor3 = theme.Accent
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    roundify(btn, 10)
    hoverAnim(btn)
    clickAnim(btn)
    tabButtons[name] = btn

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = pages
    pageFrames[name] = page
end

pageFrames["Gamepasses"].Visible = true

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pageFrames) do
            p.Visible = false
        end
        pageFrames[name].Visible = true
    end)
end

-- Gamepasses Page
local gpBtn = Instance.new("TextButton")
gpBtn.Size = UDim2.new(0, 220, 0, 50)
gpBtn.Position = UDim2.new(0, 30, 0, 30)
gpBtn.Text = "✅ Get All Gamepasses"
gpBtn.Font = theme.Font
gpBtn.TextSize = 22
gpBtn.TextColor3 = theme.TextColor
gpBtn.BackgroundColor3 = theme.Accent
gpBtn.Parent = pageFrames["Gamepasses"]
roundify(gpBtn, 12)
hoverAnim(gpBtn)
clickAnim(gpBtn)

local gamepassList = {
    "x2_earnings","vip","tail_logo","skilled_pilots",
    "premium_room","premium_flight_attendant","multiplayer",
    "extra_design","emergency_control","elite_influencers",
    "custom_music","custom_lighting"
}

gpBtn.MouseButton1Click:Connect(function()
    local data = player:FindFirstChild("data")
    if data then
        local purchases = data:FindFirstChild("purchases")
        if purchases then
            local gamepasses = purchases:FindFirstChild("gamepasses")
            if gamepasses then
                for _, name in ipairs(gamepassList) do
                    local value = gamepasses:FindFirstChild(name)
                    if value and value:IsA("BoolValue") then
                        value.Value = true
                    end
                end
            end
        end
    end
end)

-- Settings Page
local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, -20, 0, 30)
settingsLabel.Position = UDim2.new(0, 15, 0, 20)
settingsLabel.Text = "⚙️ Settings coming soon..."
settingsLabel.Font = theme.Font
settingsLabel.TextSize = 22
settingsLabel.TextColor3 = theme.TextColor
settingsLabel.BackgroundTransparency = 1
settingsLabel.Parent = pageFrames["Settings"]

-- About Page
local aboutLabel = Instance.new("TextLabel")
aboutLabel.Size = UDim2.new(1, -20, 0, 30)
aboutLabel.Position = UDim2.new(0, 15, 0, 20)
aboutLabel.Text = "🌟 Join our Discord!"
aboutLabel.Font = theme.Font
aboutLabel.TextSize = 22
aboutLabel.TextColor3 = theme.TextColor
aboutLabel.BackgroundTransparency = 1
aboutLabel.Parent = pageFrames["About"]

local discBtn = Instance.new("TextButton")
discBtn.Size = UDim2.new(0, 230, 0, 45)
discBtn.Position = UDim2.new(0, 20, 0, 70)
discBtn.Text = "🔗 Copy Discord Invite"
discBtn.Font = theme.Font
discBtn.TextSize = 20
discBtn.TextColor3 = theme.TextColor
discBtn.BackgroundColor3 = theme.Accent
discBtn.Parent = pageFrames["About"]
roundify(discBtn, 12)
hoverAnim(discBtn)
clickAnim(discBtn)

discBtn.MouseButton1Click:Connect(function()
    if SetClipboard then
        SetClipboard(https://discord.gg/tBNQqxzPHh")
    end
end)