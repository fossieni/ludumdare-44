local game = {}


local Inputmanager = require 'inputmanager'
local Bump = require 'libs/bumps'


players = {
    {name="AAA", speed=25, hitbox={x=35, y=35, w=10, h=10, type=0}, gfxoffset={x=-11, y=-11}}
}
inputManager = Inputmanager:init(players)
bumpWorld = Bump.newWorld()
RoomMaze = require 'roommaze'
currentLevel = RoomMaze:init(bumpWorld)


function game:init()
end

function game:enter()

    bumpWorld:add(players[1].hitbox, players[1].hitbox.x, players[1].hitbox.y, players[1].hitbox.w, players[1].hitbox.h)
end

function game:update(dt)

    local bumpFilter = function(item, other)
        if other.type == 1 then return 'slide'
--        if other.type == 0  then return 'cross'
--        elseif other.type then return 'touch'
--        elseif other.type then return 'bounce'
        else return 'slide'
        end
    end

    inputManager:update(dt)
    local goalX = players[1].hitbox.x
    local goalY = players[1].hitbox.y
    if inputManager.players[1]:down() then
        goalY = players[1].hitbox.y + (players[1].speed * dt)
    elseif inputManager.players[1]:up() then
        goalY = players[1].hitbox.y - (players[1].speed * dt)
    end
    if inputManager.players[1]:right() then
        goalX = players[1].hitbox.x + (players[1].speed * dt)
    elseif inputManager.players[1]:left() then
        goalX = players[1].hitbox.x - (players[1].speed * dt)
    end

    local actualX, actualY, cols, len = bumpWorld:move(players[1].hitbox, goalX, goalY, bumpFilter)
    DEBUG_BUFFER = DEBUG_BUFFER.."PLAYER "..players[1].hitbox.x.." "..players[1].hitbox.y.." "..players[1].hitbox.w.." "..players[1].hitbox.h.."\n"
    if #cols > 0 then
        for _, col in pairs(cols) do
            DEBUG_BUFFER = DEBUG_BUFFER.."COLISION "..col.other.type.." "..col.type.." "..col.other.x.." "..col.other.y.." "..col.other.w.." "..col.other.h.."\n"
        end
    end
    DEBUG_BUFFER = DEBUG_BUFFER.."ACTUAL "..actualX.." "..actualY.."\n"
    players[1].hitbox.x = actualX
    players[1].hitbox.y = actualY
    currentLevel:movePlayerActor(actualX, actualY)
    currentLevel:update(dt)
end

function game:draw()
    currentLevel:draw()
    if DEBUG then
        love.graphics.push()
        love.graphics.scale(CONFIG.renderer.scale, CONFIG.renderer.scale)
        love.graphics.setColor(0,1,0,0.25)
        for _, player in pairs(players) do
            love.graphics.rectangle("fill", player.hitbox.x, player.hitbox.y, player.hitbox.w, player.hitbox.h)
        end
        love.graphics.pop()
    end
end

function game:joystickpressed(joystick, button)
    inputManager:joystickpressed(joystick, button)
end
function game:joystickreleased(joystick, button)
    inputManager:joystickreleased(joystick, button)
end

return game