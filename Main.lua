local BotCreator = {}

local Information = {
    Loops = {},
    Commands = {},
    Owner = nil,
    Bot = nil,
    Action = getgenv().Settings["Action"]
}

local ChatListener = loadstring(game:HttpGet("https://raw.githubusercontent.com/Crvstal8100/ChatListener/main/Main.lua", true))()

local Players = game:GetService("Players")

Information["Bot"] = game:GetService("Players").LocalPlayer

for i, v in pairs(Players:GetPlayers()) do
    if string.find(getgenv().BC["Owner"], v.Name) or string.find(getgenv().BC["Owner"], v.UserId) then
        if Information["Bot"] == v then
            v:Kick("You've executed on the wrong account.")
        end

        Information["Owner"] = v
    end
end

Players.PlayerAdded:Connect(function(player)
    if string.find(getgenv().BC["Owner"], player.Name) or string.find(getgenv().BC["Owner"], player.UserId) then
        if Information["Owner"] ~= player then
            if Information["Bot"] == player then
                player:Kick("You've executed on the wrong account.")
            end
    
            Information["Owner"] = player
        end
    end
end)

if getgenv().BC["AntiCheatBypass"] then
	grm = getrawmetatable(game)
	setreadonly(grm, false)
	old = grm.__namecall
	grm.__namecall = newcclosure(function(self, ...)
	    local args = {...}
	    if tostring(args[1]) == "TeleportDetect" then
	        return
	    elseif tostring(args[1]) == "CHECKER_1" then
	        return
	    elseif tostring(args[1]) == "CHECKER" then
	        return
	    elseif tostring(args[1]) == "GUI_CHECK" then
	        return
	    elseif tostring(args[1]) == "OneMoreTime" then
	        return
	    elseif tostring(args[1]) == "checkingSPEED" then
	        return
	    elseif tostring(args[1]) == "BreathingHAMON" then
	        return
	    elseif tostring(args[1]) == "BANREMOTE" then
	        return
	    elseif tostring(args[1]) == "PERMAIDBAN" then
	        return
	    elseif tostring(args[1]) == "KICKREMOTE" then
	        return
	    elseif tostring(args[1]) == "BR_KICKPC" then
	        return
	    elseif tostring(args[1]) == "BR_KICKMOBILE" then
	        return
	    end
	    return old(self, ...)
	end)
end

local function OnChatted(message, speaker)
    if getgenv().BC and getgenv().BC["Owner"] then
        if typeof(getgenv().BC["Owner"]) == "string" and speaker.Name == getgenv().BC["Owner"] or typeof(getgenv().BC["Owner"]) == "number" and speaker.UserId == getgenv().BC["Owner"] then
            for i, v in pairs(Information["Commands"]) do
                local messageArguments = string.split(message, " ")
                local command = messageArguments[1]

                if v["LowerString"] == true then
                    if string.lower(command) == string.lower(i) then
                        table.remove(messageArguments, 1)

                        pcall(v["Callback"], {["Owner"] = Information["Owner"], ["Bot"] = Information["Bot"], ["Arguments"] = messageArguments})
                    else
                        if v["Aliases"] then
                            if typeof(v["Aliases"]) == "table" then
                                for _, a in pairs(v["Aliases"]) do
                                    if string.lower(command) == string.lower(a) then
                                        table.remove(messageArguments, 1)
        
                                        pcall(v["Callback"], {["Owner"] = Information["Owner"], ["Bot"] = Information["Bot"], ["Arguments"] = messageArguments})
                                        break
                                    end
                                end
                            end
                        end
                    end
                else
                    if command == i then
                        table.remove(messageArguments, 1)

                        pcall(v["Callback"], {["Owner"] = Information["Owner"], ["Bot"] = Information["Bot"], ["Arguments"] = messageArguments})
                    else
                        if v["Aliases"] then
                            if typeof(v["Aliases"]) == "table" then
                                for _, a in pairs(v["Aliases"]) do
                                    if command == a then
                                        table.remove(messageArguments, 1)
        
                                        pcall(v["Callback"], {["Owner"] = Information["Owner"], ["Bot"] = Information["Bot"], ["Arguments"] = messageArguments})
                                        break
                                    end
                                end
                            end
                        end
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

function BotCreator:AddAction(Options)
    if not table.find(Information["Action"], Options["Action"]) then
        table.insert(Information["Action"], Options["Action"])
    else
        warn("This action is already in the table.")
    end
end

function BotCreator:RemoveAction(Options)
    if Information["Action"][Options["Action"]] then
        Information["Action"][Options["Action"]] = nil
    else
        warn("The specified action couldn't be found.")
    end
end

function BotCreator:ClearAction()
    for i,v in pairs(Information["Action"]) do
	    Information["Action"][i] = nil
    end
end

function BotCreator:CreateCommand(Options)
    Options = Options or {}

    if Options and typeof(Options) == "table" and Options["Command"] and typeof(Options["Command"]) == "string" then
        if not Information["Commands"][Options["Command"]] then
            Information["Commands"][Options["Command"]] = {
                ["LowerString"] = Options["LowerString"] or false,
                ["Aliases"] = Options["Aliases"] or {},
                ["Callback"] = Options["Callback"] or function ()
                        
                end
            }

            local options = {}

            function options:Delete()
                if Information["Commands"][Options["Command"]] then
                    Information["Commands"][Options["Command"]] = nil
                end
            end
        end 
    end
end

function BotCreator:CreateAction(Options)
    Options = Options or {}

    if Options and typeof(Options) == "table" and Options["Loop"] and typeof(Options["Loop"]) == "string" then
        if not Information["Loops"][Options["Loop"]] then

            Information["Loops"][Options["Loop"]] = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
                if table.find(Information["Action"], Options["Loop"]) then
                    pcall(Options["Callback"], {["Owner"] = Information["Owner"], ["Bot"] = Information["Bot"]}) 
                end
            end)

            local options
        
            function options:Delete()
                if Information["Loops"][Options["Loop"]] then
                    Information["Loops"][Options["Loop"]]:Disconnect()
                    Information["Loops"][Options["Loop"]] = nil 
                end
            end

            return options
        end
    end
end

return BotCreator
