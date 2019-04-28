local game = {}


local Inputmanager = require 'inputmanager'
local Bump = require 'libs/bumps'


players = {
    {name="AAA", power=100, drain=0.5, speed=125, hitbox={x=32*10+3, y=32*14+3, w=26, h=26, type=0}}
}

inputManager = Inputmanager:init(players)
bumpWorld = Bump.newWorld()
fb = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())

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

    if currentLevel.barter == true then
        if currentLevel.menu.selectiontimer > 300 then
            if inputManager.players[1]:down() then
                if currentLevel.menu.selected < #currentLevel.menu.choices then
                    currentLevel.menu.selectiontimer = 0
                    currentLevel.menu.selected = currentLevel.menu.selected + 1
                end
            elseif inputManager.players[1]:up() then
                if currentLevel.menu.selected > 1 then
                    currentLevel.menu.selectiontimer = 0
                    currentLevel.menu.selected = currentLevel.menu.selected - 1
                end
            end
        end

        if inputManager.players[1]:a() then
            players[1].power = players[1].power - currentLevel:barterChoosen()
        end
    else
        local goalX = players[1].hitbox.x
        local goalY = players[1].hitbox.y
        if inputManager.players[1]:down() then
            goalY = players[1].hitbox.y + (players[1].speed * dt)
            if currentLevel.actors[1].currentAnim ~= 1 then
                currentLevel.actors[1].currentAnim = 1
                currentLevel.actors[1].anim[1].time = currentLevel.actors[1].anim[1].speed
            end
        elseif inputManager.players[1]:up() then
            goalY = players[1].hitbox.y - (players[1].speed * dt)
            if currentLevel.actors[1].currentAnim ~= 2 then
                currentLevel.actors[1].currentAnim = 2
                currentLevel.actors[1].anim[2].time = currentLevel.actors[1].anim[2].speed
            end
        end
        if inputManager.players[1]:right() then
            goalX = players[1].hitbox.x + (players[1].speed * dt)
            if currentLevel.actors[1].currentAnim ~= 3 then
                currentLevel.actors[1].currentAnim = 3
                currentLevel.actors[1].anim[3].time = currentLevel.actors[1].anim[3].speed
            end
        elseif inputManager.players[1]:left() then
            goalX = players[1].hitbox.x - (players[1].speed * dt)
            if currentLevel.actors[1].currentAnim ~= 4 then
                currentLevel.actors[1].currentAnim = 4
                currentLevel.actors[1].anim[4].time = currentLevel.actors[1].anim[4].speed
            end
        end

        --TESTING STUFFFF~~~~
        if inputManager.players[1]:b() then
            currentLevel:revealDoors()
        end

        players[1].power = players[1].power - players[1].drain * dt
        if players[1].power < 0 then
            State.switch(States.gameover)
        end

        local actualX, actualY, cols, len = bumpWorld:move(players[1].hitbox, goalX, goalY, bumpFilter)
        DEBUG_BUFFER = DEBUG_BUFFER.."PLAYER "..players[1].hitbox.x.." "..players[1].hitbox.y.." "..players[1].hitbox.w.." "..players[1].hitbox.h.."\n"
        if #cols > 0 then
            for _, col in pairs(cols) do
                DEBUG_BUFFER = DEBUG_BUFFER.."COLISION "..col.other.type.." "..col.type.." "..col.other.x.." "..col.other.y.." "..col.other.w.." "..col.other.h.."\n"

                if currentLevel.doorsVisible and (col.other.type == 10 or col.other.type == 11 or col.other.type == 12) then
                    DEBUG_BUFFER = DEBUG_BUFFER.."PROGREEEEEESSSSSS!!!!! \n"
                    currentLevel:endRoom()
                    levelIndex = levelIndex + 1
                    currentLevel = levels[levelIndex]:init(bumpWorld)
                    actualX = currentLevel.backgroundTiles.tileWidth*10+3 
                    actualY = currentLevel.backgroundTiles.tileHeight*14+3
                    bumpWorld:update(players[1].hitbox, actualX, actualY)
                end
            end
        end
        DEBUG_BUFFER = DEBUG_BUFFER.."ACTUAL "..actualX.." "..actualY.."\n\n"
        players[1].hitbox.x = actualX
        players[1].hitbox.y = actualY
        currentLevel:movePlayerActor(actualX, actualY)
    end
    currentLevel:update(dt)
end

function game:draw()
    love.graphics.push()
    --love.graphics.setCanvas(fb)
    --love.graphics.clear(1/256*32, 1/256*32, 1/256*32,1)

    -- if currentLevel.effect then
    --     love.graphics.setShader(currentLevel.effect)
    --     currentLevel.effect:send("diffuse", fb)
    --     currentLevel.effect:send("light_color", {0.9, 0.4, 0.4}, {0.0, 0.9, 0.0})
    --     currentLevel.effect:send("light_strength", 0.7, 0.7)
    --     currentLevel.effect:send("ambient_color", {0.2, 0.2, 0.9})
    --     currentLevel.effect:send("ambient_strength", 0.5)
    -- end

    currentLevel:draw()

    -- if currentLevel.effect then
    --     love.graphics.setShader()
    -- end
    -- love.graphics.setCanvas()
    love.graphics.pop()
    -- love.graphics.draw(fb)

    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale+2, CONFIG.renderer.scale+2)
    DEBUG_BUFFER = DEBUG_BUFFER.."POWER "..players[1].power.." "..love.graphics.getWidth()/(CONFIG.renderer.scale+2).."\n\n"
    love.graphics.print("POWER "..math.floor(players[1].power).."%", (love.graphics.getWidth()/(CONFIG.renderer.scale+2)/2)-30, 10)
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