-- VOID HUB SCRIPT
-- ระบบจัดลำดับความสำคัญ:
-- 1. Auto Test
-- 2. Auto Boss Event
-- 3. Auto Infinite Castle
-- 4. Auto Dungeon
-- 5. Auto Farm Boss

local VoidHub = {}

-- 🌟 UI SETTINGS
VoidHub.UI = {
    Categories = {
        ["Auto Combat"] = {
            -- รวม Auto Test, Auto Infinite Castle, Auto Dungeon
            AutoTest = {
                Enabled = false,
                Delay = 5,
                ToggleButton = true,
            },
            AutoInfiniteCastle = {
                Enabled = false,
                ToggleButton = true,
            },
            AutoDungeon = {
                Enabled = false,
                AutoLeaveAfterBoss = true,
                LeaveDelay = 5,
                ToggleButton = true,
                AutoRuneEquip = {
                    Enabled = false,
                    SelectedRune = nil,
                    AvailableRunes = {},
                    AddRuneButton = true,
                },
            },
        },

        ["Auto Boss Farm"] = {
            AutoBossFarm = {
                Enabled = false,
                ToggleButton = true,
            },
            MovementSetting = {
                Mode = "Fly", -- หรือ "Teleport"
                Speed = 1000, -- max 10000
                TeleportDelay = 1.0, -- min 0.1 max 5.0
                ValidateSpeed = function(mode, value)
                    if mode == "Fly" then
                        return math.min(value, 10000)
                    else
                        return math.clamp(value, 0.1, 5.0)
                    end
                end,
            },
            AutoClick = {
                Enabled = false,
                UnlimitedSpeed = true,
                ToggleButton = true,
            },
            FarmMode = {
                Selected = "Arise", -- หรือ "Destroy"
            },
            BossTargetSelector = {
                SelectedBossName = nil,
                AvailableBosses = {}, -- auto-detected
                MaxHP = 0,
            },
        },

        ["Auto Boss Event"] = {
            Enabled = false,
            ToggleButton = true,
            PrioritizedTimeCheck = true,
            AutoLeaveCurrentActivity = true,
            Modes = {
                ["Snow Wraith"] = {
                    Time = {"00", "30"},
                    Weekend = {"00", "30"},
                },
                ["Ant Island"] = {
                    Time = {"15"},
                    Weekend = {"15", "45"},
                },
            },
        },

        ["Shop"] = {
            AutoBuyGems = {
                Enabled = false,
                ToggleButton = true,
            },
        },
    }
}

-- 🧠 ลำดับความสำคัญของระบบ (ใช้ใน scheduler)
VoidHub.PriorityOrder = {
    "AutoTest",
    "AutoBossEvent",
    "AutoInfiniteCastle",
    "AutoDungeon",
    "AutoBossFarm",
}

-- 🛠 ตัวอย่างฟังก์ชันลอจิกใน Scheduler
function VoidHub:Scheduler()
    for _, system in ipairs(self.PriorityOrder) do
        local cat = self:GetCategoryForSystem(system)
        local config = self.UI.Categories[cat][system]
        if config and config.Enabled then
            self:RunSystem(system, config)
            break -- ทำแค่ระบบสำคัญสุดก่อน
        end
    end
end

function VoidHub:GetCategoryForSystem(systemName)
    for category, systems in pairs(self.UI.Categories) do
        if systems[systemName] then
            return category
        end
    end
    return nil
end

function VoidHub:RunSystem(systemName, config)
    -- ลงรายละเอียดแต่ละระบบได้ที่นี่ เช่น RunAutoTest(config), RunDungeon(config)
end

return VoidHub
