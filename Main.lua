local BotCreator = {}
local Commands = {}
local Loops = {}

local ChatListener = loadstring(game:HttpGet("https://raw.githubusercontent.com/Crvstal8100/ChatListener/main/Main.lua", true))

local Players = game:GetService("Players")

local function OnChatted(msg, speaker)
    if getgenv().BC and getgenv().BC["Owner"] then
        if typeof(getgenv().BC["Owner"]) == "string" and speaker.Name == getgenv().BC["Owner"] or typeof(getgenv().BC["Owner"]) == "number" and speaker.UserId == getgenv().BC["Owner"] then
            for i, v in pairs(Commands) do
                if v["LowerString"] == true then
                    if string.lower(i) == string.lower(msg) then
                        pcall(v["Callback"], speaker)
                    end
                else
                    if i == msg then
                        pcall(v["Callback"], speaker)
                    end
                end
            end
        end
    end
end

for i, v in pairs(Players:GetPlayers()) do
    ChatListener:Listen(v, OnChatted)
end

Players.PlayerAdded:Connect(function(player)
    ChatListener:Listen(player, OnChatted)
end)

Players.PlayerRemoving:Connect(function(player)
    ChatListener:StopListening(player)
end)

function BotCreator:CreateCommand(Options)
    Options = Options or {}

    if Options and typeof(Options) == "table" and Options["Command"] and typeof(Options["Command"]) == "string" then
        if not Commands[Options["Command"]] then
            Commands[Options["Command"]] = {
                ["LowerString"] = Options["LowerString"] or false,
                ["Callback"] = Options["Callback"] or function ()
                    
                end
            }
        end 
    end
end

function BotCreator:CreateLoop(Options)
    Options = Options or {}

    if Options and typeof(Options) == "table" and Options["Loop"] and typeof(Options["Loop"]) == "string" then
        if not Loops[Options["Loop"]] then
            Loops[Options["Loop"]] = {
                ["Callback"] = Options["Callback"] or function ()
                    
                end
            }

            local Connection = nil
            Connection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
                if Loops[Options["Loop"]] then
                    pcall(Loops[Options["Loop"]]["Callback"])
                else
                    if Connection ~= nil then
                        Connection:Disconnect()
                        Connection = nil
                    end
                end
            end)

            local options = {}

            function options:Connect()
                if Connection ~= nil then
                    Connection:Connect()
                end
            end

            function options:Disconnect()
                if Connection ~= nil then
                    Connection:Disconnect()
                end
            end

            function options:Delete()
                if Loops[Options["Loop"]] then
                    Loops[Options["Loop"]] = nil
                end
            end

            return options
        end
    end
end

return BotCreator
