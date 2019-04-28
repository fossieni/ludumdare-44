local Inputmanager = {}
Inputmanager.__index = Inputmanager

function Inputmanager:init(players)
    local manager = {}
    setmetatable(manager,Inputmanager)

    love.mouse.setVisible(false)

    local joysticks = love.joystick.getJoysticks()
    local kbdmaps = {
        {up="up", down="down", left="left", right="right", a="m", b="n"},
        {up="w", down="s", left="a", right="d", a="lctrl", b="lshift"}
    }

    manager.players = {}

    for i, player in pairs(players) do
        local playerctl = {
            type = 0,
            guid = "",
            controller = {},
            up = nil,
            down = nil,
            left = nil,
            right = nil,
            a = nil,
            b = nil,
        }
        if i <= #joysticks and joysticks[i]:isGamepad() then
            playerctl.type = 1
            playerctl.guid = joysticks[i]:getGUID()
            playerctl.controller = joysticks[i]
            playerctl.up = function () return playerctl.controller:isGamepadDown("dpup") end
            playerctl.down = function () return playerctl.controller:isGamepadDown("dpdown") end
            playerctl.left = function () return playerctl.controller:isGamepadDown("dpleft") end
            playerctl.right = function () return playerctl.controller:isGamepadDown("dpright") end
            playerctl.a = function () return playerctl.controller:isGamepadDown("a") end
            playerctl.b = function () return playerctl.controller:isGamepadDown("b") end
        else
            if #kbdmaps > 0 then
                playerctl.type = 2
                playerctl.guid = i
                playerctl.controller = table.remove(kbdmaps, 1)
                playerctl.up = function () return love.keyboard.isDown(playerctl.controller.up) end
                playerctl.down = function () return love.keyboard.isDown(playerctl.controller.down) end
                playerctl.left = function () return love.keyboard.isDown(playerctl.controller.left) end
                playerctl.right = function () return love.keyboard.isDown(playerctl.controller.right) end
                playerctl.a = function () playerctl.yep=true return love.keyboard.isDown(playerctl.controller.a) end
                playerctl.b = function () return love.keyboard.isDown(playerctl.controller.b) end
            end
        end
        manager.players[i] = playerctl
    end

    return manager
end

function Inputmanager:update(dt)
    if DEBUG then
        DEBUG_BUFFER = DEBUG_BUFFER .. "Total joysticks = "..#love.joystick.getJoysticks().."\n"
        for i, player in pairs(self.players) do
            local keys = ""
            if player.left() then keys = keys.." left " end
            if player.up() then keys = keys.." up " end
            if player.right() then keys = keys.." right " end
            if player.down() then keys = keys.." down " end
            if player.a() then keys = keys.." a " end
            if player.b() then keys = keys.." b " end

            DEBUG_BUFFER = DEBUG_BUFFER .. "Player "..i..": ".." ["..player.type.."] "..player.guid.."\n"
            DEBUG_BUFFER = DEBUG_BUFFER .. "          "..keys.."\n"
        end
    end
end

return Inputmanager