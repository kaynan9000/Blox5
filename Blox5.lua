-- [[ KA HUB | VERSÃO SIMPLIFICADA E FUNCIONAL ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // CONFIGURAÇÕES (Começa tudo desligado)
_G.AutoFarm = false
_G.AutoStats = false
_G.Weapon = "Melee"
_G.StatFocus = "Melee"

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")

-- // JANELA SIMPLES
local Window = Rayfield:CreateWindow({
   Name = "KA HUB | MINI",
   LoadingTitle = "A carregar...",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Principal")

-- // BOTÕES
Tab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Callback = function(v) _G.AutoFarm = v end,
})

Tab:CreateDropdown({
   Name = "Escolher Arma",
   Options = {"Melee", "Sword", "Fruit"},
   CurrentOption = "Melee",
   Callback = function(v) _G.Weapon = v end,
})

Tab:CreateToggle({
   Name = "Auto Stats (Pontos)",
   CurrentValue = false,
   Callback = function(v) _G.AutoStats = v end,
})

Tab:CreateDropdown({
   Name = "Focar Pontos em:",
   Options = {"Melee", "Defense", "Sword", "Blox Fruit"},
   CurrentOption = "Melee",
   Callback = function(v) _G.StatFocus = v end,
})

-- // LÓGICA DE FARM (SEA 1)
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local lvl = LP.Data.Level.Value
                local qName, qLvl, mName, qPos
                
                -- Tabela de Nível Básica
                if lvl < 10 then
                    qName = "BanditQuest1"; qLvl = 1; mName = "Bandit"; qPos = CFrame.new(1059, 15, 1550)
                elseif lvl < 15 then
                    qName = "JungleQuest"; qLvl = 1; mName = "Monkey"; qPos = CFrame.new(-1598, 35, 153)
                else
                    qName = "JungleQuest"; qLvl = 2; mName = "Gorilla"; qPos = CFrame.new(-1598, 35, 153)
                end

                if not LP.PlayerGui.Main.Quest.Visible then
                    LP.Character.HumanoidRootPart.CFrame = qPos
                    RS.Remotes.CommF_:InvokeServer("StartQuest", qName, qLvl)
                else
                    local enemy = workspace.Enemies:FindFirstChild(mName)
                    if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        -- Equipar
                        local tool = LP.Backpack:FindFirstChild(_G.Weapon) or LP.Character:FindFirstChild(_G.Weapon)
                        if tool then LP.Character.Humanoid:EquipTool(tool) end
                        -- Farm
                        LP.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
                        VIM:SendMouseButtonEvent(500, 500, 0, true, game, 0)
                        VIM:SendMouseButtonEvent(500, 500, 0, false, game, 0)
                    end
                end
            end)
        end
    end
end)

-- // LÓGICA DE STATS
task.spawn(function()
    while task.wait(1) do
        if _G.AutoStats then
            local p = LP.Data.StatsPoints.Value
            if p > 0 then
                RS.Remotes.CommF_:InvokeServer("AddPoint", _G.StatFocus, p)
            end
        end
    end
end)

Rayfield:Notify({Title = "KA HUB", Content = "Pronto a usar!", Duration = 3})
