-- [[ KA HUB | FIX DEFINITIVO DELTA ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "KA HUB | SEA 1 PRO",
   LoadingTitle = "A Carregar Interface...",
   ConfigurationSaving = { Enabled = false }
})

-- CONFIGS INICIAIS
_G.AutoFarm = false
_G.Weapon = "Melee"

local Tab = Window:CreateTab("Farm Principal")

Tab:CreateToggle({
   Name = "ATIVAR AUTO FARM",
   CurrentValue = false,
   Callback = function(v) _G.AutoFarm = v end,
})

Tab:CreateDropdown({
   Name = "Escolher Arma",
   Options = {"Melee", "Sword", "Fruit"},
   CurrentOption = "Melee",
   Callback = function(v) _G.Weapon = v end,
})

-- LOOP DE FARM (SÓ EXECUTA SE LIGAR O TOGGLE)
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local lp = game.Players.LocalPlayer
                local level = lp.Data.Level.Value
                
                -- Posições Básicas Sea 1
                local qName, qLvl, mName, qPos
                if level < 10 then
                    qName = "BanditQuest1"; qLvl = 1; mName = "Bandit"; qPos = CFrame.new(1059, 15, 1550)
                else
                    qName = "JungleQuest"; qLvl = 1; mName = "Monkey"; qPos = CFrame.new(-1598, 35, 153)
                end

                if not lp.PlayerGui.Main.Quest.Visible then
                    lp.Character.HumanoidRootPart.CFrame = qPos
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", qName, qLvl)
                else
                    local target = workspace.Enemies:FindFirstChild(mName)
                    if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                        -- Equipar
                        local tool = lp.Backpack:FindFirstChild(_G.Weapon) or lp.Character:FindFirstChild(_G.Weapon)
                        if tool then lp.Character.Humanoid:EquipTool(tool) end
                        -- Ataque
                        lp.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, true, game, 0)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, false, game, 0)
                    end
                end
            end)
        end
    end
end)
