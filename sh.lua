---@diagnostic disable: undefined-field
_G.discordia = require("discordia")
_G.client = discordia.Client()
_G.FileReader = require ("fs")
discordia.extensions()
_G.utils = require("./modules/utils")
_G.config = require("./modules/config")
_G.alias = require("./modules/aliases")
_G.keepAlive = require("./modules/keepAlive")
_G.voiceAnnouncements = require("./modules/voiceAnnouncements")
_G.commands = require("./commands")
_G.spawn = require("coro-spawn")
_G.parse = require("url").parse

client:on("ready", function()
    client:setStatus("dnd")
    print(os.date("%F %T", os.time() + 2 * 60 * 60).." | \027[94m[BOT]\027[0m     | "..client.user.username.." is online!")
    _G.bot = client:getUser(client.user.id)
    _G.owner = client:getUser(client.owner.id)
    collectgarbage("collect")
end)

client:on("voiceChannelJoin", function(member, vc)
    announceJoin(member, vc)
end)

client:on("voiceChannelLeave", function(member, vc)
    announceLeave(member, vc)
end)

client:on("voiceUpdate", function(member)
    announceUpdate(member)
end)

client:on("messageCreate", function(message)
    if message.author.bot or message.author == client.user then return end

    if utils.hasPrefix(message.content,prefix) then
        local command = string.sub(message.content,#prefix+1,message.content:find("%s"))
        command = command:gsub("%s+","")
        _cmd, _G.args = message.content:match("^(%S+)%s+(.+)$")

        for key, value in pairs(aliases) do
            if command == key then
                command = value
            end
        end

        -- Run a command if it exists
        if commands[command] then
            commands[command].command(message)
        end
    end
    collectgarbage("collect")
end)

client:run("Bot "..botToken)