if game.PlaceId == 6381829480 or game.PlaceId == 15759515082 then
local sentEntities = {}

-- Function to get current server time in the format: HH:MM:SS
local function getServerTime()
    local time = os.date("*t")
    return string.format("%02d:%02d:%02d", time.hour, time.min, time.sec)
end

-- Main Enemy Finder
local function findEnemy(enemyNames)
    local SeaMonster, CheckGhost

    -- Assign monsters based on the PlaceId
    if game.PlaceId == 6381829480 then
        SeaMonster = game:GetService("Workspace").SeaMonster:GetChildren()
        CheckGhost = (game.Workspace:FindFirstChild("GhostMonster") and game.Workspace.GhostMonster:GetChildren()) or {}
    elseif game.PlaceId == 15759515082 then
        SeaMonster = game:GetService("Workspace").SeaMonster:GetChildren()
        CheckGhost = game:GetService("ReplicatedStorage").MOB:GetChildren()
    else
        SeaMonster = game:GetService("ReplicatedStorage").MOB:GetChildren()
        CheckGhost = game:GetService("ReplicatedStorage").MOB:GetChildren()
    end

    -- Validate enemies
    local function isValidEnemy(enemy)
        return enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0
    end

    -- Check a group of enemies
    local function checkEnemies(enemies)
        for _, enemy in pairs(enemies) do
            if table.find(enemyNames, enemy.Name) and isValidEnemy(enemy) then
                return true
            end
        end
        return false
    end

    -- Search for enemies in defined locations
    return checkEnemies(SeaMonster)
        or checkEnemies(CheckGhost)
        or checkEnemies(workspace.Monster.Mon:GetChildren())
        or checkEnemies(workspace.Monster.Boss:GetChildren())
end

-- Function to send webhook notification with server time
local function sendWebhookNotification(bossName, seaLocation)
    local url = ""
    local serverTime = getServerTime()  -- Get the server time

    -- Determine the appropriate webhook URL based on the sea location
    if seaLocation == "First Sea" then
        url = "https://discord.com/api/webhooks/1312381738026143755/4UnpcmblvReKAgLNq3a7R3HQDel_-tmR07SPmW8Kue3DCDjEidYEdv_ZJKC-hmSEyVKO"
    elseif seaLocation == "Second Sea" then
        url = "https://discord.com/api/webhooks/1312379265903366155/48je4tqZrvUGgLxiI7f9m43vHu76cRnS-KQ4dP4rbvxBVJGnUyUzP1D8jP5LH4u5_hk1"
    elseif seaLocation == "Third Sea" then
        url = "https://discord.com/api/webhooks/1312381654547038312/PBc_A3Z1rslXC-HcC5qqnd70bIe3BkgpuA2oG5BuDByaduwnw29nSOXgD0eoHzWrXI0c"
    end

    -- Prepare the data for the webhook
    local data = {
        ["username"] = 'Zen Hub',
        ["content"] = '',
        ["avatar_url"] = "https://images-ext-1.discordapp.net/external/u9tnnmDGBDMO0KB-7X7byaucIZOhnrAxuygvQVVvGFc/%3Fsize%3D1024/https/cdn.discordapp.com/icons/1189265387217490051/a_d21c49868a7545872e18696c32ac346e.gif",
        ["embeds"] = {
            {
                ["description"] = "**__King Legacy Notifier__**",
                ["color"] = tonumber(0xEEEEEE),
                ["type"] = "rich",
                ["fields"] = {
                    { ["name"] = "[👥] Players Active", ["value"] = '```' .. tostring(#game.Players:GetPlayers()) .. '/12```',["inline"] = true  },
                    { ["name"] = "[🌊] World", ["value"] = '```' .. seaLocation .. '```',["inline"] = true  },
                    { ["name"] = "[⏱️] Server Time", ["value"] = '```' .. serverTime .. '```',["inline"] = true  },
                    { ["name"] = "[🌐] Boss Found", ["value"] = '```' .. bossName .. ' Spawned ✅```', ["inline"] = true },
                    { ["name"] = "[📁] Join Server", ["value"] = '```' .. 'ZenHub_' .. tostring(game.JobId) .. '```' }
                },
                ["footer"] = { ["text"] = "Zen Hub | Webhook" },
                ["timestamp"] = DateTime.now():ToIsoDate()
            }
        }
    }

    -- Send the webhook notification
    local jsonData = game:GetService("HttpService"):JSONEncode(data)
    local headers = { ["content-type"] = "application/json" }
    (http_request or request or HttpPost or syn.request)({ Url = url, Body = jsonData, Method = "POST", Headers = headers })
end

-- Function to check entities and automatically send notifications
local function checkEntities(bosses, seaLocation)
    for entityName, bossName in pairs(bosses) do
        if findEnemy({ entityName }) and not sentEntities[entityName] then
            sendWebhookNotification(bossName, seaLocation)
            sentEntities[entityName] = true  -- Mark entity as sent
        end
    end
end

-- Periodically check for the specified entities
task.spawn(function()
    while task.wait(5) do
        if game.PlaceId == 4520749081 then -- First Sea
            checkEntities({
                ["Skull King"] = "Skull King"
            }, "First Sea")
        elseif game.PlaceId == 6381829480 then -- Second Sea
            checkEntities({
                ["Skull King"] = "Skull King",
                ["Ghost Ship"] = "Ghost Ship",
                ["HydraSeaKing"] = "Hydra Sea King",
                ["SeaKing"] = "Sea King"
            }, "Second Sea")
        elseif game.PlaceId == 15759515082 then -- Third Sea
            checkEntities({
                ["FuryTentacle"] = "Chaos Kraken",
                ["ThirdSeaEldritch Crab"] = "Deepsea Crusher",
                ["ThirdSeaDragon"] = "Drakenfyr the Inferno King",
                ["SeaDragon"] = "Abyssal Tyrant",
                ["Skull King"] = "Skull King"
            }, "Third Sea")
        end
    end
end)

-- World bosses
local worldbosses = {
    ["Jack o lantern [Lv. 10000]"] = "Jack o lantern",
    ["King Samurai [Lv. 3500]"] = "King Samurai",
    ["Dragon [Lv. 5000]"] = "Dragon",
    ["Ms. Mother [Lv. 7500]"] = "Ms. Mother",
    ["Lord of Saber [Lv. 8500]"] = "Lord of Saber",
    ["Bushido Ape [Lv. 5000]"] = "Bushido Ape"
}

local sentEntities1 = {}

-- Function to send webhook notification with server time for world bosses
local function sendWebhookNotificationWorldBoss(bossName)
    local url = "https://discord.com/api/webhooks/1312381738026143755/4UnpcmblvReKAgLNq3a7R3HQDel_-tmR07SPmW8Kue3DCDjEidYEdv_ZJKC-hmSEyVKO"
    local serverTime = getServerTime()  -- Get the server time

    -- Determine the sea location based on PlaceId
    local seaLocation = ""
    if game.PlaceId == 4520749081 then
        seaLocation = "First Sea"
    elseif game.PlaceId == 6381829480 then
        seaLocation = "Second Sea"
    elseif game.PlaceId == 15759515082 then
        seaLocation = "Third Sea"
    end

    -- Prepare the data for the webhook
    local data = {
        ["username"] = 'Zen Hub',
        ["content"] = '',
        ["avatar_url"] = "https://images-ext-1.discordapp.net/external/u9tnnmDGBDMO0KB-7X7byaucIZOhnrAxuygvQVVvGFc/%3Fsize%3D1024/https/cdn.discordapp.com/icons/1189265387217490051/a_d21c49868a7545872e18696c32ac346e.gif",
        ["embeds"] = {
            {
                ["description"] = "**__King Legacy Notifier__**",
                ["color"] = tonumber(0xEEEEEE),
                ["type"] = "rich",
                ["fields"] = {
                    { ["name"] = "[👥] Players Active", ["value"] = '```' .. tostring(#game.Players:GetPlayers()) .. '/12```',["inline"] = true  },
                    { ["name"] = "[🌊] World", ["value"] = '```' .. seaLocation .. '```',["inline"] = true },
                    { ["name"] = "[⏱️] Server Time", ["value"] = '```' .. serverTime .. '```',["inline"] = true },
                    { ["name"] = "[🌐] Boss Found", ["value"] = '```' .. bossName .. ' Spawned ✅```', ["inline"] = true },
                    { ["name"] = "[📁] Join Server", ["value"] = '```' .. 'ZenHub_' .. tostring(game.JobId) .. '```'  }
                },
                ["footer"] = { ["text"] = "Zen Hub | Webhook" },
                ["timestamp"] = DateTime.now():ToIsoDate()
            }
        }
    }

    -- Send the webhook notification
    local jsonData = game:GetService("HttpService"):JSONEncode(data)
    local headers = { ["content-type"] = "application/json" }
    (http_request or request or HttpPost or syn.request)({ Url = url, Body = jsonData, Method = "POST", Headers = headers })
end

-- Function to check world boss entities and automatically send notifications
local function checkWorldBosses()
    for entityName, bossName in pairs(worldbosses) do
        if findEnemy({ entityName }) and not sentEntities1[entityName] then
            sendWebhookNotificationWorldBoss(bossName)
            sentEntities1[entityName] = true  -- Mark world boss as sent
        end
    end
end

-- Periodically check for world bosses
task.spawn(function()
    while task.wait(5) do
        checkWorldBosses()
    end
end)

local sea = game:GetService("ReplicatedStorage"):GetAttribute("ThirdSeaMonsterSpawnText")
local spawnTimeAttribute = game:GetService("ReplicatedStorage"):GetAttribute("ThirdSeaMonsterSpawnTime") -- Example spawn time attribute

-- Flags to track if notifications have been sent
local sentSetSailNotification = false
local sentSpawnApproachingNotification = false

-- Function to send webhook notification
local function sendWebhookNotification(name, timeRemaining)
    local url = "https://discord.com/api/webhooks/1317469523909021746/fzzqpBRFRVHmXRQOsOiYt5wC4tKyEIXb6mOj7JkegC8sRzcBr6yHKppXk_To7cHni0yB"
    
    -- Determine the sea location based on PlaceId
    local seaLocation = ""
    if game.PlaceId == 4520749081 then
        seaLocation = "First Sea"
    elseif game.PlaceId == 6381829480 then
        seaLocation = "Second Sea"
    elseif game.PlaceId == 15759515082 then
        seaLocation = "Third Sea"
    end

    -- Prepare the data for the webhook
    local data = {
        ["username"] = 'Zen Hub',
        ["content"] = '',
        ["avatar_url"] = "https://images-ext-1.discordapp.net/external/u9tnnmDGBDMO0KB-7X7byaucIZOhnrAxuygvQVVvGFc/%3Fsize%3D1024/https/cdn.discordapp.com/icons/1189265387217490051/a_d21c49868a7545872e18696c32ac346e.gif",
        ["embeds"] = {
            {
                ["description"] = "**__King Legacy Notifier__**",
                ["color"] = tonumber(0xEEEEEE),
                ["type"] = "rich",
                ["fields"] = {
                    { ["name"] = "[👥] Players Active", ["value"] = '```' .. tostring(#game.Players:GetPlayers()) .. '/12```' ,["inline"] = true},
                    { ["name"] = "[🌊] World", ["value"] = '```' .. seaLocation .. '```' ,["inline"] = true},
                    { ["name"] = "[🌐] Boss Found", ["value"] = '```' .. name .. '```', ["inline"] = true },
                    { ["name"] = "[⏱️] Time Remaining", ["value"] = '```' .. tostring(math.floor(timeRemaining / 60)) .. ' minutes```', ["inline"] = true },
                    { ["name"] = "[📁] Join Server", ["value"] = '```' .. 'ZenHub_' .. tostring(game.JobId) .. '```' }
                },
                ["footer"] = { ["text"] = "Zen Hub | Webhook" },
                ["timestamp"] = DateTime.now():ToIsoDate()
            }
        }
    }

    -- Send the webhook notification
    local jsonData = game:GetService("HttpService"):JSONEncode(data)
    local headers = { ["content-type"] = "application/json" }
    (http_request or request or HttpPost or syn.request)({ Url = url, Body = jsonData, Method = "POST", Headers = headers })
end

-- Function to check spawn timing
local function checkSailSpawnTime()
    local currentTime = os.time()
    local spawnTime = spawnTimeAttribute -- Replace with your spawn time logic
    if spawnTime then
        local timeRemaining = spawnTime - currentTime
        
        -- Check if spawn time is between 10 minutes and 1 minute
        if timeRemaining > 60 and timeRemaining <= 600 and not sentSpawnApproachingNotification then
            sendWebhookNotification("Spawn approaching", timeRemaining)
            sentSpawnApproachingNotification = true -- Mark that the notification has been sent
        end
    end
end

-- Check if the sea is set to "Set sail!"
local function checkSeaState()
    if sea == "Set sail!" and not sentSetSailNotification then
        sendWebhookNotification("Set sail!", 0) -- 0 indicates no time remaining
        sentSetSailNotification = true -- Mark that the notification has been sent
    end
end

-- Periodically call both functions
while true do
    checkSeaState()
    checkSailSpawnTime()
    task.wait(5) -- Check every 5 seconds
end
end
----///bloxfruit
if game.PlaceId == 2753915549 then
    W1 = true
elseif game.PlaceId == 4442272183 then
    W2 = true
elseif game.PlaceId == 7449423635 then
    W3 = true
end

local NameHub = "Zen Hub(Back)"
local avatar = "https://media.discordapp.net/attachments/1251161660106997781/1484107582250418216/zenhublogowithoutbg.png?ex=69bd0664&is=69bbb4e4&hm=15614ad4d099c7344883f5c4dc7fb781d18380261c5dcd8f3e03b835613ae65f&=&format=webp&quality=lossless&width=438&height=438"
-- getgenv(). Url Webhook 
getgenv().WebhookMirageIsland = "https://discord.com/api/webhooks/1484103393084706876/cZUA0RpLguvEj00lsGeijm0oXXxWTX8lT2vRoDBbb6k39JVbeISQ0_pu-vpxiXr_oOtT" -- url mirage island webhook
getgenv().WebhookFullMoon = "https://discord.com/api/webhooks/1484102774009630771/Nv_LmNrgCwLQJWIjCdHr1IghIb-46ZOcMsGYDUJhrpoNiwqJlpYHwR2qT9wxJ4q0d4AH" -- Url Full Moon Webhook
getgenv().KitsuneIslandWebhook = "https://discord.com/api/webhooks/1484107114044592158/OQY39eyKHfJ5qArCnVSbkaFRerYSk5t6z0xCCO9Is-1JnEnxAw_4ZB0mKoBZC07YKvJg" -- Url Kitsune Webhook
getgenv().FruitSpawned = "https://discord.com/api/webhooks/1484107255124332648/bYHR5aFFyUv_denr0ejA5pQlqIgSGY_eMMMHjLCvlnpHCBtLLvAKwushDXdiH8nvQOgp" -- Url Fruit Spawned Webhook
getgenv().BossSpawned = "https://discord.com/api/webhooks/1484103696135749652/8KspUuPeIq4fhfSe0I7SVR4WNZu6wO4Y5R5eidvPobW5sICHJ0OBK4Elte5no75v__B3" -- Url Boss Spawned webhook 
if W3 then
if game.Workspace._WorldOrigin.Locations:FindFirstChild('Mirage Island') then
    for i, v in pairs(game.Players:GetPlayers()) do
        PlayersMin = i
    end
    if game.Workspace._WorldOrigin.Locations:FindFirstChild('Mirage Island') then
        MirageMessage = '```🟢```'
    else
        MirageMessage = '```❌```'
    end
    JoinServer = 'game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,' ..
        '\'' .. tostring(game.JobId) .. '\'' .. ')'
	local url = getgenv().WebhookMirageIsland                                                                                                                
    local data = {
        ["username"] = NameHub,                                                                                                                                                                                                           
        ['content'] = '',--'<@&1159482607738830928>',                                                                                                                                                                                            
        ["avatar_url"] = avatar,
        ["embeds"] = {
            {
                ["description"] = "**__Mirage Webhook__**",
                ["color"] = tonumber(0x0000FF), -- color id		#
                ["type"] = "rich",
                ["fields"] = {
                    {
                        ["name"] = "[👥] Players Active",
                        ["value"] = '```' .. tostring(PlayersMin) .. '/12```'
                    },
                    {
                        ["name"] = "[📃] JobID",
                        ["value"] = '```' .. tostring(game.JobId) .. '```'
                    },
                    {
                        ["name"] = "[📁] Join Server",
                        ["value"] = '```' .. JoinServer .. '```',
                    },
                    {
                        ["name"] = "[🌴] Mirage Check",
                        ["value"] = MirageMessage,
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "Zen Hub | Webhook", 
                },
                ["timestamp"] = DateTime.now():ToIsoDate(),
            }
        },
    }
    request = http_request or request or HttpPost or syn.request
    request({ Url = url, Body = game:GetService("HttpService"):JSONEncode(data), Method = "POST", Headers = { ["content-type"] = "application/json" } })
    end
end
    
local MoonCheck = {['2'] = "http://www.roblox.com/asset/?id=9709149431", ['1'] = "http://www.roblox.com/asset/?id=9709149052",};
if W3 then
for i, v in pairs(MoonCheck) do
    if  game:GetService("Lighting").Sky.MoonTextureId == tonumber(i) or game:GetService("Lighting").Sky.MoonTextureId == v then
        local Moon = {
            ['8'] = "http://www.roblox.com/asset/?id=9709149431", -- 🌕
            ['7'] = "http://www.roblox.com/asset/?id=9709149052", -- 🌖
            ['6'] = "http://www.roblox.com/asset/?id=9709143733", -- 🌗
            ['5'] = "http://www.roblox.com/asset/?id=9709150401", -- 🌘
            ['4'] = "http://www.roblox.com/asset/?id=9709135895",  -- 🌑
            ['3'] = "http://www.roblox.com/asset/?id=9709139597", -- 🌒
            ['2'] = "http://www.roblox.com/asset/?id=9709150086", -- 🌓
            ['1'] = "http://www.roblox.com/asset/?id=9709149680", -- 🌔
        };
        
        for i, v in pairs(Moon) do
            if game:GetService("Lighting").Sky.MoonTextureId == v then
                MoonPercent = i / 8 * 100
            end
        end
        
        for i, v in pairs(game.Players:GetPlayers()) do
            PlayersMin = i
        end
        
        if game:GetService("Lighting").Sky.MoonTextureId == Moon['1'] then
            MoonIcon = '🌔'
        elseif game:GetService("Lighting").Sky.MoonTextureId == Moon['2'] then
            MoonIcon = '🌓'
        elseif game:GetService("Lighting").Sky.MoonTextureId == Moon['3'] then
            MoonIcon = '🌒'
        elseif game:GetService("Lighting").Sky.MoonTextureId == Moon['4'] then
            MoonIcon = '🌑'
        elseif game:GetService("Lighting").Sky.MoonTextureId == Moon['5'] then
            MoonIcon = '🌘'
        elseif game:GetService("Lighting").Sky.MoonTextureId == Moon['6'] then
            MoonIcon = '🌘'
        elseif game:GetService("Lighting").Sky.MoonTextureId == Moon['7'] then
            MoonIcon = '🌖'
        elseif game:GetService("Lighting").Sky.MoonTextureId == Moon['8'] then
            MoonIcon = '🌕'
        end
        MoonMessage = '```' .. tostring(MoonPercent .. '%' .. ' : ' .. MoonIcon) .. '```'
        JoinServer = 'game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,' ..
            '\'' .. tostring(game.JobId) .. '\'' .. ')'
        
        local url = getgenv().WebhookFullMoon
        local data = {
            ["username"] = NameHub,                                                                                                                                                                                                          
            ['content'] = '',--'<@&1159482607738830928>',                                                                                                                                                                                             
            ["avatar_url"] = avatar, 
            ["embeds"] = {
                {
                    ["description"] = "**__Moon__**",
                    ["color"] = tonumber(0x0000FF), 
                    ["type"] = "rich",
                    ["fields"] = {
                        {
                            ["name"] = "[👥] Players Active",
                            ["value"] = '```' .. tostring(PlayersMin) .. '/12```'
                        },
                        {
                            ["name"] = "[📃] JobID",
                            ["value"] = '```' .. tostring(game.JobId) .. '```'
                        },
                        {
                            ["name"] = "[📁] Join Server",
                            ["value"] = '```' .. JoinServer .. '```',
                        },
                        {
                            ["name"] = "[🕑] Moon Check",
                            ["value"] = MoonMessage,
                            ["inline"] = true
                        },
                        
                    },
                    ["footer"] = {
                        ["text"] = "Zen Hub | Webhook", 
                    },
                    ["timestamp"] = DateTime.now():ToIsoDate(),
                }
            },
        }
        request = http_request or request or HttpPost or syn.request
        request({ Url = url, Body = game:GetService("HttpService"):JSONEncode(data), Method = "POST", Headers = { ["content-type"] = "application/json" } })
        end
    end
end
if W3 then 
if game.Workspace._WorldOrigin.Locations:FindFirstChild('Kitsune Island') then
    for i, v in pairs(game.Players:GetPlayers()) do
        PlayersMin = i 
    end
    if game.Workspace._WorldOrigin.Locations:FindFirstChild('Kitsune Island') then
        KitsuneMassasge = '```🟢```'
    else
        KitsuneMassasge = '```❌```'
    end
    
    JoinServer = 'game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,' ..
        '\'' .. tostring(game.JobId) .. '\'' .. ')'
    

    local url = getgenv().KitsuneIslandWebhook                                                                                                              
    local data = {
        ["username"] = NameHub,                                                                                                                                                                                                           
        ['content'] = '',--'<@&1159482607738830928>',                                                                                                                                                                                            
        ["avatar_url"] = avatar, 
        ["embeds"] = {
            {
                ["description"] = "**__Kitsune Webhook__**",
                ["color"] = tonumber(0x0000FF), -- color id		#
                ["type"] = "rich",
                ["fields"] = {
                    {
                        ["name"] = "[👥] Players Active",
                        ["value"] = '```' .. tostring(PlayersMin) .. '/12```'
                    },
                    {
                        ["name"] = "[📃] JobID",
                        ["value"] = '```' .. tostring(game.JobId) .. '```'
                    },
                    {
                        ["name"] = "[📁] Join Server",
                        ["value"] = '```' .. JoinServer .. '```',
                    },
                    {
                        ["name"] = "[🦊] Kitsune Check",
                        ["value"] = KitsuneMassasge,
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "Zen Hub | Webhook", 
                },
                ["timestamp"] = DateTime.now():ToIsoDate(),
            }
        },
    }
    request = http_request or request or HttpPost or syn.request
    request({ Url = url, Body = game:GetService("HttpService"):JSONEncode(data), Method = "POST", Headers = { ["content-type"] = "application/json" } })
    end
end
for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
    if  v:IsA("Tool") and string.find(v.Name,"Fruit") then        
        if game.PlaceId == 2753915549 then
            WorldCheck = "World: 1"
        elseif game.PlaceId == 4442272183 then
            WorldCheck = "World: 2"
        elseif game.PlaceId == 7449423635 then
            WorldCheck = "World: 3"
        end
        for i, v in pairs(game.Players:GetPlayers()) do
            PlayersMin = i
        end
        
        for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name,"Fruit") then 
               NameFruit = v
            end
        end

        JoinServer = 'game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,' ..
            '\'' .. tostring(game.JobId) .. '\'' .. ')'
        
        local url = getgenv().FruitSpawned
        local data = {
            ["username"] = NameHub,                                                                                                                                                                                                          
            ['content'] = '',--'<@&1159482607738830928>',                                                                                                                                                                                             
            ["avatar_url"] =avatar, 
            ["embeds"] = {
                {
                    ["description"] = "**__Fruit Spawned__**",
                    ["color"] = tonumber(0x0000FF), 
                    ["type"] = "rich",
                    ["fields"] = {
                        {
                            ["name"] = "[👥] Players Active",
                            ["value"] = '```' .. tostring(PlayersMin) .. '/12```'
                        },
                        {
                            ["name"] = "[📃] JobID",
                            ["value"] = '```' .. tostring(game.JobId) .. '```'
                        },
                        {
                            ["name"] = "[📁] Join Server",
                            ["value"] = '```' .. JoinServer .. '```',
                        },
                        {
                            ["name"] = "[🌎] World",
                            ["value"] = '```' .. tostring(WorldCheck) .. '```'
                        },
                        {
                            ["name"] = "[🍈] Fruit Spawned ",
                            ["value"] = '```' .. tostring(NameFruit) .. '```',
                            ["inline"] = true
                        },
                        
                    },
                    ["footer"] = {
                        ["text"] = "Zen Hub | Webhook", 
                    },
                    ["timestamp"] = DateTime.now():ToIsoDate(),
                }
            },
        }
        request = http_request or request or HttpPost or syn.request
        request({ Url = url, Body = game:GetService("HttpService"):JSONEncode(data), Method = "POST", Headers = { ["content-type"] = "application/json" } })
    end
end

local bossNames = {"Cyborg", "The Gorilla King", "Wysper", "Thunder God", "Mob Leader", "Bobby", "Saber Expert","Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Ice Admiral","Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral","Tide Keeper", "Darkbeard", "Stone", "Island Empress", "Kilo Admiral", "Captain Elephant","Beautiful Pirate", "Longma", "Cake Queen", "Greybeard", "Order", "Cursed Captain", "Soul Reaper","Rip indra", "Mihawk Boss", "Cake Prince", "Dough King", "Cursed Skeleton Boss", "rip_indra", "Orbitus" , "Heaven's Guardian","Hydra Leader", "Hell's Messenger",  "Tyrant of the Skies", "Leviathan" , "Rip Commander", "Red Commander","Anchored Terrorshark", "Agony", "Ashen", "Unbound Werewolf"}
for _, bossName in ipairs(bossNames) do
if game.PlaceId == 2753915549 then
    WorldCheck = "World: 1"
elseif game.PlaceId == 4442272183 then
    WorldCheck = "World: 2"
elseif game.PlaceId == 7449423635 then
    WorldCheck = "World: 3"
end
local MBoss = {}
for _, v in pairs(game.ReplicatedStorage:GetChildren()) do
    for _, bossName in ipairs(bossNames) do
        if string.find(v.Name, bossName) then
            table.insert(MBoss, v.Name)
            break  
        end
    end
end
for i, v in pairs(game.Players:GetPlayers()) do
    PlayersMin = i
end
JoinServer = 'game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,' ..
'\'' .. tostring(game.JobId) .. '\'' .. ')'


local MBSBoss = table.concat(MBoss, ", ")  
local url = getgenv().BossSpawned
local data = {
    ["username"] = NameHub,
    ['content'] = '',
    ["avatar_url"] = avatar, 
    ["embeds"] = {
        {
            ["description"] = "**__Boss Spawned__**",
            ["color"] = tonumber(0x0000FF), 
            ["type"] = "rich",
            ["fields"] = {
                {
                    ["name"] = "[👥] Players Active",
                    ["value"] = '```' .. tostring(PlayersMin) .. '/12```'
                },
                {
                    ["name"] = "[📃] JobID",
                    ["value"] = '```' .. tostring(game.JobId) .. '```'
                },
                {
                    ["name"] = "[📁] Join Server",
                    ["value"] = '```' .. tostring(JoinServer) .. '```',
                },
                {
                    ["name"] = "[🌎] World",
                    ["value"] = '```' .. tostring(WorldCheck) .. '```'
                },
                {
                    ["name"] = "[👹] Boss Check",
                    ["value"] = '```' .. tostring(MBSBoss) .. '```',
                    ["inline"] = true
                },
                
            },
            ["footer"] = {
                ["text"] = "Zen Hub | Webhook", 
            },
            ["timestamp"] = DateTime.now():ToIsoDate(),
        }
    },
}

request = http_request or request or HttpPost or syn.request
request({ Url = url, Body = game:GetService("HttpService"):JSONEncode(data), Method = "POST", Headers = { ["content-type"] = "application/json" } })
break
end