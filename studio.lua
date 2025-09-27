-- MakHub - Model Ungrouper v8.0 (Indigo Glow)
-- Cheat-like GUI Style (NOT a cheat, just tools!)
-- Place this LocalScript in StarterPlayerScripts

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- === Indigo Glow Theme ===
local theme = {
	Main      = Color3.fromRGB(48, 0, 72),      -- Deep indigo background
	Accent    = Color3.fromRGB(140, 90, 255),   -- Indigo-violet accent
	Glow      = Color3.fromRGB(0, 255, 255),    -- Aqua glow
	Text      = Color3.fromRGB(200, 200, 255),  -- Soft light text
	Hover     = Color3.fromRGB(70, 20, 110),    -- Slightly lighter indigo
	Highlight = Color3.fromRGB(120, 0, 200)     -- Selection highlight
}

-- === ScreenGui ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StudioGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

-- === Helpers ===
local function addCorner(obj, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = obj
end

local function addStroke(obj, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = thickness or 2
	stroke.Color = color or theme.Accent
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = obj
end

local function tween(obj, props, time, style, dir)
	TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

-- === OPEN BUTTON ===
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 140, 0, 45)
openButton.Position = UDim2.new(0, 20, 0, 200)
openButton.BackgroundColor3 = theme.Main
openButton.TextColor3 = theme.Accent
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 18
openButton.Text = "Open MakHub"
openButton.Active = true
openButton.Draggable = true
openButton.Parent = screenGui
addCorner(openButton, 10)
addStroke(openButton, theme.Accent, 2)

openButton.MouseEnter:Connect(function()
	tween(openButton, {BackgroundColor3 = theme.Hover}, 0.2)
end)
openButton.MouseLeave:Connect(function()
	tween(openButton, {BackgroundColor3 = theme.Main}, 0.2)
end)

-- === MAIN FRAME ===
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 1, 50)
frame.BackgroundColor3 = theme.Main
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = screenGui
addCorner(frame, 12)
addStroke(frame, theme.Accent, 2)

-- Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.BackgroundColor3 = theme.Hover
title.TextColor3 = theme.Glow
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Text = "MakHub"
title.Parent = frame
addCorner(title, 8)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 120, 140)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = frame
addCorner(closeBtn, 8)

closeBtn.MouseEnter:Connect(function()
	tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(90, 0, 60)}, 0.2)
end)
closeBtn.MouseLeave:Connect(function()
	tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(60, 0, 40)}, 0.2)
end)

-- === Scrolling list for Workspace items ===
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 0, 230)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundColor3 = theme.Hover
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = frame
addCorner(scrollFrame, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

-- === Tool Buttons ===
local toolFrame = Instance.new("Frame")
toolFrame.Size = UDim2.new(1, -20, 0, 150)
toolFrame.Position = UDim2.new(0, 10, 1, -160)
toolFrame.BackgroundTransparency = 1
toolFrame.Parent = frame

local function createToolButton(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.Position = UDim2.new(0, 0, 0, order * 40)
	btn.BackgroundColor3 = theme.Main
	btn.TextColor3 = theme.Accent
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Text = text
	btn.Parent = toolFrame
	addCorner(btn, 8)
	addStroke(btn, theme.Accent, 1)

	btn.MouseEnter:Connect(function()
		tween(btn, {BackgroundColor3 = theme.Hover}, 0.2)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, {BackgroundColor3 = theme.Main}, 0.2)
	end)

	return btn
end

local ungroupInsideBtn = createToolButton("Ungroup with Models Inside", 0)
local normalUngroupBtn  = createToolButton("Normal Ungroup", 1)
local folderUngroupBtn  = createToolButton("Ungroup Folder", 2)
local toolUngroupBtn    = createToolButton("Ungroup Tool", 3)

-- === SELECTION SYSTEM ===
local selectedObject = nil
local function refreshList()
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	for _, obj in ipairs(workspace:GetChildren()) do
		if obj ~= player.Character and (obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("Tool")) then
			local itemBtn = Instance.new("TextButton")
			itemBtn.Size = UDim2.new(1, -10, 0, 30)
			itemBtn.BackgroundColor3 = theme.Main
			itemBtn.TextColor3 = theme.Text
			itemBtn.Font = Enum.Font.Gotham
			itemBtn.TextSize = 16
			itemBtn.Text = obj.Name
			itemBtn.Parent = scrollFrame
			addCorner(itemBtn, 6)

			itemBtn.MouseButton1Click:Connect(function()
				selectedObject = obj
				for _, other in ipairs(scrollFrame:GetChildren()) do
					if other:IsA("TextButton") then
						tween(other, {BackgroundColor3 = theme.Main}, 0.2)
					end
				end
				tween(itemBtn, {BackgroundColor3 = theme.Highlight}, 0.3)
			end)
		end
	end
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end
workspace.ChildAdded:Connect(refreshList)
workspace.ChildRemoved:Connect(refreshList)
refreshList()

-- === OPEN/CLOSE ANIMATIONS ===
openButton.MouseButton1Click:Connect(function()
	frame.Visible = true
	frame.Position = UDim2.new(0.5, -200, 1, 50)
	tween(frame, {Position = UDim2.new(0.5, -200, 0.5, -250)}, 0.6, Enum.EasingStyle.Back)
end)

closeBtn.MouseButton1Click:Connect(function()
	tween(frame, {Position = UDim2.new(0.5, -200, 1, 50)}, 0.5, Enum.EasingStyle.Quad)
	task.wait(0.5)
	frame.Visible = false
end)

-- === UNGROUP FUNCTIONS ===
local function ungroupObject(obj)
	if not obj then return end
	local parent = obj.Parent
	for _, child in ipairs(obj:GetChildren()) do
		child.Parent = parent
	end
	obj:Destroy()
end

ungroupInsideBtn.MouseButton1Click:Connect(function()
	if selectedObject and selectedObject:IsA("Model") then
		ungroupObject(selectedObject)
		refreshList()
	end
end)
normalUngroupBtn.MouseButton1Click:Connect(function()
	if selectedObject and selectedObject:IsA("Model") then
		ungroupObject(selectedObject)
		refreshList()
	end
end)
folderUngroupBtn.MouseButton1Click:Connect(function()
	if selectedObject and selectedObject:IsA("Folder") then
		ungroupObject(selectedObject)
		refreshList()
	end
end)
toolUngroupBtn.MouseButton1Click:Connect(function()
	if selectedObject and selectedObject:IsA("Tool") then
		ungroupObject(selectedObject)
		refreshList()
	end
end)