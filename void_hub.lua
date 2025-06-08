-- VoidHub Scan Buttons Test Script for Roblox Delta (Mobile)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ฟังก์ชันสแกนปุ่มทั่วแมพ (Workspace + PlayerGui)
local function scanButtons()
    local foundButtons = {}

    -- ฟังก์ชันตรวจสอบว่าตัว Object เป็นปุ่มหรือไม่ (TextButton หรือ ImageButton)
    local function isButton(obj)
        return obj:IsA("TextButton") or obj:IsA("ImageButton")
    end

    -- สแกนใน Workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if isButton(obj) then
            table.insert(foundButtons, obj)
        end
    end

    -- สแกนใน PlayerGui
    if LocalPlayer:FindFirstChild("PlayerGui") then
        for _, obj in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if isButton(obj) then
                table.insert(foundButtons, obj)
            end
        end
    end

    return foundButtons
end

-- สร้าง UI แบบเลื่อนขึ้นลงได้
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScanButtonsUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 400)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = "Scan Buttons List"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 20
    Title.Parent = Frame

    -- ScrollFrame สำหรับรายชื่อปุ่ม
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
    ScrollFrame.Position = UDim2.new(0, 5, 0, 40)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.ScrollBarThickness = 8
    ScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ScrollFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    return ScreenGui, ScrollFrame, UIListLayout
end

-- ฟังก์ชันวาร์ปไปหาปุ่ม
local function teleportToButton(button)
    -- เช็คว่า button ยังอยู่ในเกมไหม
    if not button or not button:IsDescendantOf(game) then
        warn("ปุ่มไม่พบในเกม")
        return
    end

    -- พยายามหา Position ของปุ่มในโลกจริง
    local pos

    if button:IsA("GuiObject") then
        -- ถ้าเป็น UI ให้ลองหาพิกัดบนหน้าจอ (ตำแหน่ง UI อาจไม่เกี่ยวกับตำแหน่ง 3D)
        warn("ไม่สามารถวาร์ปไป UI ได้โดยตรง")
        return
    elseif button:IsA("BasePart") then
        pos = button.Position
    else
        -- พยายามหา .Position หรือ .CFrame (ถ้ามี)
        if button:IsA("Model") and button:FindFirstChild("PrimaryPart") then
            pos = button.PrimaryPart.Position
        elseif button:IsA("Instance") and button:FindFirstChild("Position") then
            pos = button.Position
        else
            warn("ไม่พบตำแหน่งของปุ่ม")
            return
        end
    end

    if pos then
        -- Tween ตัวละครไปตำแหน่งนั้น (ยกสูงขึ้นเล็กน้อย)
        local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local goal = {}
            goal.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
            tween:Play()
        else
            warn("ไม่พบ HumanoidRootPart")
        end
    end
end

-- ฟังก์ชันสร้างปุ่มใน UI สำหรับแต่ละปุ่มที่เจอ
local function createButtonItem(parent, button)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16

    -- ตั้งชื่อปุ่มจากชื่อ Object
    btn.Text = button.Name or "Unnamed"

    btn.Parent = parent

    -- เมื่อกดปุ่ม ให้วาร์ปไปตำแหน่งปุ่มนั้น
    btn.MouseButton1Click:Connect(function()
        teleportToButton(button)
    end)

    return btn
end

-- เริ่มทำงาน
local ScreenGui, ScrollFrame, UIListLayout = createUI()

local function refreshButtonList()
    -- ลบของเดิมออกก่อน
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local buttons = scanButtons()

    for _, btn in ipairs(buttons) do
        createButtonItem(ScrollFrame, btn)
    end

    -- อัปเดต CanvasSize ของ ScrollFrame ตามจำนวนปุ่ม
    local listLength = #buttons
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLength * 35)
end

refreshButtonList()

-- ตัวเลือกเพิ่ม: สแกนซ้ำเมื่อกดปุ่ม "R" (ในมือถืออาจเปลี่ยนเป็นปุ่ม UI)
RunService.RenderStepped:Connect(function()
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.R) then
        refreshButtonList()
    end
end)

print("ระบบสแกนปุ่ม พร้อมใช้งานแล้ว")
