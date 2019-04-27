local game = {}


local Inputmanager = require 'inputmanager'
local Bump = require 'libs/bumps'


players = {
    {name="AAA", power=100, speed=25, hitbox={x=16*5+3, y=16*8+3, w=10, h=10, type=0}, gfxoffset={x=-11, y=-11}}
}
inputManager = Inputmanager:init(players)
bumpWorld = Bump.newWorld()

RoomMaze = require 'roommaze'
RoomMaze2 = require 'roommaze2'

levels = {
    [1] = RoomMaze,
    [2] = RoomMaze
}

levelIndex = 1
currentLevel = nil

function game:init()
end

function game:enter()
    currentLevel = levels[levelIndex]:init(bumpWorld)
    bumpWorld:add(players[1].hitbox, players[1].hitbox.x, players[1].hitbox.y, players[1].hitbox.w, players[1].hitbox.h)
end

function game:update(dt)

    local bumpFilter = function(item, other)
        if other.type == 1 then return 'slide'
            
        elseif other.type == 10 or other.type == 11 or other.type == 12 then
            if currentLevel.doorsVisible == true then return 'cross' 
            else return 'slide'
            end
--        elseif other.type then return 'touch'
--        elseif other.type then return 'bounce'
        else return 'cross'
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

    --TESTING STUFFFF~~~~
    if inputManager.players[1]:a() then
        currentLevel:revealDoors()
    end
    if inputManager.players[1]:b() then
        currentLevel:barterChoosen()
    end

    local actualX, actualY, cols, len = bumpWorld:move(players[1].hitbox, goalX, goalY, bumpFilter)
    DEBUG_BUFFER = DEBUG_BUFFER.."PLAYER "..players[1].hitbox.x.." "..players[1].hitbox.y.." "..players[1].hitbox.w.." "..players[1].hitbox.h.."\n"
    if #cols > 0 then
        for _, col in pairs(cols) do
            DEBUG_BUFFER = DEBUG_BUFFER.."COLISION "..col.other.type.." "..col.type.." "..col.other.x.." "..col.other.y.." "..col.other.w.." "..col.other.h.."\n"

            if currentLevel.doorsVisible and (col.other.type == 10 or col.other.type == 11 or col.other.type == 12) then
                DEBUG_BUFFER = DEBUG_BUFFER.."PROGREEEEEESSSSSS!!!!! \n"
                levelIndex = levelIndex + 1
                currentLevel = levels[levelIndex]:init(bumpWorld)
                actualX = currentLevel.backgroundTiles.tileWidth*4+3 
                actualY = currentLevel.backgroundTiles.tileHeight*8+3
                bumpWorld:update(players[1].hitbox, actualX, actualY)
            end
        end
    end
    DEBUG_BUFFER = DEBUG_BUFFER.."ACTUAL "..actualX.." "..actualY.."\n\n"
    players[1].hitbox.x = actualX
    players[1].hitbox.y = actualY
    currentLevel:movePlayerActor(actualX, actualY)
    currentLevel:update(dt)
end

function game:draw()
    currentLevel:draw()

    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale, CONFIG.renderer.scale)
    DEBUG_BUFFER = DEBUG_BUFFER.."POWER "..players[1].power.." "..love.graphics.getWidth()/CONFIG.renderer.scale.."\n\n"
    love.graphics.print("POWER "..players[1].power.."%", (love.graphics.getWidth()/CONFIG.renderer.scale/2)-30, 10)
    love.graphics.pop()


    if DEBUG then
        love.graphics.push()
        love.graphics.translate(currentLevel.offsetX, currentLevel.offsetY)
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