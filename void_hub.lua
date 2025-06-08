-- ตัวแปรพื้นฐาน
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- UI สร้างพื้นฐาน
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScanUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 350)
Frame.Position = UDim2.new(0, 20, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Frame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

-- ปุ่ม Reset
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(1, 0, 0, 40)
ResetBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
ResetBtn.TextColor3 = Color3.new(1,1,1)
ResetBtn.Font = Enum.Font.SourceSansBold
ResetBtn.TextSize = 20
ResetBtn.Text = "Reset Scan"
ResetBtn.Parent = Frame

-- ส่วนแสดงผลลัพธ์สแกน
local ScannedListFrame = Instance.new("ScrollingFrame")
ScannedListFrame.Size = UDim2.new(1, 0, 1, -50)
ScannedListFrame.Position = UDim2.new(0, 0, 0, 40)
ScannedListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScannedListFrame.ScrollBarThickness = 6
ScannedListFrame.BackgroundTransparency = 1
ScannedListFrame.Parent = Frame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScannedListFrame
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 3)

-- ฟังก์ชันสแกนปุ่มและ NPC รอบตัว (10 studs)
local function ScanNearbyObjects()
    local foundObjects = {}

    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return {} end

    -- เคลียร์ผลลัพธ์เก่าใน UI
    for _, child in pairs(ScannedListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name and obj.Name ~= "" then
            local distance = (obj.Position - rootPart.Position).Magnitude
            if distance <= 10 then
                -- หลีกเลี่ยงซ้ำชื่อ
                if not foundObjects[obj] then
                    foundObjects[obj] = true

                    -- สร้างปุ่ม UI สำหรับแต่ละปุ่มที่พบ
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -10, 0, 30)
                    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    btn.TextColor3 = Color3.new(1,1,1)
                    btn.Font = Enum.Font.SourceSans
                    btn.TextSize = 18
                    btn.Text = obj.Name
                    btn.Parent = ScannedListFrame

                    -- กดปุ่มแล้ววาร์ปไปหาวัตถุนั้น
                    btn.MouseButton1Click:Connect(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                        end
                    end)
                end
            end
        end
    end

    -- ปรับ CanvasSize ตามจำนวนปุ่ม
    local totalSize = ListLayout.AbsoluteContentSize.Y
    ScannedListFrame.CanvasSize = UDim2.new(0, 0, 0, totalSize + 10)
end

-- เรียกสแกนครั้งแรกตอนเปิด UI
ScanNearbyObjects()

-- รีสแกนเมื่อกดปุ่ม Reset
ResetBtn.MouseButton1Click:Connect(function()
    ScanNearbyObjects()
end)
