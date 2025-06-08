--[[ 🧪 ระบบสแกนปุ่มพร้อม UI (เวอร์ชันทดสอบ) ]]
-- ไม่รวมระบบหลัก เช่น Auto Steal / Server Hop
-- รองรับมือถือ / มี ScrollView / เทเลพอร์ตไปหาปุ่มที่เลือก

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ScanButtonUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "📦 ปุ่มทั้งหมดในหน้าจอ"
Title.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.ListLayout = Instance.new("UIListLayout", ScrollFrame)
ScrollFrame.ListLayout.Padding = UDim.new(0, 5)

-- Helper: ตรวจหาตำแหน่งของปุ่มในโลก
local function get3DPositionFromUI(guiObject)
    local success, pos = pcall(function()
        return guiObject.AbsolutePosition + guiObject.AbsoluteSize / 2
    end)
    if not success then return nil end

    local viewportSize = workspace.CurrentCamera.ViewportSize
    local relativePos = pos / viewportSize

    local ray = workspace.CurrentCamera:ViewportPointToRay(pos.X, pos.Y)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.CFrame = CFrame.new(ray.Origin + ray.Direction * 5)
    part.Transparency = 1
    part.Parent = workspace

    return part.Position
end

-- ระบบเทเลพอร์ต
local function teleportTo(position)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    character:PivotTo(CFrame.new(position + Vector3.new(0, 3, 0)))
end

-- ระบบสแกนปุ่มทั้งหมด
local function scanUI()
    ScrollFrame:ClearAllChildren()
    local count = 0

    for _, descendant in pairs(game:GetDescendants()) do
        if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
            if descendant:IsDescendantOf(game.CoreGui) or descendant:IsDescendantOf(LocalPlayer.PlayerGui) then
                local name = descendant.Name
                count += 1

                local button = Instance.new("TextButton", ScrollFrame)
                button.Size = UDim2.new(1, -10, 0, 30)
                button.Text = "[" .. count .. "] " .. name
                button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                button.TextColor3 = Color3.new(1, 1, 1)
                button.Font = Enum.Font.Gotham
                button.TextSize = 14
                button.AutoButtonColor = true

                button.MouseButton1Click:Connect(function()
                    local pos = get3DPositionFromUI(descendant)
                    if pos then
                        teleportTo(pos)
                    end
                end)
            end
        end
    end
end

-- เริ่มต้น
scanUI()

-- ปุ่มรีโหลด (ถ้าคุณต้องการเพิ่ม)
-- คุณสามารถเพิ่มปุ่มเล็ก ๆ ไว้มุมเพื่อให้กดรีสแกนได้ภายหลัง
print("[✅] ระบบสแกนปุ่มโหลดสำเร็จแล้ว!")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- ป้องกันไปซ้อน UI ด้านบน
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 0, 50)
Label.Position = UDim2.new(0, 0, 0, 0)
Label.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Label.Text = "UI โหลดสำเร็จ!"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.SourceSans
Label.TextSize = 24
Label.Parent = MainFrame
