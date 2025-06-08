-- สคริปต์สแกนปุ่ม + วาร์ปบนมือถือ Roblox

repeat wait() until game:IsLoaded()
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- จับ UI ปุ่มในหน้าจอทุกช่อง
-- (มาแต่งโค้ดนี้ต่อได้ตามเกมของคุณ)
local function scanButtons()
    local btns = {}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            if obj:IsDescendantOf(playerGui) or obj:IsDescendantOf(game.CoreGui) then
                table.insert(btns, obj)
            end
        end
    end
    return btns
end

-- เทคนิควาร์ป: แปลง UI เป็น world position แล้ววาร์ปตัวละคร
local function teleportToUI(btn)
    local cam = workspace.CurrentCamera
    local screenPos = btn.AbsolutePosition + btn.AbsoluteSize/2
    local ray = cam:ViewportPointToRay(screenPos.X, screenPos.Y)
    local targetPos = ray.Origin + ray.Direction * 10
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(targetPos) end
end

-- แสดง UI สแกนปุ่ม
local sg = Instance.new("ScreenGui", playerGui)
sg.Name = "ScanUI"
local fr = Instance.new("Frame", sg)
fr.Size = UDim2.new(0, 300, 0, 400)
fr.Position = UDim2.new(0.5, -150, 0.5, -200)
fr.BackgroundColor3 = Color3.fromRGB(40,40,40)
fr.Active = true; fr.Draggable = true

local tf = Instance.new("TextLabel", fr)
tf.Size = UDim2.new(1,0,0,40)
tf.BackgroundColor3 = Color3.fromRGB(60,60,60)
tf.Text = "สแกนปุ่มในหน้าจอ"
tf.TextColor3 = Color3.new(1,1,1)
tf.TextScaled = true

local sf = Instance.new("ScrollingFrame", fr)
sf.Position = UDim2.new(0,0,0,40)
sf.Size = UDim2.new(1,0,1,-40)
sf.CanvasSize = UDim2.new(0,0,0,0)
sf.ScrollBarThickness = 6
local list = Instance.new("UIListLayout", sf)
list.Padding = UDim.new(0,5)

-- สร้างรายการปุ่มให้กด
local function populate()
    for _, v in pairs(sf:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local btns = scanButtons()
    for i, btn in ipairs(btns) do
        local item = Instance.new("Frame", sf)
        item.Size = UDim2.new(1,-10,0,40)
        item.Position = UDim2.new(0,5,0,(i-1)*45)
        item.BackgroundColor3 = Color3.fromRGB(70,70,70)

        local lbl = Instance.new("TextLabel", item)
        lbl.Text = btn.Name
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(0.6,0,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.TextScaled = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local wp = Instance.new("TextButton", item)
        wp.Text = "Warp"
        wp.Size = UDim2.new(0.3,-10,1,-10)
        wp.Position = UDim2.new(0.7,5,0,5)
        wp.BackgroundColor3 = Color3.fromRGB(0,120,215)
        wp.TextColor3 = Color3.new(1,1,1)
        wp.TextScaled = true

        wp.MouseButton1Click:Connect(function()
            teleportToUI(btn)
        end)
    end
    sf.CanvasSize = UDim2.new(0,0,0,#btns*45)
end

populate()
